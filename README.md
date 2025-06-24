# Basic Chat App

A modern Flutter chat application built with:

- ✅ Riverpod (State Management)
- ✅ Firebase Cloud Messaging (Push Notifications)
- ✅ QR Code-Based Device Pairing
- ✅ Local Storage (SharedPreferences, SQLite)
- ✅ Multilingual Support (EN/AR)
- ✅ Offline Chat Persistence
- ✅ Foreground + Background Push Handling

---

## 🚀 Features

### ✅ Authentication
- Simple email + name + phone-based registration
- Login and persistent sessions using `SharedPreferences`

### 🔐 Device Pairing via QR Code
- Show your QR (with full `UserModel` info)
- Scan partner's QR code to connect

### 💬 Chat
- Realtime-like chat using local DB
- Each message tagged with timestamp
- Messages are stored and displayed per user pairing

### 🔔 Push Notifications
- Uses FCM to send and receive messages
- Shows local notification for new messages
- Automatically stores incoming messages in SQLite
- Foreground and background handling

### 🌍 Localization
- English and Arabic supported
- Based on `AppLocalizations` + `intl`

### 🗺 Maps
- Google Maps / OSM integration planned
- Show location 

---

## 🧰 Technologies Used

| Feature                    | Package                         |
|----------------------------|----------------------------------|
| State Management           | [Riverpod](https://pub.dev/packages/flutter_riverpod) |
| QR Code Generation/Scan    | `qr_flutter`, `mobile_scanner`  |
| Push Notifications         | `firebase_messaging`, `http`    |
| Local Notifications        | `flutter_local_notifications`   |
| Persistent Storage         | `shared_preferences`, `sqflite` |
| Localization               | `intl`                          |


![WhatsApp Image 2025-06-24 at 10 25 58 AM](https://github.com/user-attachments/assets/9e09347c-2169-4c07-ab0d-ac1ab0eb9d2d)
![WhatsApp Image 2025-06-24 at 10 25 55 AM](https://github.com/user-attachments/assets/805a808b-64c3-4fd2-893a-aae6945ca77a)
![WhatsApp Image 2025-06-24 at 10 25 56 AM (2)](https://github.com/user-attachments/assets/fc742a88-b72b-4600-a042-f70fe0fdd918)
![WhatsApp Image 2025-06-24 at 10 25 56 AM (3)](https://github.com/user-attachments/assets/31613e1e-3de7-4e0b-bb68-aa660f1ba96e)
![WhatsApp Image 2025-06-24 at 10 25 57 AM (1)](https://github.com/user-attachments/assets/150ddacb-d978-40b4-9da1-f021f2b0dc1f)
