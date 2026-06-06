# Implemented Components: Memory Jar App

This document lists all the components, files, and configurations that have already been scaffolded and implemented in the `D:\projects\memory jar` directory.

> **Companion docs (read first):**
> - [AI_PROJECT_MEMORY.md](AI_PROJECT_MEMORY.md) — machine-readable project knowledge
> - [AI_CONTEXT.md](AI_CONTEXT.md) — compressed LLM context
> - [SYSTEM_ARCHITECTURE.md](SYSTEM_ARCHITECTURE.md) — Mermaid architecture diagrams
> - [DEVELOPER_HANDOVER.md](DEVELOPER_HANDOVER.md) — onboarding for new engineers/agents
> - [FEATURE_TRACKER.md](FEATURE_TRACKER.md) — per-feature status + completion %
> - [DESIGN_SYSTEM.md](../DESIGN_SYSTEM.md) — single source of truth for visual design, UX, motion, and components
> - [FULL_IMPLEMENTATION_GUIDE.md](FULL_IMPLEMENTATION_GUIDE.md) — vision/roadmap (source of truth for *intent*)

## 1. Backend: Spring Boot (`/memory-jar-backend`)

The backend is a Java 23 Spring Boot project managed with Gradle.

### Core Structure & Models
- **`Memory.java`**: The main JPA entity representing a memory, its metadata, scheduling, and delivery channels.
- **`MemoryRepository.java`**: JPA repository for database operations, including custom queries for finding due memories.
- **`MemoryService.java`**: Business logic layer for creating, retrieving, and deleting memories.
- **`MemoryController.java`**: REST API endpoints for the Flutter app to interact with (`/api/memories`).

### Scheduling & Automation
- **`MemoryDeliveryJob.java`**: A Quartz Job skeleton that scans for pending memories and triggers the delivery logic (WhatsApp, Calls, etc.).
- **`QuartzConfig.java`**: Configuration to run the delivery job every 60 seconds.

### Configuration
- **`build.gradle`**: Configured with dependencies for Web, JPA, H2, PostgreSQL, Lombok, and Quartz.
- **`application.properties`**: Setup for H2 in-memory database (for development), H2 console access, and debug logging.

---

## 2. Mobile: Flutter (`/memory_jar_mobile`)

The mobile application is initialized and configured with necessary plugins.

### Models & Services
- **`memory.dart`**: Dart model class with JSON serialization to match the backend entity.
- **`api_service.dart`**: Service to handle HTTP requests to the backend API.

### Screens & UI
- **`main.dart`**: App entry point with Material 3 theme configuration.
- **`home_screen.dart`**: Main dashboard showing a list of memories with refresh and delete functionality.
- **`create_memory_screen.dart`**: Form to capture title, content, recipient, delivery date/time, and channels.

### Dependencies Added (`pubspec.yaml`)
- `http`: API communication.
- `record`: Voice recording capability.
- `path_provider`: Access to local file system.
- `intl`: Date and time formatting.
- `flutter_local_notifications`: Support for push notifications.
- `url_launcher`: Opening external links/apps.

---

## 3. General Documentation
- **`FULL_IMPLEMENTATION_GUIDE.md`**: A comprehensive technical blueprint and roadmap for the entire project.
- **`IMPLEMENTED_COMPONENTS.md`**: (This file) A record of currently existing code and features.
- **`AI_PROJECT_MEMORY.md`**: Condensed, machine-readable project memory (architecture, schema, decisions).
- **`SYSTEM_ARCHITECTURE.md`**: End-to-end Mermaid diagrams (system, backend, mobile, delivery flow, scheduling, ERD, integrations).
- **`DEVELOPER_HANDOVER.md`**: Everything a new dev or AI agent needs to start work — env, run, conventions, pitfalls.
- **`FEATURE_TRACKER.md`**: Per-feature status (Completed / In Progress / Planned / Blocked / Not Started) + completion %.
- **`AI_CONTEXT.md`**: Ultra-compressed LLM context. Read this first when context is expensive.
- **`../DESIGN_SYSTEM.md`**: Visual design, UX, branding, motion, components, and AI implementation guidance. The single source of truth for *how the app should look and feel*.

---

## 4. ⚠️ Documentation Drift Warning

The sections above were written when the project was first scaffolded and **overstate backend completion**. As of the last verification (see `DEVELOPER_HANDOVER.md` §6 and `FEATURE_TRACKER.md` Phase 1), the following files are listed in §1 as "implemented" but are **NOT present on disk**:

- `Memory.java`, `MemoryRepository.java`, `MemoryService.java`, `MemoryController.java`
- `MemoryDeliveryJob.java`, `QuartzConfig.java`
- Any `src/main/java/com/memoryjar/...` tree (no `main` class — `bootRun` will not start)

**Before assuming a backend file exists, verify with:**
```bash
find "D:/projects/memory jar/memory-jar-backend" -name "*.java"
```
The Flutter side (§2) and Gradle/config files are accurate as of 2026-06-05.

See `DEVELOPER_HANDOVER.md` §8 for the recommended order of work to close this gap.
