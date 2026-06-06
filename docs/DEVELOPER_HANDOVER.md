# DEVELOPER_HANDOVER.md — Memory Jar

> Everything a new engineer (or AI agent) needs to start work without asking questions.

---

## 1. TL;DR

Memory Jar is a two-tier app: **Flutter mobile** talking REST to a **Spring Boot backend**, with a Quartz scheduler that fires deliveries every 60s. The mobile app is functional end-to-end (create + list + delete) against a not-yet-existent backend, and the backend is wired (build, config, deps) but has zero Java sources. **The single most important fact: `IMPLEMENTED_COMPONENTS.md` overstates what's on disk.** Always verify with `Glob`/`Read`.

**Before writing any UI code, read [`../DESIGN_SYSTEM.md`](../DESIGN_SYSTEM.md).** It defines colors, typography, motion, components, screen layouts, and the acceptance checklist for any new screen. It is the single source of truth for visual design.

---

## 2. Environment Requirements

| Tool | Version | How to verify |
|---|---|---|
| JDK | 21+ (project pins 23 in `build.gradle` toolchain) | `java -version` |
| Gradle | Wrapper bundled (`gradlew`) — uses Spring Boot 4.0.6 | `./gradlew --version` (or `gradlew.bat` on Windows) |
| Flutter | SDK with Dart `^3.9.2` | `flutter --version` |
| Android Studio / Xcode | Optional, for device run | n/a |
| PostgreSQL | Required only for production profile | `psql --version` |
| Twilio account | Required for Phase 2 | https://console.twilio.com |
| H2 | Embedded in dev, no install | n/a (in-memory) |

---

## 3. Project Layout

```
D:\projects\memory jar\
├── FULL_IMPLEMENTATION_GUIDE.md    # vision, architecture, roadmap (READ FIRST)
├── IMPLEMENTED_COMPONENTS.md        # claimed status (DRIFT — see §6)
├── AI_PROJECT_MEMORY.md             # machine-readable project memory
├── SYSTEM_ARCHITECTURE.md           # Mermaid diagrams
├── DEVELOPER_HANDOVER.md            # this file
├── FEATURE_TRACKER.md               # feature status + completion %
├── AI_CONTEXT.md                    # ultra-compressed LLM context
│
├── memory-jar-backend\              # Spring Boot (Java 23, Boot 4.0.6)
│   ├── build.gradle
│   ├── settings.gradle
│   └── src\main\resources\application.properties
│
└── memory_jar_mobile\               # Flutter
    ├── pubspec.yaml
    └── lib\
        ├── main.dart
        ├── models\memory.dart
        ├── services\api_service.dart
        └── screens\{home_screen,create_memory_screen}.dart
```

---

## 4. How to Run

### Backend (dev, H2)
```bash
cd "D:/projects/memory jar/memory-jar-backend"
./gradlew bootRun               # macOS/Linux
.\gradlew.bat bootRun           # Windows
# H2 console: http://localhost:8080/h2-console
# JDBC URL: jdbc:h2:mem:memoryjardb
# User: sa  Pass: password
```
> The app **will not start** because no `main` class exists. This is the first thing to fix.

### Mobile (dev)
```bash
cd "D:/projects/memory jar/memory_jar_mobile"
flutter pub get
flutter run                       # pick a device
# To talk to a local backend on your host machine:
#   - Android emulator: baseUrl=http://10.0.2.2:8080/api (already set)
#   - iOS sim / web / desktop: change ApiService.baseUrl to http://localhost:8080/api
```

---

## 5. Current State by Component

| Area | Status | Detail |
|---|---|---|
| Backend Gradle config | ✅ done | Java 23, Spring Boot 4.0.6, JPA, Quartz, H2, PostgreSQL, Lombok |
| `application.properties` | ✅ done | H2 in-memory, JPA `update` DDL, debug logging |
| Backend Java sources | ❌ missing | `Memory` entity, repository, service, controller, Quartz job, config are NOT on disk |
| Flutter `Memory` model | ✅ done | 3 enums + JSON ser/des |
| Flutter `ApiService` | ✅ done | `http://10.0.2.2:8080/api`, CRUD |
| Flutter `HomeScreen` | ✅ done | List + refresh + delete + FAB |
| Flutter `CreateMemoryScreen` | ✅ done | Form + date/time + channel checkboxes |
| Flutter `main.dart` | ✅ done | Material 3, deepPurple seed |
| Twilio delivery | ❌ missing | No SDK, no service classes, no creds |
| Email delivery | ❌ missing | No provider chosen |
| S3/Firebase media | ❌ missing | No SDK, no UI |
| Glassmorphism UI | ❌ missing | Plain Material 3 only |
| AI features | ❌ missing | Roadmap only |
| Auth | ❌ missing | None |
| Tests | 🟡 stub | Only `memory_jar_mobile/test/widget_test.dart` default |

**Completion (rough):** ~25–30% of the full vision. Foundation is in place; delivery and UX layers are the bulk of remaining work.

---

## 6. Known Issues / Documentation Drift

1. **`IMPLEMENTED_COMPONENTS.md` overstates backend completion.** It lists `Memory.java`, `MemoryRepository.java`, `MemoryService.java`, `MemoryController.java`, `MemoryDeliveryJob.java`, `QuartzConfig.java` as implemented. **None of these files exist on disk.** This is the single biggest source of confusion for new agents.
   - **Action:** before claiming a backend file exists, run `Glob` for `**/*.java` under `memory-jar-backend/src/`. It currently returns zero results.

