# QuickDrop — FAQ

This FAQ covers common questions developers, testers and users might have.

Q: I can't sign in with Google. What should I check?
A: Ensure your Firebase project has Google Sign-In enabled, that the OAuth client IDs are configured for your package name and SHA-1 keys, and `google-services.json` is the correct file for your Firebase project.

Q: Phone verification messages are not received.
A: Check Firebase Phone Auth quotas, ensure correct phone number format, and if testing use the Firebase Auth phone number test list in the Firebase console.

Q: Push notifications not arriving.
A: Confirm `firebase_messaging` is initialized on startup, the device token is registered with your backend, and APNs / FCM credentials are uploaded in Firebase for iOS.

Q: Image uploads fail with permission errors.
A: Check Firebase Storage rules and ensure the user is authenticated or rules allow the intended access. Inspect the Storage console logs for rejected requests.

Q: Payments declined or not appearing in Stripe.
A: Verify `.env` contains the correct Stripe keys and that your server-side functions (if used for secret operations) are configured with the secret key. For test mode use Stripe test keys.

Q: Where are environment variables stored for Cloud Functions?
A: Use `firebase functions:config:set` for runtime config or use Secret Manager. Do not embed secret keys in client code.

Q: App crashes on startup after updating dependencies.
A: Run `flutter clean` then `flutter pub get`. Check plugin migration guides for breaking changes and make necessary code updates.

Q: How do I run tests?
A: Unit/widget tests exist under `test/`. Run them with:

```
flutter test
```

Q: How do I run the app while connected to Firebase Emulator Suite?
A: Start the emulator suite via `firebase emulators:start` and configure the app to use the emulator host (refer to `lib/core/utils/firebase_service.dart` or init code that toggles emulator host).

If your issue is not covered here, open an issue with details and logs (see `docs/help.md`).
