# Memory Jar App: Full Implementation Guide

## 1. Overview
Memory Jar is a digital time capsule application that allows users to record memories and schedule them for future delivery via WhatsApp, automated phone calls, SMS, and email.

## 2. Technical Architecture
- **Mobile App**: Flutter (Cross-platform iOS/Android)
- **Backend**: Java Spring Boot (REST API)
- **Database**: PostgreSQL (Structured data) + H2 (Local Development)
- **Media Storage**: AWS S3 or Firebase Storage
- **Scheduling**: Spring Quartz (Minute-by-minute job execution)
- **Communications**: Twilio API (WhatsApp, Voice, SMS)

---

## 3. Backend Implementation (Spring Boot)

### 3.1 Domain Model
The core entity `Memory` stores:
- `title`, `content` (text/message)
- `type` (TEXT, AUDIO, IMAGE, VIDEO)
- `deliveryDate` (Target timestamp)
- `deliveryChannels` (List: WHATSAPP, PHONE_CALL, etc.)
- `recipientIdentifier` (Phone number or Email)
- `status` (PENDING, DELIVERED, FAILED)

### 3.2 Scheduling Engine (Quartz)
- **MemoryDeliveryJob**: A Quartz job that runs every 60 seconds.
- **Logic**: 
  1. Query database for all `PENDING` memories where `deliveryDate <= now()`.
  2. Iterate through each memory and trigger the respective delivery service (Twilio/Mailgun).
  3. Update status to `DELIVERED` on success.

### 3.3 API Endpoints
- `POST /api/memories`: Create and schedule a new memory.
- `GET /api/memories`: List all memories.
- `DELETE /api/memories/{id}`: Cancel a scheduled memory.

---

## 4. Mobile Implementation (Flutter)

### 4.1 UI/UX Design (Ethereal Glassmorphism)
- **Theme**: Soft aurora gradients, frosted glass panels (using `BackdropFilter`).
- **Screens**:
  - `HomeScreen`: Staggered grid or list of "floating" memory cards.
  - `CreateMemoryScreen`: An intuitive form with a date/time picker and channel selection.
  - `RecordingWidget`: Custom interface for capturing audio snippets.

### 4.2 State Management & Networking
- **Provider/Riverpod**: Manage application state.
- **HTTP/Dio**: Communicate with the Spring Boot API.
- **Services**:
  - `ApiService`: Handles all REST calls.
  - `RecordingService`: Wraps the `record` package for audio capture.

---

## 5. Automation & Integration (Twilio)

### 5.1 WhatsApp Delivery
```java
// Logic inside MemoryDeliveryJob
public void sendWhatsApp(String to, String message) {
    Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
    Message.creator(
        new PhoneNumber("whatsapp:" + to),
        new PhoneNumber("whatsapp:" + TWILIO_NUMBER),
        message
    ).create();
}
```

### 5.2 Voice Call Delivery
To play a recorded message, host the audio file on a public URL and use Twilio's TwiML:
```java
public void makePhoneCall(String to, String audioUrl) {
    Call.creator(
        new PhoneNumber(to),
        new PhoneNumber(TWILIO_NUMBER),
        new Twiml("<Response><Play>" + audioUrl + "</Play></Response>")
    ).create();
}
```

---

## 6. Setup Instructions

### Backend
1. Install JDK 21+ and Maven/Gradle.
2. Clone the repository.
3. Configure `application.properties` with database and Twilio credentials.
4. Run `./gradlew bootRun`.

### Mobile
1. Install Flutter SDK.
2. Run `flutter pub get`.
3. Update `ApiService` with your backend's IP address.
4. Run `flutter run`.

---

## 7. Roadmap
- **Phase 1**: Core CRUD & Basic Scheduling (Completed).
- **Phase 2**: Twilio API Integration for WhatsApp/Calls.
- **Phase 3**: Media Uploads (S3 Integration).
- **Phase 4**: Advanced UI/UX (Glassmorphism & Particles).
- **Phase 5**: AI Features (Summaries & Montages).
