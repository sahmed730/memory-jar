# SYSTEM_ARCHITECTURE.md — Memory Jar

> All diagrams in Mermaid. Drawn from verified disk state and the vision in `FULL_IMPLEMENTATION_GUIDE.md`. Dotted lines / `[planned]` nodes mark components that are designed but not yet on disk.

---

## 1. End-to-End System View

```mermaid
flowchart LR
  User([User])
  subgraph Mobile["Flutter App (memory_jar_mobile)"]
    UI[Screens<br/>HomeScreen / CreateMemoryScreen]
    Model[Memory model + enums]
    API[ApiService<br/>http package]
    Rec[RecordingService<br/>record package - unused yet]
    Notif[flutter_local_notifications]
  end
  subgraph Backend["Spring Boot (memory-jar-backend) :8080"]
    Ctrl[/MemoryController<br/>REST /api/memories/]
    Svc[MemoryService]
    Repo[(MemoryRepository<br/>JPA)]
    Job[[Quartz Scheduler<br/>MemoryDeliveryJob 60s]]
    Delivery[DeliveryService<br/>planned]
  end
  subgraph Storage
    H2[(H2 in-memory dev)]
    PG[(PostgreSQL prod)]
    S3[(S3 / Firebase<br/>planned)]
  end
  subgraph External["External - planned"]
    Twilio[Twilio API<br/>WhatsApp / Voice / SMS]
    Mail[Email Provider<br/>Mailgun or SMTP]
  end

  User --> UI
  UI --> Model
  UI --> API
  API -- "JSON over HTTP" --> Ctrl
  Rec -. upload .-> S3
  Ctrl --> Svc --> Repo
  Repo --- H2
  Repo --- PG
  Job -- "scans PENDING due memories" --> Repo
  Job --> Delivery
  Delivery -- "send WhatsApp / call / SMS" --> Twilio
  Delivery -- "send email" --> Mail
  S3 -. "public URL for <Play>" .-> Twilio
  Notif -. "local reminder (planned)" .-> User
```

---

## 2. Backend Architecture (Spring Boot, planned modules)

```mermaid
flowchart TB
  subgraph Web Layer
    RC[MemoryController<br/>@RestController]
  end
  subgraph Service Layer
    MS[MemoryService<br/>@Service]
  end
  subgraph Persistence Layer
    MR[MemoryRepository<br/>extends JpaRepository]
  end
  subgraph Domain
    M[(Memory<br/>@Entity)]
    E1[MemoryType]
    E2[DeliveryChannel]
    E3[MemoryStatus]
  end
  subgraph Scheduling
    QC[QuartzConfig<br/>Trigger every 60s]
    QJ[MemoryDeliveryJob<br/>@DisallowConcurrentExecution]
  end
  subgraph Integration[planned]
    DS[DeliveryService interface]
    TDS[TwilioDeliveryService]
    EDS[EmailDeliveryService]
  end

  RC --> MS
  MS --> MR
  MR --> M
  M --- E1
  M --- E2
  M --- E3
  QC --> QJ
  QJ --> MR
  QJ --> DS
  DS <|.. TDS
  DS <|.. EDS
```

**Package convention (planned):** `com.memoryjar.{controller, service, model, repository, config, delivery, delivery.twilio, delivery.email}`.

---

## 3. Mobile Architecture (Flutter)

```mermaid
flowchart TB
  Main[main.dart<br/>MaterialApp · Material 3 · deepPurple]
  Home[HomeScreen<br/>StatefulWidget]
  Create[CreateMemoryScreen<br/>Form + DatePicker + Channel checkboxes]
  API[ApiService<br/>baseUrl=http://10.0.2.2:8080/api]
  Model[Memory + enums]
  Rec[record package<br/>declared in pubspec, not yet used]
  PP[path_provider]
  Notif[flutter_local_notifications]
  URL[url_launcher]
  Intl[intl]

  Main --> Home
  Home -- "FAB push" --> Create
  Home --> API
  Create --> API
  API --> Model
  Home --> Model
  Create --> Model
  Rec -. unused .-> Create
  PP -. unused .-> Create
  Notif -. unused .-> Home
  URL -. unused .-> Home
  Intl -. unused .-> Home
```

State management: bare `setState` + `FutureBuilder`. No Provider/Riverpod yet (guide §4.2 recommends adopting one when state grows).

---

## 4. Delivery Flow (planned, the core Phase 2 work)

