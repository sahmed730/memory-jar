# AI_PROJECT_MEMORY.md — Memory Jar

> Condensed, machine-readable project knowledge. Source of truth: disk state at `D:\projects\memory jar\` (inspected 2026-06-05). Companion to `FULL_IMPLEMENTATION_GUIDE.md` (vision) and `IMPLEMENTED_COMPONENTS.md` (claimed state).

---

## 1. Project Identity

- **Name:** Memory Jar
- **Type:** Cross-platform mobile + REST backend
- **Purpose:** Digital time-capsule app. Users create memories (text/audio/image/video/document) and schedule future delivery via WhatsApp, phone call, SMS, email, or push notification.
- **Repo root:** `D:\projects\memory jar\`
- **Two sub-projects:** `memory-jar-backend/` (Spring Boot) and `memory_jar_mobile/` (Flutter).

---

## 2. Tech Stack (verified on disk)

| Layer | Choice | Notes |
|---|---|---|
| Backend language | Java 23 (toolchain pinned in `build.gradle`) | |
| Backend framework | Spring Boot 4.0.6 (via Gradle plugin) | |
| Build | Gradle (Groovy DSL) | |
| Persistence | Spring Data JPA + Hibernate | |
| DB (dev) | H2 in-memory `jdbc:h2:mem:memoryjardb` | Console at `/h2-console` |
| DB (prod) | PostgreSQL (driver on runtime classpath) | DSN not yet configured |
| Scheduling | `spring-boot-starter-quartz` | Job defined to fire every 60s |
| Lombok | `compileOnly` + `annotationProcessor` | |
| Mobile framework | Flutter 3.9.2+ (Dart `^3.9.2`) | |
| HTTP client | `http: ^1.6.0` | |
| Audio capture | `record: ^6.2.1` | |
| FS access | `path_provider: ^2.1.5` | |
| i18n/date | `intl: ^0.20.2` | |
| Local notif | `flutter_local_notifications: ^20.1.0` | |
| URL launch | `url_launcher: ^6.3.2` | |
| Cupertino icons | `cupertino_icons: ^1.0.8` | |
| Lints | `flutter_lints: ^5.0.0` | |

**Planned but NOT in build files yet:** Twilio SDK, AWS S3 SDK, Mailgun/SMTP client.

---

## 3. Folder Structure (actual)

```
D:\projects\memory jar\
├── FULL_IMPLEMENTATION_GUIDE.md        # vision/roadmap
├── IMPLEMENTED_COMPONENTS.md            # claimed completed components (has drift, see §9)
├── AI_PROJECT_MEMORY.md                # this file
├── SYSTEM_ARCHITECTURE.md              # Mermaid architecture diagrams
├── DEVELOPER_HANDOVER.md               # onboarding guide
├── FEATURE_TRACKER.md                  # feature-by-feature status
├── AI_CONTEXT.md                       # ultra-compressed LLM context
│
├── memory-jar-backend\
│   ├── build.gradle                     # Java 23, Spring Boot 4.0.6, JPA, Quartz, H2, PostgreSQL, Lombok
│   ├── settings.gradle
│   ├── gradle\wrapper\
│   ├── .gradle\                         # build cache
│   └── src\
│       └── main\
│           └── resources\
│               └── application.properties   # H2 + JPA + logging config
│   # NOTE: NO Java source files exist yet under src/main/java (see §9 drift)
│
└── memory_jar_mobile\
    ├── pubspec.yaml                     # Flutter deps listed above
    ├── pubspec.lock
    ├── analysis_options.yaml
    ├── web\manifest.json
    └── lib\
        ├── main.dart                    # Material 3, deepPurple seed, HomeScreen entry
        ├── models\
        │   └── memory.dart              # Memory entity + 3 enums + JSON ser/des
        ├── services\
        │   └── api_service.dart         # baseUrl=http://10.0.2.2:8080/api, CRUD via http
        └── screens\
            ├── home_screen.dart         # List of Card+ListTile, refresh, FAB to create
            └── create_memory_screen.dart # Form: title/content/recipient/date-time/channels
    └── test\
        └── widget_test.dart
```

---

## 4. Database Schema (inferred, not yet declared in code)

No JPA entities exist on disk; the **expected** schema based on the Flutter `Memory` model and guide §3.1 is:

```
memories
  id                  BIGINT  PK  auto
  title               VARCHAR  NOT NULL
  content             TEXT     NOT NULL
  type                VARCHAR  NOT NULL   -- TEXT|AUDIO|IMAGE|VIDEO|DOCUMENT
  media_url           VARCHAR  NULL
  delivery_date       TIMESTAMP NOT NULL
  delivery_channels   VARCHAR  NOT NULL   -- CSV or join (see §5 ambiguity)
  status              VARCHAR  NOT NULL   -- PENDING|DELIVERED|FAILED  (default PENDING)
  recipient_identifier VARCHAR NOT NULL
  created_at          TIMESTAMP DEFAULT now()
