# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-14

### Added
- Initial release of QuickDrop app
- User authentication (Email, Google Sign-in, Phone verification)
- Shipment creation and management for senders
- Trip creation and management for couriers
- In-app messaging and real-time chat system
- Secure Stripe payment integration for shipment payments
- Push notifications via Firebase Cloud Messaging
- Multi-language support (English, French, Arabic)
- User profile management and verification
- Rating and review system for trust building
- Real-time status tracking for shipments
- Comprehensive Firebase backend integration:
  - Firestore for data persistence
  - Firebase Storage for image uploads
  - Cloud Functions for server-side logic
  - Firebase App Check for security
- Supabase integration for additional services
- Comprehensive documentation:
  - Deployment guide for all platforms
  - User guide for senders and couriers
  - FAQ and troubleshooting
  - Help and support guidelines

### Technical Stack
- Flutter 3.2+
- Firebase Services (Auth, Firestore, Storage, Cloud Functions, Messaging)
- Stripe Payment Processing
- Supabase Backend
- GoRouter for navigation
- Provider for state management

### Supported Platforms
- Android (API 21+)
- iOS (11.0+)
- Web
- Linux
- macOS
- Windows

### Features
- **For Senders**: Create shipments, connect with verified couriers, track status, secure payments
- **For Couriers**: Create trips, manage deliveries, earn money, professional ratings
- **General**: Real-time notifications, in-app messaging, profile management, statistics

### Known Limitations
- Test mode uses Firebase Emulator Suite (optional)
- iOS deployment requires valid Apple Developer credentials
- Android release requires signed keystore (`my-release-key.jks` included)

---

## Future Releases

### [1.1.0] - Planned
- Advanced analytics and insights for users
- Subscription tiers for premium features
- Driver insurance integration
- Advanced negotiation features
- Improved notification scheduling
- Offline mode for critical features

### [1.2.0] - Planned
- AI-powered route optimization
- Carbon footprint tracking
- Community rating improvements
- Enhanced security features

---

For detailed information about deploying, using, or contributing to QuickDrop, see:
- `docs/deployment.md` — Deployment and build instructions
- `docs/user_guide.md` — How to use the app
- `docs/faq.md` — Common questions
- `docs/help.md` — Support and contribution guidelines
