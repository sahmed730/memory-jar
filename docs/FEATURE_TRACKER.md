# FEATURE_TRACKER.md — Memory Jar

> Per-feature status pulled from `FULL_IMPLEMENTATION_GUIDE.md`, verified against disk on 2026-06-05.

## Legend
- ✅ **Completed** — code on disk, matches spec
- 🟡 **Partially Completed** — scaffold or stub only
- 🔵 **In Progress** — actively being worked
- ⚪ **Planned** — in roadmap, not started
- ⛔ **Blocked** — needs prerequisite
- ❌ **Not Started** — no code

---

## Phase 1 — Core CRUD & Basic Scheduling

| # | Feature | Status | Notes |
|---|---|---|---|
| 1.1 | `Memory` JPA entity | ❌ | Guide §3.1; **file not on disk** despite IMPLEMENTED_COMPONENTS.md claim |
| 1.2 | `MemoryRepository` w/ due-memory query | ❌ | Not on disk |
| 1.3 | `MemoryService` (create/list/delete) | ❌ | Not on disk |
| 1.4 | `MemoryController` (`/api/memories`) | ❌ | Not on disk |
| 1.5 | `MemoryDeliveryJob` (Quartz, 60s) | ❌ | Not on disk; existing skeleton reference is in docs only |
| 1.6 | `QuartzConfig` (60s trigger) | ❌ | Not on disk |
| 1.7 | Spring Boot `main` class | ❌ | App cannot boot as-is |
| 1.8 | `application.properties` (H2 dev) | ✅ | H2 in-memory, JPA `update`, debug logging |
| 1.9 | `build.gradle` (Java 23, Boot 4.0.6, JPA, Quartz, H2, PG, Lombok) | ✅ | Verified on disk |
| 1.10 | Flutter `Memory` model + enums | ✅ | 3 enums, JSON ser/des matches API intent |
| 1.11 | Flutter `ApiService` (CRUD) | ✅ | baseUrl hard-coded to `10.0.2.2:8080/api` |
| 1.12 | Flutter `HomeScreen` | ✅ | List + refresh + delete + FAB |
| 1.13 | Flutter `CreateMemoryScreen` | ✅ | Form + date/time picker + channel checkboxes |
| 1.14 | Flutter `main.dart` (Material 3) | ✅ | deepPurple seed |

**Phase 1 completion: ~50%** (mobile done; backend sources missing)

---

## Phase 2 — Twilio API Integration

| # | Feature | Status | Notes |
|---|---|---|---|
| 2.1 | Twilio SDK in `build.gradle` | ❌ | `com.twilio.sdk:twilio:10.x` not yet added |
| 2.2 | Twilio credentials in `application.properties` | ❌ | `twilio.account.sid`, `twilio.auth.token`, `twilio.whatsapp.number`, `twilio.voice.number` |
| 2.3 | `DeliveryService` interface | ❌ | Should expose `sendWhatsApp`, `makePhoneCall`, `sendSms`, `sendEmail` |
| 2.4 | `TwilioDeliveryService` impl | ❌ | Uses guide §5.1 / §5.2 patterns |
| 2.5 | `EmailDeliveryService` impl | ❌ | Provider TBD (Mailgun vs SMTP). Spring `spring-boot-starter-mail` not in `build.gradle` |
| 2.6 | Real `MemoryDeliveryJob` dispatch | ❌ | Job exists in docs only |
| 2.7 | `DELIVERED` / `FAILED` status transitions | ❌ | |
| 2.8 | Delivery error capture (`lastError` field) | ❌ | |
| 2.9 | Integration test with Twilio test creds | ❌ | |

**Phase 2 completion: 0%**

---

## Phase 3 — Media Uploads (S3 / Firebase)

| # | Feature | Status | Notes |
|---|---|---|---|
| 3.1 | S3 or Firebase SDK in `build.gradle` | ❌ | Provider not chosen |
| 3.2 | Audio recording UI on Flutter | ❌ | `record` and `path_provider` are in `pubspec.yaml` but unused; `CreateMemoryScreen` hard-codes `MemoryType.TEXT` |
| 3.3 | Image / video picker | ❌ | `image_picker` not in `pubspec.yaml` |
| 3.4 | Upload endpoint on backend | ❌ | |
| 3.5 | Public URL generation (for Twilio `<Play>`) | ❌ | Required for `PHONE_CALL` channel |
| 3.6 | `mediaUrl` plumbing through entity & model | 🟡 | Field exists in Dart model; entity not on disk |

**Phase 3 completion: ~5%** (model field present only)

---

## Phase 4 — Advanced UI/UX

| # | Feature | Status | Notes |
|---|---|---|---|
| 4.1 | Aurora gradient theme | ❌ | Guide §4.1; currently plain Material 3 deepPurple. **Spec defined in `../DESIGN_SYSTEM.md` §3.4** |
| 4.2 | Frosted glass panels (`BackdropFilter`) | ❌ | **Spec in `../DESIGN_SYSTEM.md` §7.2 (`MemoryCard`)** |
| 4.3 | Staggered/floating memory cards | ❌ | Currently plain `Card` + `ListTile`. **Spec in `../DESIGN_SYSTEM.md` §5.5, §6.4** |
| 4.4 | Particle / ambient effects | ❌ | **Spec in `../DESIGN_SYSTEM.md` §6.1 (reduced-motion handling)** |
| 4.5 | Custom `RecordingWidget` | ❌ | **Spec in `../DESIGN_SYSTEM.md` §5.9** |

**Phase 4 completion: 0%**

---

## Phase 5 — AI Features

| # | Feature | Status | Notes |
|---|---|---|---|
| 5.1 | Memory summarization | ⚪ Planned | No provider / model chosen |
| 5.2 | Montage / video compilation | ⚪ Planned | |
| 5.3 | AI on backend (Python microservice?) | ⚪ Planned | |

**Phase 5 completion: 0%**

---

## Cross-Cutting

| # | Feature | Status | Notes |
|---|---|---|---|
| X.1 | CORS configuration | ❌ | Will block Flutter web |
| X.2 | Authentication / users | ❌ | None; `Memory` has no `userId` |
| X.3 | Unit tests (backend) | ❌ | |
| X.4 | Widget/integration tests (mobile) | 🟡 | Only the default counter-test stub |
| X.5 | CI/CD | ❌ | |
| X.6 | Observability beyond default logging | ❌ | |
| X.7 | Retry / backoff for failed deliveries | ❌ | |
| X.8 | Delivery audit table | ❌ | |
| X.9 | Production profile (`application-prod.properties`) with PostgreSQL DSN | ❌ | |
| X.10 | Documentation accuracy (`IMPLEMENTED_COMPONENTS.md`) | ⛔ | Documented components don't exist on disk |

---

## Overall Completion

| Phase | % |
|---|---|
| Phase 1 — Core CRUD & Basic Scheduling | 50% |
| Phase 2 — Twilio Integration | 0% |
| Phase 3 — Media Uploads | 5% |
| Phase 4 — Advanced UI/UX | 0% |
| Phase 5 — AI Features | 0% |
| Cross-Cutting | 5% |
| **Total weighted (rough)** | **~22%** |

> Note: percentage is file-grounded (lines of code matching spec), not aspirational. The earlier 25–30% estimate in the lead-engineer briefing included partial credit for the docs/gradle/config; this table is stricter.

---

## Next Milestone (Recommended)

**Phase 1 closure → Phase 2 build-out.** Create the six missing backend Java sources listed in §1.1–1.7, then add Twilio and email delivery services. Detailed step list: see `DEVELOPER_HANDOVER.md` §8.
