# QuickDrop

QuickDrop is a modern Flutter application that connects travelers with people who need to ship packages. It provides a platform for peer-to-peer package delivery services, allowing users to either send packages or become couriers.

## Features

### For Senders
- Create shipment listings with package details and routes
- Connect with verified travelers
- Track shipment status in real-time
- Save up to 70% on shipping costs
- Secure payment processing with Stripe
- Rating and review system

### For Couriers
- Create trip listings with routes and available capacity
- Set custom pricing and schedules
- Manage multiple deliveries
- Earn money by delivering packages along your route
- Professional driver registration system
- Subscription-based driver accounts

### General Features
- User authentication (Email, Google Sign-in)
- Multi-language support (English, French, Arabic)
- Real-time notifications
- In-app messaging system
- Profile management
- Statistics and earnings tracking
- Secure payment processing

## Technical Stack

- **Frontend**: Flutter 3.2+
- **Backend**: Firebase Services
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage
  - Cloud Functions
  - Firebase Messaging
- **Additional Services**:
  - Stripe Payment Integration
  - Supabase
  - Google Sign-In

### Key Dependencies

- `firebase_core`: ^3.12.1
- `firebase_auth`: ^5.5.1
- `cloud_firestore`: ^5.6.5
- `flutter_stripe`: ^12.0.2
- `go_router`: ^15.1.1
- `provider`: ^6.1.1
- `intl`: ^0.20.2
- `cached_network_image`: ^3.4.1
- `flutter_local_notifications`: ^19.3.0

## Getting Started

### Prerequisites

- Flutter SDK (>=3.2.3)
- Dart SDK (>=3.0.0)
- Firebase project setup
- Stripe account for payment processing
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:
```bash
git clone https://github.com/oelbouha/quickdrop.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up environment variables:
Create a `.env` file in the root directory with the following:
```
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
STRIPE_SECRET_KEY=your_stripe_secret_key
```

4. Configure Firebase:
- Add your `google-services.json` for Android
- Add your `GoogleService-Info.plist` for iOS

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── providers/       # State management
│   ├── utils/          # Utility functions
│   └── widgets/        # Reusable widgets
├── features/
│   ├── auth/           # Authentication
│   ├── home/           # Home screen
│   ├── models/         # Data models
│   ├── profile/        # User profile
│   ├── shipment/       # Shipment management
│   └── trip/           # Trip management
├── l10n/               # Localization
├── routes/             # Navigation
└── theme/             # App theming
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is proprietary and confidential. Unauthorized copying, modifying, distributing, or using this code without express permission is strictly prohibited.

## Version

Current Version: 1.0.0 (2025)