```mermaid
sequenceDiagram
  participant Q as Quartz Scheduler
  participant J as MemoryDeliveryJob
  participant R as MemoryRepository
  participant D as DeliveryService
  participant T as Twilio
  participant E as Email
  participant DB as Database

  loop every 60s
    Q->>J: execute()
    J->>R: findByStatusAndDeliveryDateBefore(PENDING, now)
    R-->>J: List<Memory>
    loop for each memory
      alt WHATSAPP
        J->>D: sendWhatsApp(recipient, content)
        D->>T: Message.creator(...)
        T-->>D: SID
      else PHONE_CALL
        J->>D: makePhoneCall(recipient, mediaUrl)
        D->>T: Call.creator(...) with TwiML <Play>
        T-->>D: Call SID
      else SMS
        J->>D: sendSms(recipient, content)
        D->>T: Message.creator(...)
        T-->>D: SID
      else EMAIL
        J->>D: sendEmail(recipient, title, content)
        D->>E: send(...)
        E-->>D: 202
      end
      alt success
        J->>DB: status=DELIVERED
      else exception
        J->>DB: status=FAILED, lastError=msg
      end
    end
  end
```

---

## 5. Scheduling Flow

```mermaid
flowchart LR
  A[App startup] --> B[Spring Boot autowires Quartz starter]
  B --> C[QuartzConfig declares JobDetail + Trigger]
  C --> D[Trigger: SimpleSchedule, repeatForever, interval=60s]
  D --> E{MemoryDeliveryJob.execute}
  E --> F[Query PENDING + due]
  F --> G[Dispatch by channel]
  G --> H[Persist status]
  H -. wait 60s .-> E
```

**Concurrency:** mark `MemoryDeliveryJob` with `@DisallowConcurrentExecution` to prevent overlapping runs on the same node.

**Scaling caveat:** the 60s poll is fine for a single instance. For HA, switch to a JDBC-backed `JobStore` (Quartz supports it; tables auto-created with `spring.quartz.job-store-type=jdbc`) and consider sharding via `PARTITION` or leader election.

---

## 6. Database Relationships (planned)

```mermaid
erDiagram
  MEMORY ||..o{ MEMORY_CHANNEL : "0..n"
  MEMORY ||..o{ DELIVERY_ATTEMPT : "0..n (planned)"
  MEMORY {
    BIGINT id PK
    VARCHAR title
    TEXT content
    VARCHAR type "TEXT|AUDIO|IMAGE|VIDEO|DOCUMENT"
    VARCHAR media_url
    TIMESTAMP delivery_date
    VARCHAR status "PENDING|DELIVERED|FAILED"
    VARCHAR recipient_identifier
    TIMESTAMP created_at
  }
  MEMORY_CHANNEL {
    BIGINT memory_id FK
    VARCHAR channel "WHATSAPP|PHONE_CALL|SMS|EMAIL|PUSH_NOTIFICATION"
  }
  DELIVERY_ATTEMPT {
    BIGINT id PK
    BIGINT memory_id FK
    VARCHAR channel
    VARCHAR outcome "OK|ERROR"
    TEXT error_message
    TIMESTAMP attempted_at
  }
```

**Recommendation:** model channels as a join table. Avoids comma-separated parsing and lets you add channel-specific delivery metadata later.

---

## 7. External Service Integrations

| Service | Purpose | Phase | SDK / Library | Config |
|---|---|---|---|---|
| Twilio | WhatsApp send, TwiML voice call, SMS | 2 | `com.twilio.sdk:twilio:10.x` (NOT in `build.gradle` yet) | `twilio.account.sid`, `twilio.auth.token`, `twilio.whatsapp.number`, `twilio.voice.number` |
| Mailgun / SMTP | Email delivery | 2 (alongside Twilio) | `spring-boot-starter-mail` | `spring.mail.*` or Mailgun API key |
| AWS S3 / Firebase | Media upload | 3 | TBD | bucket + credentials |
| FCM / APNS | Push notifications (in addition to Twilio) | 3+ | TBD | server key / APNS cert |

**Twilio voice requires a public audio URL** — the `mediaUrl` field on `Memory` must point to a hosted file. This is the bridge between Phase 2 and Phase 3: a phone-call memory cannot be delivered without a hosted media asset, so the audio upload path becomes a Phase 2 prerequisite for the `PHONE_CALL` channel.