```

Indices needed: `(status, delivery_date)` to support the Quartz due-memory scan.

**Ambiguity to resolve:** `delivery_channels` is multi-valued. Choose between (a) comma-separated string, (b) `JSONB` (Postgres), or (c) join table `memory_channels(memory_id, channel)`. Option (c) is cleanest; the Flutter side already sends it as a `List`.

---

## 5. API Surface (intended, not yet implemented server-side)

Base path: `/api`. All endpoints expected by the Flutter `ApiService`:

| Method | Path | Request | Response | Status |
|---|---|---|---|---|
| `GET` | `/memories` | — | `List<Memory>` | ❌ server missing |
| `POST` | `/memories` | `Memory` JSON | `Memory` JSON | ❌ server missing |
| `DELETE` | `/memories/{id}` | — | `204 No Content` | ❌ server missing |

`Memory` JSON shape (per `memory.dart`):
```json
{
  "id": 0,
  "title": "string",
  "content": "string",
  "type": "TEXT|AUDIO|IMAGE|VIDEO|DOCUMENT",
  "mediaUrl": "string|null",
  "deliveryDate": "ISO-8601",
  "deliveryChannels": ["WHATSAPP", ...],
  "status": "PENDING|DELIVERED|FAILED",
  "recipientIdentifier": "string",
  "createdAt": "ISO-8601|null"
}
```

Error contract is undefined. `ApiService` throws `Exception('Failed to ...')` on non-2xx; the create screen surfaces this in a `SnackBar`.

---

## 6. Implemented vs. Missing (file-grounded)

**Implemented (on disk, code-level):**
- Backend Gradle project skeleton (Java 23, Spring Boot 4.0.6, JPA, Quartz, H2, PostgreSQL, Lombok)
- `application.properties` for H2 in-memory DB + JPA `update` DDL + debug logging
- Flutter `Memory` model with three enums (`MemoryType`, `DeliveryChannel`, `MemoryStatus`) and JSON ser/des
- Flutter `ApiService` (CRUD) targeting `http://10.0.2.2:8080/api`
- Flutter `HomeScreen` (list, refresh, delete, FAB)
- Flutter `CreateMemoryScreen` (form, date/time picker, channel checkboxes)
- Flutter `main.dart` Material 3 entry, deepPurple seed

**Missing or drifted (see §9):**
- All backend Java sources (`Memory` entity, repository, service, controller, Quartz job, config) — **not on disk** despite `IMPLEMENTED_COMPONENTS.md` claiming they are.
- Twilio integration (no SDK in `build.gradle`)
- S3/Firebase upload (no SDK in `build.gradle`, no `Media` upload UI)
- Real `MemoryDeliveryJob` logic
- Auth/users
- Tests beyond the Flutter `widget_test.dart` default stub
- CI/CD
- Error/observability beyond default Spring logging
- Glassmorphism/particle UI
- AI features

---

## 7. Architectural Decisions (recorded)

- **Polling scheduler, not cron/event-driven.** Quartz job fires every 60s and queries `PENDING` memories with `deliveryDate <= now()`. Simple, no external broker.
- **H2 in dev, Postgres in prod.** DSN swap is the only change needed; JPA `ddl-auto=update` will manage schema.
- **Flutter talks HTTP directly to Spring.** No API gateway, no auth layer yet.
- **Android emulator base URL is `10.0.2.2:8080`** (host loopback). iOS/desktop use `localhost`. This is hard-coded in `ApiService.baseUrl`.
- **Default delivery channel is `WHATSAPP`** on the create screen.
- **No client-side caching** — each `HomeScreen` entry refreshes via `FutureBuilder`.

---

## 8. Development History

| Date (file mtime) | Event |
|---|---|
| 2026-06-05 22:11 | Project root created |
| 2026-06-05 22:18 | `memory-jar-backend` scaffolded (Gradle + `application.properties`) |
| 2026-06-05 22:20 | `memory_jar_mobile` scaffolded with Flutter deps |
| 2026-06-05 22:22 | `FULL_IMPLEMENTATION_GUIDE.md` written (vision) |
| 2026-06-05 22:23 | `IMPLEMENTED_COMPONENTS.md` written — **claims backend Java sources exist; they do not** |

The mismatch between `IMPLEMENTED_COMPONENTS.md` and the disk is the single most important fact for any agent continuing this work.

---

## 9. Documentation Drift (CRITICAL)

`IMPLEMENTED_COMPONENTS.md` claims these files exist:
- `Memory.java`, `MemoryRepository.java`, `MemoryService.java`, `MemoryController.java`
- `MemoryDeliveryJob.java`, `QuartzConfig.java`

**None of them are on disk.** A subsequent pass must:
1. Create the missing backend sources (see `FEATURE_TRACKER.md` Phase 2 plan), OR
2. Correct `IMPLEMENTED_COMPONENTS.md` to reflect reality, OR
3. (Recommended) Create the sources **and** update the doc with a code reference.

When continuing work, **verify file existence** with `Glob`/`Read` before assuming a file is present, regardless of what `IMPLEMENTED_COMPONENTS.md` says.

---

## 10. Future Roadmap (per `FULL_IMPLEMENTATION_GUIDE.md` §7)

- **Phase 1:** Core CRUD & Basic Scheduling — *partially done; mobile done, backend sources missing*
- **Phase 2:** Twilio API Integration for WhatsApp/Calls
- **Phase 3:** Media Uploads (S3 Integration)
- **Phase 4:** Advanced UI/UX (Glassmorphism & Particles)
- **Phase 5:** AI Features (Summaries & Montages)

Recommended immediate milestone: **create the missing backend Java sources to make Phase 1 actually complete**, then proceed to Phase 2.
