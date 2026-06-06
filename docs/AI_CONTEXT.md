# AI_CONTEXT.md — Memory Jar (compressed LLM context)

> **Purpose:** maximum information density, minimum tokens. Any future model should be able to continue development using this file alone. Read order: top-down.

---

## TL;DR
Two-tier app. **Flutter mobile** + **Spring Boot backend** (Java 23, Boot 4.0.6). Mobile is functional; backend is **configured but has zero Java sources**. Twilio + email delivery, media upload, glass UI, and AI are not built. Quartz job polls every 60s for due memories. `IMPLEMENTED_COMPONENTS.md` is **unreliable** — verify on disk.

## Stack
- Backend: Java 23, Spring Boot 4.0.6, Gradle, JPA, Hibernate, Quartz, Lombok, H2 (dev), PostgreSQL (prod driver only)
- Mobile: Flutter, Dart ^3.9.2, `http`, `record`, `path_provider`, `intl`, `flutter_local_notifications`, `url_launcher`
- Planned: Twilio SDK, AWS S3 SDK, mail starter

## Paths
- Backend root: `D:\projects\memory jar\memory-jar-backend\`
  - `build.gradle` — deps wired
  - `src/main/resources/application.properties` — H2 in-memory `jdbc:h2:mem:memoryjardb`, JPA `update`, debug logging
  - **No `src/main/java/` tree exists yet**
- Mobile root: `D:\projects\memory jar\memory_jar_mobile\`
  - `pubspec.yaml` — deps as above
  - `lib/main.dart` — MaterialApp, Material 3, `seedColor: Colors.deepPurple`, home = `HomeScreen`
  - `lib/models/memory.dart` — `Memory` + enums `MemoryType` (TEXT/AUDIO/IMAGE/VIDEO/DOCUMENT), `DeliveryChannel` (WHATSAPP/PHONE_CALL/SMS/EMAIL/PUSH_NOTIFICATION), `MemoryStatus` (PENDING/DELIVERED/FAILED); JSON ser/des via `.name`
  - `lib/services/api_service.dart` — `baseUrl = 'http://10.0.2.2:8080/api'`; CRUD: `getMemories`, `createMemory`, `deleteMemory`
  - `lib/screens/home_screen.dart` — `FutureBuilder<List<Memory>>`, `Card`+`ListTile`, refresh action, delete trailing button, FAB → `CreateMemoryScreen`
  - `lib/screens/create_memory_screen.dart` — `Form` w/ title/content/recipient/date-time picker/channel checkboxes; default channels = `[WHATSAPP]`; type hard-coded to `TEXT`

## API contract (intended, no server yet)
- `GET  /api/memories` → `List<Memory>`
- `POST /api/memories` body=`Memory` → `Memory`
- `DELETE /api/memories/{id}` → `204`

## Memory JSON shape
```
{id:int?, title, content, type:enum, mediaUrl, deliveryDate:ISO, deliveryChannels:[enum], status:enum, recipientIdentifier, createdAt:ISO?}
```

## DB schema (planned)
Single `memories` table; `delivery_channels` should be a **join table** (mobile sends a `List`; comma-separated is a smell). Add `(status, delivery_date)` index. Optional `delivery_attempts(memory_id, channel, outcome, error_message, attempted_at)` for audit/retry.

## Scheduling
- `MemoryDeliveryJob` Quartz job, `@DisallowConcurrentExecution`, simple trigger every 60s.
- Algorithm: `findByStatusAndDeliveryDateLessThanEqual(PENDING, now)` → dispatch per channel → set `DELIVERED` or `FAILED`.

## Twilio (Phase 2, not built)
- Add `com.twilio.sdk:twilio:10.x` to `build.gradle`.
- Init once in a `@Configuration` bean: `Twilio.init(ACCOUNT_SID, AUTH_TOKEN)`.
- WhatsApp: `Message.creator(new PhoneNumber("whatsapp:"+to), new PhoneNumber("whatsapp:"+from), body).create()`.
- Voice: `Call.creator(to, from, new Twiml("<Response><Play>"+audioUrl+"</Play></Response>")).create()` — **requires public mediaUrl** (cross-cuts Phase 3).
- Credentials externalize: `twilio.account.sid`, `twilio.auth.token`, `twilio.whatsapp.number`, `twilio.voice.number`. Bind via `@ConfigurationProperties`.

## Status vs reality
- ✅ Flutter `Memory` model, `ApiService`, `HomeScreen`, `CreateMemoryScreen`, `main.dart`, backend `build.gradle`, `application.properties`
- ❌ All backend Java sources (`Memory` entity, `MemoryRepository`, `MemoryService`, `MemoryController`, `MemoryDeliveryJob`, `QuartzConfig`, main class)
- ❌ Twilio, email, S3, glass UI, AI, auth, tests, CORS, prod profile

## Known pitfalls
1. `IMPLEMENTED_COMPONENTS.md` claims backend sources exist. They do not. Verify with `Glob "D:/projects/memory jar/memory-jar-backend/**/*.java"`.
2. No `main` class → `bootRun` fails. Create `src/main/java/com/memoryjar/MemoryJarApplication.java` first.
3. Mobile has `record` and `path_provider` declared but unused; UI hard-codes TEXT type.
4. Android emulator base URL is `10.0.2.2:8080`; iOS/desktop need `localhost:8080`.
5. No CORS yet → Flutter web will fail.
6. No retry/backoff on Quartz failures.

## Conventions
- Java package root: `com.memoryjar.*`; sub-packages `controller`, `service`, `model`, `repository`, `config`, `delivery`, `delivery.twilio`, `delivery.email`.
- Lombok on entities: `@Data`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor`.
- Naming: `XxxService`, `XxxRepository`, `XxxJob`, `XxxConfig`.
- Flutter state: `setState` for now; migrate to `provider`/`riverpod` later.

## Immediate next steps (ordered)
1. Create `MemoryJarApplication.java` (`@SpringBootApplication`).
2. Create `Memory` entity + 3 enums.
3. Create `MemoryRepository` with `findByStatusAndDeliveryDateLessThanEqual`.
4. Create `MemoryService` (create/list/delete).
5. Create `MemoryController` (`/api/memories`).
6. Create `QuartzConfig` + `MemoryDeliveryJob` (60s, no-op first).
7. Add CORS `WebMvcConfigurer` bean.
8. Add Twilio SDK + `TwilioConfig` + `DeliveryService` interface + `TwilioDeliveryService`.
9. Add `spring-boot-starter-mail` + `EmailDeliveryService`.
10. Wire `MemoryDeliveryJob` to dispatch + update status.
11. Smoke test end-to-end: create memory with `deliveryDate` 30s out via Flutter → confirm `DELIVERED` after Quartz tick.
12. Update `IMPLEMENTED_COMPONENTS.md` with real file references.

## Phases (from guide)
P1 CRUD+Scheduling (50% — mobile done, backend missing). P2 Twilio (0%). P3 S3 media (5%). P4 Glass UI (0%). P5 AI (0%).

## Key files cheat sheet
- `FULL_IMPLEMENTATION_GUIDE.md` — vision (trusted)
- `IMPLEMENTED_COMPONENTS.md` — **drifted from reality** (untrusted)
- `AI_PROJECT_MEMORY.md` — long-form machine memory
- `SYSTEM_ARCHITECTURE.md` — Mermaid diagrams
- `DEVELOPER_HANDOVER.md` — onboarding
- `FEATURE_TRACKER.md` — per-feature status + %
- `../DESIGN_SYSTEM.md` — single source of truth for visual design, UX, motion, components
- `AI_CONTEXT.md` — this file
