# Project Name

A Flutter application built with **Riverpod** and **Flutter Hooks**, following a clean and scalable feature-first architecture.  

---

## 🚀 Tech Stack

- **Flutter**: 3.32.7 (stable)  
- **Dart**: 3.8.1  
- **Riverpod** for state management  
- **Flutter Hooks** for widget lifecycle management  
- **DevTools**: 2.45.1  

Flutter SDK path:  
`/home/hp/savio/flutter SDK/flutter`  
Upstream: [https://github.com/flutter/flutter.git](https://github.com/flutter/flutter.git)  

---

## 📂 Project Structure

This project uses a **feature-based folder structure** with four primary layers inside each feature:

lib/
core/
constants/ # API base urls and shared constants
utils/ # App-wide utilities
widgets/ # Shared/reusable UI widgets
features/
feature_name/
models/ # Data models (JSON parsing, domain objects)
services/ # API calls, external data handling
controllers/ # Business logic (using Riverpod providers)
views/ # Screens and UI (with hooks & widgets folder inside)
widgets/ # View-specific UI components


**Flow**:  
`View → Controller → Service → Model`  

- **View**: Displays the UI, listens to controller/provider states, and handles user interaction.  
- **Controller**: Contains state + logic (Riverpod providers). Calls services.  
- **Service**: Handles API/network/database interactions.  
- **Model**: Defines data structures, parsing, and validation.  

---

## ⚙️ Setup & Installation

1. Install Flutter (version `3.32.7`) and ensure you are on the **stable** channel.
   ```bash
   flutter --version

Should output:

Flutter 3.32.7 • channel stable • ...
Dart 3.8.1 • DevTools 2.45.1


🌐 API Configuration

All API base URLs and constants are defined in:

lib/core/constants/

Example (api_constants.dart):

class ApiConstants {
  static const String baseUrl = "https://api.example.com";
  static const String auth = "$baseUrl/auth";
  static const String users = "$baseUrl/users";
}


🛠️ Development Notes

Use Riverpod providers in controllers for state and logic.

Use Flutter Hooks inside views for cleaner lifecycle handling (useEffect, useState, etc.).

Keep all UI widgets for a feature inside the widgets/ folder of that feature.

Shared/common widgets should live under lib/core/widgets/.

✅ Example Workflow

Example: Login Feature

features/login/
  models/login_request.dart
  services/login_service.dart
  controllers/login_controller.dart
  views/login_view.dart
  views/widgets/login_form.dart
