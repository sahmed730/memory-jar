# 🏺 Memory Jar

Memory Jar is a full-stack application that allows you to capture memories, encrypt them securely, and schedule them to be delivered to yourself or your loved ones in the future. Think of it as a time capsule for your thoughts, photos, and voice notes.

## ✨ Features

- **Time-Capsule Delivery**: Schedule memories to be delivered at a future date and time.
- **End-to-End Encryption**: All your memory contents are securely encrypted in the database using AES-GCM.
- **Multi-Channel Delivery**: Choose how you want the memory delivered (WhatsApp, SMS, Email, etc.).
- **Rich Media**: Support for text, images, audio recordings, and documents.
- **Beautiful UI**: A modern, glassmorphic UI built with Flutter, featuring soft dynamic backgrounds and particle animations.

## 🛠️ Technologies Used

### Frontend (Mobile App)
- **Framework**: Flutter / Dart
- **UI Architecture**: Glassmorphism with custom particle animations
- **State Management**: Stateful widgets & standard Flutter patterns

### Backend
- **Framework**: Spring Boot 3 / Java 17+
- **Database**: H2 (In-memory for development) / PostgreSQL ready
- **Encryption**: Java Cryptography Architecture (JCA)
- **Job Scheduling**: Quartz Scheduler for memory delivery processing
- **Storage**: AWS S3 for media storage

---

## 🚀 Getting Started

### Prerequisites
- [Java 17+](https://adoptium.net/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Git](https://git-scm.com/)

### 1. Clone the repository
```bash
git clone https://github.com/sahmed730/memory-jar.git
cd memory-jar
```

### 2. Running the Backend (Spring Boot)
The backend is a Spring Boot application using Gradle.

```bash
cd memory-jar-backend
# On Windows
.\gradlew.bat bootRun

# On macOS/Linux
./gradlew bootRun
```
The backend will start on `http://localhost:8080`.
*Note: The backend uses an in-memory H2 database by default. Data is wiped upon restart unless configured otherwise.*

### 3. Running the Frontend (Flutter)
The frontend is a Flutter mobile application.

```bash
cd memory_jar_mobile
flutter pub get

# To run on an emulator, connected device, or web:
flutter run
```

---

## 🔒 Security & Privacy
The backend encrypts the content of every memory before persisting it to the database. The encryption keys are securely managed through environment variables, ensuring that even if the database is compromised, the contents of the memories remain completely private until their designated delivery date.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome!

## 📝 License
This project is open-source and available under the [MIT License](LICENSE).
