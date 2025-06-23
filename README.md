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

