GreenBiller
GreenBiller is a Flutter-based mobile application for user authentication and role-based dashboard navigation. It supports OTP-based and password-based login, user registration, and logout functionality, with user data stored locally using Hive. The app uses Dio for API calls, GetX for state management and navigation, and Logger for debugging. Users are redirected to role-specific dashboards (Admin, Manager, Staff, Customer) based on their userLevel.
Features

Authentication:
OTP-based login with phone number verification.
Password-based login.
User registration with name, email, phone, password, and referral code.
Logout functionality with local data cleanup.


Role-Based Dashboards:
Admin (userLevel: 1)
Manager (userLevel: 2)
Staff (userLevel: 3)
Customer (userLevel: 4, default)


Local Storage: Persists user data (e.g., username, email, phone, userLevel, licenseKey, status) using Hive.
API Integration: Handles API requests for OTP sending/verification, login, and signup using Dio.
Error Handling: Robust error logging with Logger and user feedback via snackbars.

Project Structure
green_biller/
├── lib/
│   ├── core/
│   │   ├── api_constants.dart        # API endpoint constants (e.g., sendOtpUrl, verifyOtpUrl)
│   │   ├── dio_client.dart          # Dio client setup for API requests
│   │   ├── hive_service.dart        # Hive initialization and user data management
│   ├── features/
│   │   ├── auth/
│   │   │   ├── controller/
│   │   │   │   ├── auth_controller.dart  # GetX controller for authentication logic
│   │   │   ├── model/
│   │   │   │   ├── user_model.dart       # User model with Hive annotations
│   │   │   │   ├── user_model.g.dart     # Generated Hive adapter
│   │   │   ├── view/
│   │   │   │   ├── login_page.dart       # Login UI
│   │   │   │   ├── otp_verify_page.dart  # OTP verification UI
│   │   │   │   ├── signup_page.dart      # Signup UI
│   ├── routes/
│   │   ├── app_routes.dart          # Route definitions for navigation
│   ├── screens/
│   │   ├── dashboards.dart          # Role-based dashboard UIs
│   ├── main.dart                    # App entry point with Hive initialization
├── pubspec.yaml                    # Project dependencies and configuration
├── README.md                       # This file

Key Files

main.dart: Initializes the app, sets up Hive via HiveService, and configures GetMaterialApp with routes.
user_model.dart: Defines the UserModel with fields (loggedIn, accessToken, username, email, phone, userLevel, status, createdAt, licenseKey, subscriptionStart, subscriptionId, subscriptionEnd, profileImage, tokenExpiresIn) and Hive annotations.
hive_service.dart: Manages Hive initialization, adapter registration, and user data storage/retrieval.
auth_controller.dart: Handles authentication logic (OTP, login, signup, logout) and role-based navigation.
dashboards.dart: Implements role-specific dashboards displaying user details.
app_routes.dart: Defines named routes for navigation (/login, /otp_verify, /signup, /admin_dashboard, etc.).

Prerequisites

Flutter SDK: Version 3.0.0 or higher
Dart: Version 2.17.0 or higher
IDE: VS Code or Android Studio with Flutter plugin
Emulator/Device: Android or iOS emulator/physical device for testing
API Access: Ensure API endpoints (sendOtpUrl, verifyOtpUrl, loginUrl, signUpUrl) in api_constants.dart are configured and accessible.

Setup Instructions

Clone the Repository:
git clone <repository-url>
cd green_biller


Install Dependencies:Update pubspec.yaml with the following dependencies:
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  get: ^4.6.5
  dio: ^5.3.0
  logger: ^1.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  build_runner: ^2.3.0

Run:
flutter pub get


Generate Hive Adapters:Generate the user_model.g.dart file for Hive:
flutter pub run build_runner build --delete-conflicting-outputs


Configure API Endpoints:Update lib/core/api_constants.dart with your API endpoints:
class ApiConstants {
  static const String sendOtpUrl = 'https://your-api.com/send-otp';
  static const String verifyOtpUrl = 'https://your-api.com/verify-otp';
  static const String loginUrl = 'https://your-api.com/login';
  static const String signUpUrl = 'https://your-api.com/signup';
}


Clear Old Data (if needed):To avoid Hive type mismatches:

Clear app data on the device/emulator (Settings > Apps > GreenBiller > Clear Data).
Or uninstall/reinstall the app.
Alternatively, keep await box.clear() in hive_service.dart for one run, then remove it.



Running the App

Run in Debug Mode:
flutter run --debug

This starts the app and logs debugging information via Logger.

Available Routes:

/login: Login page for OTP or password-based authentication.
/otp_verify: OTP verification page.
/signup: User registration page.
/admin_dashboard: Admin dashboard (userLevel: 1).
/manager_dashboard: Manager dashboard (userLevel: 2).
/staff_dashboard: Staff dashboard (userLevel: 3).
/customer_dashboard: Customer dashboard (userLevel: 4).
/homepage: Alias for customer dashboard.


Test Scenarios:

Initial Launch: App starts at /login or redirects to /customer_dashboard if a user is stored in Hive.
OTP Login: Enter phone number, verify OTP, and check redirection to /customer_dashboard.
Password Login: Log in with mobile and password, verify user details (username: test user, email: test@gmail.com, phone: 7012545907, userLevel: 4, licenseKey: 5788, status: active) on the dashboard.
Sign Up: Register a new user and confirm redirection to /customer_dashboard.
Logout: Log out and verify redirection to /login.



Debugging

Console Logs: Run flutter run --debug and check logs for:
Hive adapter registered for UserModel (typeId: 0) or already registered.
Verify OTP response: {...} to confirm API response parsing.
Errors like Hive initialization failed or Verify OTP error.


Clear Hive Data: If type mismatches occur, keep box.clear() in hive_service.dart for one run, then remove it.
Check Generated Files: Verify lib/features/auth/model/user_model.g.dart matches the expected UserModelAdapter with 14 fields.
API Issues: Ensure API endpoints return the expected response format:{
  "status": true,
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...",
  "expires_in": 3600,
  "data": {
    "name": "test user",
    "email": "test@gmail.com",
    "mobile": "7012545907",
    "user_level": 4,
    "status": "active",
    "created_at": "2025-08-25T11:46:14.000000Z",
    "license_key": "5788",
    "subcription_id": null,
    "subcription_start": null,
    "subcription_end": null,
    "profile_image": null
  },
  "is_existing_user": true
}



Known Issues and Fixes

HiveError: There is already a TypeAdapter for typeId 0:
Cause: Multiple registrations of UserModelAdapter.
Fix: Added Hive.isAdapterRegistered(0) check in hive_service.dart.


Type 'String' is not a subtype of type 'int?':
Cause: API sends user_level or expires_in as strings.
Fix: Updated user_model.dart to use int.tryParse for userLevel and tokenExpiresIn.


Black Screen:
Cause: Runtime errors in Hive initialization or JSON parsing.
Fix: Clear Hive data, regenerate adapters, and check logs.



Contributing

Fork the repository.
Create a feature branch (git checkout -b feature/new-feature).
Commit changes (git commit -m 'Add new feature').
Push to the branch (git push origin feature/new-feature).
Create a pull request.

License
This project is licensed under the GreenBilller License.