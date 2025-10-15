import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your shipments'**
  String get login_title;

  /// No description provided for @signup_title.
  ///
  /// In en, this message translates to:
  /// **'Finish signing up'**
  String get signup_title;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First name on ID'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last name on ID'**
  String get last_name;

  /// No description provided for @important_note.
  ///
  /// In en, this message translates to:
  /// **'Important Note'**
  String get important_note;

  /// No description provided for @signup_note.
  ///
  /// In en, this message translates to:
  /// **'Make sure your name matches your government ID.'**
  String get signup_note;

  /// No description provided for @enter_phone_number_msg.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enter_phone_number_msg;

  /// No description provided for @join_us_via_phone.
  ///
  /// In en, this message translates to:
  /// **'Join us via phone'**
  String get join_us_via_phone;

  /// No description provided for @signup_phone_title.
  ///
  /// In en, this message translates to:
  /// **'W\'ll text you to confirm your phone number. '**
  String get signup_phone_title;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get already_have_account;

  /// No description provided for @intro_title.
  ///
  /// In en, this message translates to:
  /// **'Ship Anywhere'**
  String get intro_title;

  /// No description provided for @intro_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast, reliable delivery'**
  String get intro_subtitle;

  /// No description provided for @intro_description.
  ///
  /// In en, this message translates to:
  /// **'Connect with trusted travelers and ship your packages.'**
  String get intro_description;

  /// No description provided for @cntinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cntinue;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @dont_have_accout.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dont_have_accout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms and Privacy Policy'**
  String get policy;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @no_notification.
  ///
  /// In en, this message translates to:
  /// **'No Notifications yet'**
  String get no_notification;

  /// No description provided for @pickup_location.
  ///
  /// In en, this message translates to:
  /// **'Pickup location'**
  String get pickup_location;

  /// No description provided for @drop_off_location.
  ///
  /// In en, this message translates to:
  /// **'Drop-off location'**
  String get drop_off_location;

  /// No description provided for @select_pickup_date.
  ///
  /// In en, this message translates to:
  /// **'Select pickup date'**
  String get select_pickup_date;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get view_details;

  /// No description provided for @trips.
  ///
  /// In en, this message translates to:
  /// **'Trips'**
  String get trips;

  /// No description provided for @shipments.
  ///
  /// In en, this message translates to:
  /// **'Shipments'**
  String get shipments;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @negotiate.
  ///
  /// In en, this message translates to:
  /// **'Negotiate'**
  String get negotiate;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq;

  /// No description provided for @home_title_part1.
  ///
  /// In en, this message translates to:
  /// **'Ship Anywhere'**
  String get home_title_part1;

  /// No description provided for @home_title_part2.
  ///
  /// In en, this message translates to:
  /// **'Anytime.'**
  String get home_title_part2;

  /// No description provided for @faq_title.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get faq_title;

  /// No description provided for @faq_q1.
  ///
  /// In en, this message translates to:
  /// **'How does QuickDrop ensure package safety?'**
  String get faq_q1;

  /// No description provided for @faq_a1.
  ///
  /// In en, this message translates to:
  /// **'All couriers are verified through ID checks and background screening. Every package is insured, tracked in real-time, and handled with care by trusted travelers.'**
  String get faq_a1;

  /// No description provided for @faq_q2.
  ///
  /// In en, this message translates to:
  /// **'What can I ship with QuickDrop?'**
  String get faq_q2;

  /// No description provided for @faq_a2.
  ///
  /// In en, this message translates to:
  /// **'You can ship documents, electronics, clothing, gifts, and most personal items. Prohibited items include hazardous materials, illegal substances, and fragile items without proper packaging.'**
  String get faq_a2;

  /// No description provided for @faq_q3.
  ///
  /// In en, this message translates to:
  /// **'How much can I save compared to traditional shipping?'**
  String get faq_q3;

  /// No description provided for @faq_a3.
  ///
  /// In en, this message translates to:
  /// **'Users typically save 50-70% compared to major carriers like FedEx or UPS, especially for international shipments. Prices vary based on size, weight, and destination.'**
  String get faq_a3;

  /// No description provided for @faq_q4.
  ///
  /// In en, this message translates to:
  /// **'How do I become a courier?'**
  String get faq_q4;

  /// No description provided for @faq_a4.
  ///
  /// In en, this message translates to:
  /// **'Simply go to your profile, click on \'Become a Driver\', fill your information, wait for approval, and start accepting delivery requests. You set your own prices and schedule.'**
  String get faq_a4;

  /// No description provided for @faq_q5.
  ///
  /// In en, this message translates to:
  /// **'What if something goes wrong with my shipment?'**
  String get faq_q5;

  /// No description provided for @faq_a5.
  ///
  /// In en, this message translates to:
  /// **'We provide 24/7 customer support. If there\'s any issue, our team will resolve it quickly.'**
  String get faq_a5;

  /// No description provided for @service_send_title.
  ///
  /// In en, this message translates to:
  /// **'Send Packages'**
  String get service_send_title;

  /// No description provided for @service_send_description.
  ///
  /// In en, this message translates to:
  /// **'Connect with verified travelers heading to your destination. Save up to 70% on shipping costs with our trusted courier network.'**
  String get service_send_description;

  /// No description provided for @service_courier_title.
  ///
  /// In en, this message translates to:
  /// **'Become a Courier'**
  String get service_courier_title;

  /// No description provided for @service_courier_description.
  ///
  /// In en, this message translates to:
  /// **'Turn your trips into earnings. Carry packages and make money on routes you\'re already taking. Set your own prices and schedule.'**
  String get service_courier_description;

  /// No description provided for @feature_tag_1.
  ///
  /// In en, this message translates to:
  /// **'Verified travelers'**
  String get feature_tag_1;

  /// No description provided for @feature_tag_2.
  ///
  /// In en, this message translates to:
  /// **'No middlemen'**
  String get feature_tag_2;

  /// No description provided for @feature_tag_3.
  ///
  /// In en, this message translates to:
  /// **'Flexible routes'**
  String get feature_tag_3;

  /// No description provided for @feature_tag_4.
  ///
  /// In en, this message translates to:
  /// **'Trusted community'**
  String get feature_tag_4;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get settings_logout;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