2. **No `main` class for Spring Boot.** Without `@SpringBootApplication`, `./gradlew bootRun` fails immediately. Create `src/main/java/com/memoryjar/MemoryJarApplication.java`.

3. **`delivery_channels` storage is undefined.** Mobile sends a `List`, but the JPA entity to receive it doesn't exist yet. Decide on join table vs CSV vs JSONB before writing the entity (join table is recommended in `SYSTEM_ARCHITECTURE.md` §6).

4. **No `audio upload` path exists** even though `record` and `path_provider` are in `pubspec.yaml`. They're declared but unused. The create form hard-codes `MemoryType.TEXT`.

5. **No CORS configuration.** Flutter on web will fail to reach the backend. Add a `WebMvcConfigurer` bean if web is in scope.

6. **No retry/backoff on Quartz failures.** A failed Twilio call will mark the memory `FAILED` and stop trying. Add a `delivery_attempts` table and an exponential-backoff policy before any production use.

7. **No tests.** The Flutter `widget_test.dart` is the auto-generated counter-test stub. No backend tests exist.

---

## 7. Important Files (cheat sheet)

| File | Why it matters |
|---|---|
| `memory-jar-backend/build.gradle` | Java/Spring versions, dep list. Add Twilio + mail starter here. |
| `memory-jar-backend/src/main/resources/application.properties` | DB, logging. Add Twilio/Mail creds here (or externalize). |
| `memory_jar_mobile/lib/api_service.dart` | Hard-coded base URL. Will need to change for prod. |
| `memory_jar_mobile/lib/models/memory.dart` | The contract the mobile app expects the backend to honor. |
| `memory_jar_mobile/lib/screens/create_memory_screen.dart` | Form schema. UI is the easiest place to discover missing fields. |
| `memory_jar_mobile/pubspec.yaml` | Mobile deps. Anything new (e.g. `provider`, `dio`, `image_picker`) goes here. |
| `FULL_IMPLEMENTATION_GUIDE.md` | Vision doc — read for *what should exist*, not *what does*. |
| `IMPLEMENTED_COMPONENTS.md` | **Treat as untrusted** until verified against disk. |

---

## 8. How to Continue Development

### Recommended next milestone: **finish Phase 1 by creating the missing backend sources**, then start Phase 2 (Twilio).

Order of work (small, verifiable steps):

1. **Create `MemoryJarApplication.java`** (`@SpringBootApplication`). Confirm `./gradlew bootRun` boots.
2. **Create `Memory` JPA entity** mirroring the Dart `Memory` model + enums. Choose join-table for channels.
3. **Create `MemoryRepository`** (Spring Data) with `findByStatusAndDeliveryDateLessThanEqual(MemoryStatus, LocalDateTime)`.
4. **Create `MemoryService`** (create / list / delete).
5. **Create `MemoryController`** exposing `GET/POST/DELETE /api/memories`.
6. **Create `MemoryDeliveryJob`** (Quartz `@DisallowConcurrentExecution`) — initially a no-op log, then a real dispatcher.
7. **Create `QuartzConfig`** with a 60s simple trigger.
8. **Add CORS** for `http://localhost:*` and emulator origins.
9. **Add Twilio SDK** to `build.gradle`; externalize credentials in `application.properties`.
10. **Implement `DeliveryService` interface** + `TwilioDeliveryService` + `EmailDeliveryService` (per `SYSTEM_ARCHITECTURE.md` §4).
11. **Wire `MemoryDeliveryJob`** to dispatch by channel and update status.
12. **Smoke test:** create a memory with `deliveryDate` 30 seconds out via the Flutter app; confirm `DELIVERED` after the next Quartz tick.
13. **Update `IMPLEMENTED_COMPONENTS.md`** to reference the new files; cross-link to `FEATURE_TRACKER.md`.

### Conventions to follow

- **Java package root:** `com.memoryjar.*`
- **Lombok:** use `@Data`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` on entities.
- **Naming:** services end in `Service`, repositories in `Repository`, jobs in `Job`, configs in `Config`.
- **Flutter:** stick to `setState` for now; migrate to `provider`/`riverpod` when state complexity grows.
- **Testing:** add a JUnit test per service + at least one integration test for the controller + one for the Quartz job. On mobile, add a `Memory.fromJson` test.

### Out of scope for next milestone (do not start)

- S3/Firebase upload (Phase 3)
- Glassmorphism UI (Phase 4)
- AI summaries/montages (Phase 5)
- Auth (separate milestone, should come after Phase 2 is testable end-to-end)

---

## 9. Quick Reference: Useful Commands

```bash
# Find any Java file (will return 0 results today)
find "D:/projects/memory jar/memory-jar-backend" -name "*.java"

# Verify Flutter deps resolved
cd "D:/projects/memory jar/memory_jar_mobile" && flutter pub get

# Start backend once it has a main class
cd "D:/projects/memory jar/memory-jar-backend" && ./gradlew bootRun

# Lint mobile
cd "D:/projects/memory jar/memory_jar_mobile" && flutter analyze

# Hit the H2 console after boot
# Browser: http://localhost:8080/h2-console
# JDBC URL: jdbc:h2:mem:memoryjardb
# User: sa   Pass: password
```
