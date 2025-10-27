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
  /// **'First Name'**
  String get first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
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
  /// **'Pickup Location'**
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

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @no_user_data.
  ///
  /// In en, this message translates to:
  /// **'No user data available'**
  String get no_user_data;

  /// No description provided for @guest_user.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get guest_user;

  /// No description provided for @member_since.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get member_since;

  /// No description provided for @version_info.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0 - 2025'**
  String get version_info;

  /// No description provided for @settings_logout_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get settings_logout_confirm_message;

  /// No description provided for @settings_logout_header.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settings_logout_header;

  /// No description provided for @settings_logout_button.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get settings_logout_button;

  /// No description provided for @settings_logout_error.
  ///
  /// In en, this message translates to:
  /// **'Error signing out:'**
  String get settings_logout_error;

  /// No description provided for @feature_coming_soon.
  ///
  /// In en, this message translates to:
  /// **'feature is coming soon!'**
  String get feature_coming_soon;

  /// No description provided for @become_driver.
  ///
  /// In en, this message translates to:
  /// **'Become a driver'**
  String get become_driver;

  /// No description provided for @earn_money.
  ///
  /// In en, this message translates to:
  /// **'Earn money by delivering packages'**
  String get earn_money;

  /// No description provided for @refer_friends.
  ///
  /// In en, this message translates to:
  /// **'Refer friends'**
  String get refer_friends;

  /// No description provided for @invite_friends.
  ///
  /// In en, this message translates to:
  /// **'Invite friends and earn rewards'**
  String get invite_friends;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personal_info;

  /// No description provided for @update_details.
  ///
  /// In en, this message translates to:
  /// **'Update your details and preferences'**
  String get update_details;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @manage_account.
  ///
  /// In en, this message translates to:
  /// **'Manage account preferences'**
  String get manage_account;

  /// No description provided for @manage_notifications.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get manage_notifications;

  /// No description provided for @payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get payment_methods;

  /// No description provided for @manage_payments.
  ///
  /// In en, this message translates to:
  /// **'Add or remove payment methods'**
  String get manage_payments;

  /// No description provided for @get_help.
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get get_help;

  /// No description provided for @contact_support.
  ///
  /// In en, this message translates to:
  /// **'Contact our support team'**
  String get contact_support;

  /// No description provided for @terms_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_service;

  /// No description provided for @read_terms.
  ///
  /// In en, this message translates to:
  /// **'Read our terms and conditions'**
  String get read_terms;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @learn_privacy.
  ///
  /// In en, this message translates to:
  /// **'Learn how we protect your data'**
  String get learn_privacy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @update_profile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get update_profile;

  /// No description provided for @update_profile_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your information up to date'**
  String get update_profile_subtitle;

  /// No description provided for @profile_image.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profile_image;

  /// No description provided for @change_image.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get change_image;

  /// No description provided for @important.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get important;

  /// No description provided for @profile_image_note.
  ///
  /// In en, this message translates to:
  /// **'Make sure your profile image is clear and recognizable.'**
  String get profile_image_note;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @enter_first_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enter_first_name;

  /// No description provided for @enter_last_name.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enter_last_name;

  /// No description provided for @personal_info_note.
  ///
  /// In en, this message translates to:
  /// **'Make sure this matches the name on your government ID or passport.'**
  String get personal_info_note;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contact_information;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email_address;

  /// No description provided for @email_hint.
  ///
  /// In en, this message translates to:
  /// **'example@gmail.com'**
  String get email_hint;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @phone_hint.
  ///
  /// In en, this message translates to:
  /// **'06 000 00 00'**
  String get phone_hint;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @save_changes_header.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes_header;

  /// No description provided for @save_changes_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to update your information?'**
  String get save_changes_message;

  /// No description provided for @save_button_text.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_button_text;

  /// No description provided for @cancel_button_text.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button_text;

  /// No description provided for @update_success_title.
  ///
  /// In en, this message translates to:
  /// **'Information updated successfully!'**
  String get update_success_title;

  /// No description provided for @update_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your account information has been updated successfully.'**
  String get update_success_message;

  /// No description provided for @update_error_message.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while updating your information. Please try again.'**
  String get update_error_message;

  /// No description provided for @image_uploading_message.
  ///
  /// In en, this message translates to:
  /// **'Image is still uploading, please wait'**
  String get image_uploading_message;

  /// No description provided for @help_title.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help_title;

  /// No description provided for @still_have_questions.
  ///
  /// In en, this message translates to:
  /// **'Still Have Questions?'**
  String get still_have_questions;

  /// No description provided for @helpful_tips.
  ///
  /// In en, this message translates to:
  /// **'Helpful Tips'**
  String get helpful_tips;

  /// No description provided for @question_sent_success.
  ///
  /// In en, this message translates to:
  /// **'Question Sent Successfully!'**
  String get question_sent_success;

  /// No description provided for @question_reply_time.
  ///
  /// In en, this message translates to:
  /// **'We\'ll get back to you within 24 hours.'**
  String get question_reply_time;

  /// No description provided for @question_form_info.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find what you\'re looking for? Send us your question and our support team will help you out.'**
  String get question_form_info;

  /// No description provided for @your_question_label.
  ///
  /// In en, this message translates to:
  /// **'Your Question'**
  String get your_question_label;

  /// No description provided for @question_hint.
  ///
  /// In en, this message translates to:
  /// **'What would you like to know about QuickDrop?'**
  String get question_hint;

  /// No description provided for @send_question.
  ///
  /// In en, this message translates to:
  /// **'Send Question'**
  String get send_question;

  /// No description provided for @sending_question.
  ///
  /// In en, this message translates to:
  /// **'Sending Question...'**
  String get sending_question;

  /// No description provided for @success_add_question.
  ///
  /// In en, this message translates to:
  /// **'Your question has been added successfully!'**
  String get success_add_question;

  /// No description provided for @failed_add_question.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit your question'**
  String get failed_add_question;

  /// No description provided for @tip_1_title.
  ///
  /// In en, this message translates to:
  /// **'Package Smart'**
  String get tip_1_title;

  /// No description provided for @tip_1_description.
  ///
  /// In en, this message translates to:
  /// **'Use sturdy boxes and bubble wrap for fragile items. Label clearly with both sender and recipient information.'**
  String get tip_1_description;

  /// No description provided for @tip_2_title.
  ///
  /// In en, this message translates to:
  /// **'Stay Safe'**
  String get tip_2_title;

  /// No description provided for @tip_2_description.
  ///
  /// In en, this message translates to:
  /// **'Always verify courier profiles and ratings before booking. Meet in public places for handoffs when possible.'**
  String get tip_2_description;

  /// No description provided for @tip_3_title.
  ///
  /// In en, this message translates to:
  /// **'Save More'**
  String get tip_3_title;

  /// No description provided for @tip_3_description.
  ///
  /// In en, this message translates to:
  /// **'Book in advance and be flexible with delivery dates to get the best rates from our courier network.'**
  String get tip_3_description;

  /// No description provided for @tip_4_title.
  ///
  /// In en, this message translates to:
  /// **'Build Trust'**
  String get tip_4_title;

  /// No description provided for @tip_4_description.
  ///
  /// In en, this message translates to:
  /// **'Leave honest reviews and maintain good communication with your courier throughout the delivery process.'**
  String get tip_4_description;

  /// No description provided for @no_ongoing_shipments.
  ///
  /// In en, this message translates to:
  /// **'No Ongoing Shipments'**
  String get no_ongoing_shipments;

  /// No description provided for @no_ongoing_shipments_subtitle.
  ///
  /// In en, this message translates to:
  /// **'After you create or accept a shipment, it will appear here.'**
  String get no_ongoing_shipments_subtitle;

  /// No description provided for @no_completed_shipments.
  ///
  /// In en, this message translates to:
  /// **'No Completed Shipments'**
  String get no_completed_shipments;

  /// No description provided for @no_completed_shipments_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your completed shipments will appear here after delivery.'**
  String get no_completed_shipments_subtitle;

  /// No description provided for @no_active_shipments.
  ///
  /// In en, this message translates to:
  /// **'No Active Shipments'**
  String get no_active_shipments;

  /// No description provided for @no_active_shipments_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Shipments that are currently in progress will show here once started.'**
  String get no_active_shipments_subtitle;

  /// No description provided for @no_ongoing_trips.
  ///
  /// In en, this message translates to:
  /// **'No Ongoing trips'**
  String get no_ongoing_trips;

  /// No description provided for @no_ongoing_trips_subtitle.
  ///
  /// In en, this message translates to:
  /// **'After you create or accept a shipment, it will appear here.'**
  String get no_ongoing_trips_subtitle;

  /// No description provided for @no_completed_trips.
  ///
  /// In en, this message translates to:
  /// **'No Completed trips'**
  String get no_completed_trips;

  /// No description provided for @no_completed_trips_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your completed trips will appear here after delivery.'**
  String get no_completed_trips_subtitle;

  /// No description provided for @no_active_trips.
  ///
  /// In en, this message translates to:
  /// **'No Active trips'**
  String get no_active_trips;

  /// No description provided for @no_active_trips_subtitle.
  ///
  /// In en, this message translates to:
  /// **'trips that are currently in progress will show here once started.'**
  String get no_active_trips_subtitle;

  /// No description provided for @tip_1_step.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get tip_1_step;

  /// No description provided for @tip_2_step.
  ///
  /// In en, this message translates to:
  /// **'Delivery Locations'**
  String get tip_2_step;

  /// No description provided for @tip_3_step.
  ///
  /// In en, this message translates to:
  /// **'Timing & Image'**
  String get tip_3_step;

  /// No description provided for @create_trip.
  ///
  /// In en, this message translates to:
  /// **'Create Trip'**
  String get create_trip;

  /// No description provided for @update_trip.
  ///
  /// In en, this message translates to:
  /// **'Update Trip'**
  String get update_trip;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @trip_details.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get trip_details;

  /// No description provided for @delivery_price.
  ///
  /// In en, this message translates to:
  /// **'Delivery Price (MAD)'**
  String get delivery_price;

  /// No description provided for @available_weight.
  ///
  /// In en, this message translates to:
  /// **'Available Weight (kg)'**
  String get available_weight;

  /// No description provided for @pricing_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Pricing Tip'**
  String get pricing_tip_title;

  /// No description provided for @pricing_tip_message.
  ///
  /// In en, this message translates to:
  /// **'Set a competitive price based on distance, package size, and urgency.'**
  String get pricing_tip_message;

  /// No description provided for @trip_locations.
  ///
  /// In en, this message translates to:
  /// **'Trip Locations'**
  String get trip_locations;

  /// No description provided for @delivery_location.
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get delivery_location;

  /// No description provided for @from_hint.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from_hint;

  /// No description provided for @to_hint.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to_hint;

  /// No description provided for @location_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Location Details Matter'**
  String get location_tip_title;

  /// No description provided for @location_tip_message.
  ///
  /// In en, this message translates to:
  /// **'Include landmarks, building numbers, and floor details for smoother pickup and delivery.'**
  String get location_tip_message;

  /// No description provided for @timing.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get timing;

  /// No description provided for @pickup_date.
  ///
  /// In en, this message translates to:
  /// **'Pickup Date'**
  String get pickup_date;

  /// No description provided for @transport_type.
  ///
  /// In en, this message translates to:
  /// **'Transport Type'**
  String get transport_type;

  /// No description provided for @timing_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Flexible Timing'**
  String get timing_tip_title;

  /// No description provided for @timing_tip_message.
  ///
  /// In en, this message translates to:
  /// **'We\'ll contact you to confirm the exact pickup time within your preferred date.'**
  String get timing_tip_message;

  /// No description provided for @trip_list_success_title.
  ///
  /// In en, this message translates to:
  /// **'Trip Listed Successfully!'**
  String get trip_list_success_title;

  /// No description provided for @trip_list_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your trip has been added and is now visible to couriers.'**
  String get trip_list_success_message;

  /// No description provided for @trip_update_success_title.
  ///
  /// In en, this message translates to:
  /// **'Trip Updated Successfully!'**
  String get trip_update_success_title;

  /// No description provided for @trip_update_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your trip has been updated and is now visible to couriers.'**
  String get trip_update_success_message;

  /// No description provided for @trip_list_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to list Trip'**
  String get trip_list_failed;

  /// No description provided for @fields_empty.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields'**
  String get fields_empty;

  /// No description provided for @login_required.
  ///
  /// In en, this message translates to:
  /// **'Please log in to list a shipment'**
  String get login_required;

  /// No description provided for @pickup_required.
  ///
  /// In en, this message translates to:
  /// **'Pickup location is required'**
  String get pickup_required;

  /// No description provided for @delivery_required.
  ///
  /// In en, this message translates to:
  /// **'Delivery location is required'**
  String get delivery_required;

  /// No description provided for @price_required.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get price_required;

  /// No description provided for @price_number.
  ///
  /// In en, this message translates to:
  /// **'Price must be a number'**
  String get price_number;

  /// No description provided for @weight_required.
  ///
  /// In en, this message translates to:
  /// **'Weight is required'**
  String get weight_required;

  /// No description provided for @weight_number.
  ///
  /// In en, this message translates to:
  /// **'Weight must be a number'**
  String get weight_number;

  /// No description provided for @pickup_date_required.
  ///
  /// In en, this message translates to:
  /// **'Pickup date is required'**
  String get pickup_date_required;

  /// No description provided for @shipment_list_success_title.
  ///
  /// In en, this message translates to:
  /// **'Package Listed Successfully!'**
  String get shipment_list_success_title;

  /// No description provided for @shipment_list_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your shipment has been added and is now visible to couriers.'**
  String get shipment_list_success_message;

  /// No description provided for @shipment_update_success_title.
  ///
  /// In en, this message translates to:
  /// **'Shipment Updated Successfully!'**
  String get shipment_update_success_title;

  /// No description provided for @shipment_update_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your shipment has been updated and is now visible to couriers.'**
  String get shipment_update_success_message;

  /// No description provided for @shipment_list_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to list shipment: {e}'**
  String shipment_list_failed(Object e);

  /// No description provided for @shipment_update_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update shipment: {e}'**
  String shipment_update_failed(Object e);

  /// No description provided for @image_required.
  ///
  /// In en, this message translates to:
  /// **'Please select an image'**
  String get image_required;

  /// No description provided for @image_upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed'**
  String get image_upload_failed;

  /// No description provided for @image_upload_failed_with_error.
  ///
  /// In en, this message translates to:
  /// **'Image upload failed: {e}'**
  String image_upload_failed_with_error(Object e);

  /// No description provided for @image_uploading.
  ///
  /// In en, this message translates to:
  /// **'Image is still uploading, please wait'**
  String get image_uploading;

  /// No description provided for @image_not_selected.
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get image_not_selected;

  /// No description provided for @package_details.
  ///
  /// In en, this message translates to:
  /// **'Package Details'**
  String get package_details;

  /// No description provided for @delivery_locations.
  ///
  /// In en, this message translates to:
  /// **'Delivery Locations'**
  String get delivery_locations;

  /// No description provided for @package_dimensions.
  ///
  /// In en, this message translates to:
  /// **'Package Dimensions'**
  String get package_dimensions;

  /// No description provided for @timing_image.
  ///
  /// In en, this message translates to:
  /// **'Timing & Image'**
  String get timing_image;

  /// No description provided for @update_shipment.
  ///
  /// In en, this message translates to:
  /// **'Update Shipment'**
  String get update_shipment;

  /// No description provided for @create_shipment.
  ///
  /// In en, this message translates to:
  /// **'Create Shipment'**
  String get create_shipment;

  /// No description provided for @package_name_required.
  ///
  /// In en, this message translates to:
  /// **'Package name is required'**
  String get package_name_required;

  /// No description provided for @description_required.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get description_required;

  /// No description provided for @package_type_required.
  ///
  /// In en, this message translates to:
  /// **'Package type is required'**
  String get package_type_required;

  /// No description provided for @quantity_required.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required'**
  String get quantity_required;

  /// No description provided for @package_name_label.
  ///
  /// In en, this message translates to:
  /// **'Package Name'**
  String get package_name_label;

  /// No description provided for @package_name_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Phone case, Book, Documents'**
  String get package_name_hint;

  /// No description provided for @package_description_label.
  ///
  /// In en, this message translates to:
  /// **'Package Description'**
  String get package_description_label;

  /// No description provided for @package_description_hint.
  ///
  /// In en, this message translates to:
  /// **'Describe your package content in detail...'**
  String get package_description_hint;

  /// No description provided for @delivery_price_label.
  ///
  /// In en, this message translates to:
  /// **'Delivery Price (MAD)'**
  String get delivery_price_label;

  /// No description provided for @delivery_price_hint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get delivery_price_hint;

  /// No description provided for @weight_label.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weight_label;

  /// No description provided for @weight_hint.
  ///
  /// In en, this message translates to:
  /// **'1.0'**
  String get weight_hint;

  /// No description provided for @quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity_label;

  /// No description provided for @quantity_hint.
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get quantity_hint;

  /// No description provided for @package_type_label.
  ///
  /// In en, this message translates to:
  /// **'Package Type'**
  String get package_type_label;

  /// No description provided for @package_type_box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get package_type_box;

  /// No description provided for @package_type_envelope.
  ///
  /// In en, this message translates to:
  /// **'Envelope'**
  String get package_type_envelope;

  /// No description provided for @package_type_bag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get package_type_bag;

  /// No description provided for @package_type_pallet.
  ///
  /// In en, this message translates to:
  /// **'Pallet'**
  String get package_type_pallet;

  /// No description provided for @package_type_accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get package_type_accessories;

  /// No description provided for @dimensions_tip_title.
  ///
  /// In en, this message translates to:
  /// **'Accurate measurements help couriers prepare'**
  String get dimensions_tip_title;

  /// No description provided for @dimensions_tip_message.
  ///
  /// In en, this message translates to:
  /// **'Providing dimensions ensures better matching and fewer delays.'**
  String get dimensions_tip_message;

  /// No description provided for @request_sent_success.
  ///
  /// In en, this message translates to:
  /// **'Request sent successfully'**
  String get request_sent_success;

  /// No description provided for @please_complete_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please complete all required fields'**
  String get please_complete_all_fields;

  /// No description provided for @please_select_trip.
  ///
  /// In en, this message translates to:
  /// **'Please select a trip'**
  String get please_select_trip;

  /// No description provided for @selected_trip_invalid.
  ///
  /// In en, this message translates to:
  /// **'Selected trip is invalid'**
  String get selected_trip_invalid;

  /// No description provided for @send_request.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get send_request;

  /// No description provided for @send_offer.
  ///
  /// In en, this message translates to:
  /// **'Send Offer'**
  String get send_offer;

  /// No description provided for @choose_a_trip.
  ///
  /// In en, this message translates to:
  /// **'Choose a trip'**
  String get choose_a_trip;

  /// No description provided for @no_active_trips_available.
  ///
  /// In en, this message translates to:
  /// **'No active trips match this shipment\'s destination'**
  String get no_active_trips_available;

  /// No description provided for @add_a_note.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get add_a_note;

  /// No description provided for @starting_from.
  ///
  /// In en, this message translates to:
  /// **'Starting from'**
  String get starting_from;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @package_image.
  ///
  /// In en, this message translates to:
  /// **'Package Image'**
  String get package_image;

  /// No description provided for @error_fetch_requests.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch requests: {error}'**
  String error_fetch_requests(Object error);

  /// No description provided for @error_loading_conversations.
  ///
  /// In en, this message translates to:
  /// **'Error loading conversations'**
  String get error_loading_conversations;

  /// No description provided for @no_active_negotiations.
  ///
  /// In en, this message translates to:
  /// **'No active negotiations'**
  String get no_active_negotiations;

  /// No description provided for @no_active_negotiations_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start negotiating on delivery requests to see them here'**
  String get no_active_negotiations_subtitle;

  /// No description provided for @no_messages_yet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get no_messages_yet;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @no_delivery_requests.
  ///
  /// In en, this message translates to:
  /// **'No Delivery requests'**
  String get no_delivery_requests;

  /// No description provided for @no_delivery_requests_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Incoming delivery requests will show up here'**
  String get no_delivery_requests_subtitle;

  /// No description provided for @no_delivery_requests_sent.
  ///
  /// In en, this message translates to:
  /// **'No delivery requests sent'**
  String get no_delivery_requests_sent;

  /// No description provided for @no_delivery_requests_sent_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Requests you\'ve sent to others will appear here'**
  String get no_delivery_requests_sent_subtitle;

  /// No description provided for @request_refused_success.
  ///
  /// In en, this message translates to:
  /// **'Request refused successfully'**
  String get request_refused_success;

  /// No description provided for @request_refused_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to refuse request'**
  String get request_refused_failed;

  /// No description provided for @request_accepted_success.
  ///
  /// In en, this message translates to:
  /// **'Request accepted successfully'**
  String get request_accepted_success;

  /// No description provided for @request_accepted_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept request'**
  String get request_accepted_failed;

  /// No description provided for @new_delivery_request.
  ///
  /// In en, this message translates to:
  /// **'New Delivery Request'**
  String get new_delivery_request;

  /// No description provided for @offered_price.
  ///
  /// In en, this message translates to:
  /// **'Offered Price'**
  String get offered_price;

  /// No description provided for @request_refused_failed_with_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to refuse request {error}'**
  String request_refused_failed_with_error(Object error);

  /// No description provided for @negotiation_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Negotiation in progress'**
  String get negotiation_in_progress;

  /// No description provided for @cancelling.
  ///
  /// In en, this message translates to:
  /// **'Cancelling...'**
  String get cancelling;

  /// No description provided for @cancel_negotiation.
  ///
  /// In en, this message translates to:
  /// **'Cancel Negotiation'**
  String get cancel_negotiation;

  /// No description provided for @driver_registration_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure all information is correct!'**
  String get driver_registration_confirm_message;

  /// No description provided for @driver_registration_confirm_header.
  ///
  /// In en, this message translates to:
  /// **'Register Request'**
  String get driver_registration_confirm_header;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'confirm'**
  String get confirm;

  /// No description provided for @driver_mode_title.
  ///
  /// In en, this message translates to:
  /// **'Driver Mode'**
  String get driver_mode_title;

  /// No description provided for @driver_mode_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your request has been sent Successfully. We will update you after review your documents'**
  String get driver_mode_success_message;

  /// No description provided for @driver_mode_request_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send request please try again later'**
  String get driver_mode_request_failed;

  /// No description provided for @please_fill_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get please_fill_all_fields;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @request_driver_mode_title.
  ///
  /// In en, this message translates to:
  /// **'Request Driver Mode'**
  String get request_driver_mode_title;

  /// No description provided for @request_driver_mode_message.
  ///
  /// In en, this message translates to:
  /// **'You have been requested to become a driver. please wait for the admin to review your request. You will be notified once your request is approved.'**
  String get request_driver_mode_message;

  /// No description provided for @resend_request.
  ///
  /// In en, this message translates to:
  /// **'Resend Request'**
  String get resend_request;

  /// No description provided for @driver_registration.
  ///
  /// In en, this message translates to:
  /// **'Driver registration'**
  String get driver_registration;

  /// No description provided for @driver_registration_subtitle.
  ///
  /// In en, this message translates to:
  /// **'You can request to become a driver by filling out the form below.'**
  String get driver_registration_subtitle;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get upload_image;

  /// No description provided for @id_card_number.
  ///
  /// In en, this message translates to:
  /// **'Id cart number'**
  String get id_card_number;

  /// No description provided for @enter_national_id.
  ///
  /// In en, this message translates to:
  /// **'Enter your National ID'**
  String get enter_national_id;

  /// No description provided for @vehicle_information.
  ///
  /// In en, this message translates to:
  /// **'vehicle Information'**
  String get vehicle_information;

  /// No description provided for @registration_plate.
  ///
  /// In en, this message translates to:
  /// **'Rgistration plate'**
  String get registration_plate;

  /// No description provided for @vehicle_plate_number_hint.
  ///
  /// In en, this message translates to:
  /// **'vehicle plate number'**
  String get vehicle_plate_number_hint;

  /// No description provided for @driver_number_label.
  ///
  /// In en, this message translates to:
  /// **'Driver number'**
  String get driver_number_label;

  /// No description provided for @driver_number_hint.
  ///
  /// In en, this message translates to:
  /// **'(e.g. 00125)'**
  String get driver_number_hint;

  /// No description provided for @vehicle_type_label.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicle_type_label;

  /// No description provided for @vehicle_type_hint.
  ///
  /// In en, this message translates to:
  /// **'vehicle type (car, truck, etc.)'**
  String get vehicle_type_hint;

  /// No description provided for @vehicle_info_note.
  ///
  /// In en, this message translates to:
  /// **'Make sure the vehicle information matches your vehicle registration documents.'**
  String get vehicle_info_note;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registering;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @payment_start_journey.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get payment_start_journey;

  /// No description provided for @payment_join_drivers.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of drivers earning daily'**
  String get payment_join_drivers;

  /// No description provided for @payment_how_it_works.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get payment_how_it_works;

  /// No description provided for @payment_step_1.
  ///
  /// In en, this message translates to:
  /// **'Subscribe for this month and start earning'**
  String get payment_step_1;

  /// No description provided for @payment_step_2.
  ///
  /// In en, this message translates to:
  /// **'Work when you want, earn as you like'**
  String get payment_step_2;

  /// No description provided for @payment_step_3.
  ///
  /// In en, this message translates to:
  /// **'Only \$2.00 per month to stay active'**
  String get payment_step_3;

  /// No description provided for @payment_step_4.
  ///
  /// In en, this message translates to:
  /// **'Renew monthly, no commitments'**
  String get payment_step_4;

  /// No description provided for @payment_free_trial_badge.
  ///
  /// In en, this message translates to:
  /// **'1 MONTH FREE TRIAL'**
  String get payment_free_trial_badge;

  /// No description provided for @payment_monthly_subscription.
  ///
  /// In en, this message translates to:
  /// **'Monthly Subscription'**
  String get payment_monthly_subscription;

  /// No description provided for @payment_price.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get payment_price;

  /// No description provided for @payment_price_main.
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get payment_price_main;

  /// No description provided for @payment_price_decimal.
  ///
  /// In en, this message translates to:
  /// **'.00'**
  String get payment_price_decimal;

  /// No description provided for @payment_price_period.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get payment_price_period;

  /// No description provided for @payment_first_month_free.
  ///
  /// In en, this message translates to:
  /// **'First month FREE, then \$2.00/mo'**
  String get payment_first_month_free;

  /// No description provided for @payment_terms_agree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get payment_terms_agree;

  /// No description provided for @payment_terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get payment_terms_of_service;

  /// No description provided for @payment_terms_and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get payment_terms_and;

  /// No description provided for @payment_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get payment_privacy_policy;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @payment_secure_stripe.
  ///
  /// In en, this message translates to:
  /// **'Secure payment powered by Stripe'**
  String get payment_secure_stripe;

  /// No description provided for @payment_subscription_activated.
  ///
  /// In en, this message translates to:
  /// **'Subscription activated!'**
  String get payment_subscription_activated;

  /// No description provided for @payment_failed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get payment_failed;

  /// No description provided for @payment_error.
  ///
  /// In en, this message translates to:
  /// **'Payment error'**
  String get payment_error;

  /// No description provided for @payment_not_signed_in.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get payment_not_signed_in;

  /// No description provided for @payment_function_error.
  ///
  /// In en, this message translates to:
  /// **'Test error'**
  String get payment_function_error;

  /// No description provided for @payment_test_function.
  ///
  /// In en, this message translates to:
  /// **'Testing function...'**
  String get payment_test_function;

  /// No description provided for @payment_calling_intent.
  ///
  /// In en, this message translates to:
  /// **'Calling createPaymentIntent...'**
  String get payment_calling_intent;

  /// No description provided for @payment_user_label.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get payment_user_label;

  /// No description provided for @payment_function_returned.
  ///
  /// In en, this message translates to:
  /// **'Function returned'**
  String get payment_function_returned;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @profile_shipments_overview.
  ///
  /// In en, this message translates to:
  /// **'Shipments Overview'**
  String get profile_shipments_overview;

  /// No description provided for @profile_trips_overview.
  ///
  /// In en, this message translates to:
  /// **'Trips Overview'**
  String get profile_trips_overview;

  /// No description provided for @profile_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get profile_pending;

  /// No description provided for @profile_ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get profile_ongoing;

  /// No description provided for @profile_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get profile_completed;

  /// No description provided for @profile_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get profile_reviews;

  /// No description provided for @profile_no_reviews_yet.
  ///
  /// In en, this message translates to:
  /// **'No Reviews Yet'**
  String get profile_no_reviews_yet;

  /// No description provided for @profile_joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get profile_joined;

  /// No description provided for @profile_guest_user.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get profile_guest_user;

  /// No description provided for @profile_year_singular.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get profile_year_singular;

  /// No description provided for @profile_year_plural.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get profile_year_plural;

  /// No description provided for @profile_month_singular.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get profile_month_singular;

  /// No description provided for @profile_month_plural.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get profile_month_plural;

  /// No description provided for @profile_day_singular.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get profile_day_singular;

  /// No description provided for @profile_day_plural.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get profile_day_plural;

  /// No description provided for @profile_hour_singular.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get profile_hour_singular;

  /// No description provided for @profile_hour_plural.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get profile_hour_plural;

  /// No description provided for @profile_minute_singular.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get profile_minute_singular;

  /// No description provided for @profile_minute_plural.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get profile_minute_plural;

  /// No description provided for @profile_just_now.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get profile_just_now;

  /// No description provided for @profile_ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get profile_ago;

  /// No description provided for @profile_statistics_not_found.
  ///
  /// In en, this message translates to:
  /// **'Statistics not found for user'**
  String get profile_statistics_not_found;

  /// No description provided for @profile_error_fetching_data.
  ///
  /// In en, this message translates to:
  /// **'Error fetching user data'**
  String get profile_error_fetching_data;

  /// No description provided for @profile_error_message.
  ///
  /// In en, this message translates to:
  /// **'Error fetching user data: '**
  String get profile_error_message;

  /// No description provided for @mark_as_delivered_title.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get mark_as_delivered_title;

  /// No description provided for @confirm_delivery_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure this item has been delivered successfully?'**
  String get confirm_delivery_message;

  /// No description provided for @courier_label.
  ///
  /// In en, this message translates to:
  /// **'Courier'**
  String get courier_label;

  /// No description provided for @price_label_dh.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price_label_dh;

  /// No description provided for @delivery_complete_rating_info.
  ///
  /// In en, this message translates to:
  /// **'This will complete the delivery and you\'ll be asked to rate the courier.'**
  String get delivery_complete_rating_info;

  /// No description provided for @not_yet.
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get not_yet;

  /// No description provided for @mark_delivered_button.
  ///
  /// In en, this message translates to:
  /// **'Mark Delivered'**
  String get mark_delivered_button;

  /// No description provided for @cancel_delivery_title.
  ///
  /// In en, this message translates to:
  /// **'Cancel Delivery'**
  String get cancel_delivery_title;

  /// No description provided for @confirm_cancel_delivery_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this ongoing delivery?'**
  String get confirm_cancel_delivery_message;

  /// No description provided for @cancel_warning_message.
  ///
  /// In en, this message translates to:
  /// **'Please contact the courier before canceling to avoid any issues.'**
  String get cancel_warning_message;

  /// No description provided for @keep_active_button.
  ///
  /// In en, this message translates to:
  /// **'Keep Active'**
  String get keep_active_button;

  /// No description provided for @cancel_delivery_button.
  ///
  /// In en, this message translates to:
  /// **'Cancel Delivery'**
  String get cancel_delivery_button;

  /// No description provided for @your_courier_label.
  ///
  /// In en, this message translates to:
  /// **'Your Courier'**
  String get your_courier_label;

  /// No description provided for @chat_button.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat_button;

  /// No description provided for @delivered_button.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered_button;

  /// No description provided for @courier.
  ///
  /// In en, this message translates to:
  /// **'Your Courier'**
  String get courier;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @review_submitted_success.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted succesfully!'**
  String get review_submitted_success;

  /// No description provided for @review_submit_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit review'**
  String get review_submit_failed;

  /// No description provided for @rate_experience_title.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience'**
  String get rate_experience_title;

  /// No description provided for @rate_experience_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please rate your experience with the user and provide feedback'**
  String get rate_experience_subtitle;

  /// No description provided for @review_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts'**
  String get review_hint_text;

  /// No description provided for @submit_review_button.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submit_review_button;

  /// No description provided for @report_describe_problem.
  ///
  /// In en, this message translates to:
  /// **'Please describe the problem before submitting.'**
  String get report_describe_problem;

  /// No description provided for @report_submitted_success.
  ///
  /// In en, this message translates to:
  /// **'Problem reported successfully!'**
  String get report_submitted_success;

  /// No description provided for @report_submit_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit report'**
  String get report_submit_failed;

  /// No description provided for @report_problem_title.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get report_problem_title;

  /// No description provided for @report_problem_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue you encountered with this user'**
  String get report_problem_subtitle;

  /// No description provided for @report_hint_text.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem...'**
  String get report_hint_text;

  /// No description provided for @submit_report_button.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submit_report_button;

  /// No description provided for @waiting_for_response.
  ///
  /// In en, this message translates to:
  /// **'Waiting for response'**
  String get waiting_for_response;

  /// No description provided for @type_a_message.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get type_a_message;

  /// No description provided for @seen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get seen;

  /// No description provided for @error_loading_message.
  ///
  /// In en, this message translates to:
  /// **'Error loading messages'**
  String get error_loading_message;

  /// No description provided for @error_loading_message_text.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages. Please try again later.'**
  String get error_loading_message_text;

  /// No description provided for @security_delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your Account?'**
  String get security_delete_account_confirm;

  /// No description provided for @security_delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get security_delete_account_title;

  /// No description provided for @security_confirm_button.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get security_confirm_button;

  /// No description provided for @security_delete_success_title.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted Successfully!'**
  String get security_delete_success_title;

  /// No description provided for @security_delete_success_message.
  ///
  /// In en, this message translates to:
  /// **'Your account and data has been deleted successfully.'**
  String get security_delete_success_message;

  /// No description provided for @security_profile_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get security_profile_settings_title;

  /// No description provided for @security_delete_account_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account permanently'**
  String get security_delete_account_subtitle;

  /// No description provided for @security_change_language_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Change your language preference'**
  String get security_change_language_subtitle;

  /// No description provided for @change_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get change_language_title;

  /// No description provided for @delete_shipment_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Shipment'**
  String get delete_shipment_title;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @action_cannot_be_undone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Are you sure?'**
  String get action_cannot_be_undone;

  /// No description provided for @shipment_deleted.
  ///
  /// In en, this message translates to:
  /// **'Shipment deleted succusfully'**
  String get shipment_deleted;

  /// No description provided for @shipment_deleted_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete shipment'**
  String get shipment_deleted_failed;

  /// No description provided for @error_fetch_trips.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch Trips: {error}'**
  String error_fetch_trips(Object error);

  /// No description provided for @trip_deleted.
  ///
  /// In en, this message translates to:
  /// **'Shipment deleted succusfully'**
  String get trip_deleted;

  /// No description provided for @trip_deleted_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete shipment'**
  String get trip_deleted_failed;

  /// No description provided for @delete_trip_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Trip'**
  String get delete_trip_title;

  /// No description provided for @middle_stop_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter a city you will stop by'**
  String get middle_stop_hint;

  /// No description provided for @add_stop.
  ///
  /// In en, this message translates to:
  /// **'Add a stop'**
  String get add_stop;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @add_stop_hint.
  ///
  /// In en, this message translates to:
  /// **'You can add optional cities where you’ll stop along the way.'**
  String get add_stop_hint;

  /// No description provided for @no_result.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get no_result;

  /// No description provided for @no_result_message.
  ///
  /// In en, this message translates to:
  /// **'No results found for your search criteria'**
  String get no_result_message;

  /// No description provided for @max_weight.
  ///
  /// In en, this message translates to:
  /// **'Max Weight'**
  String get max_weight;

  /// No description provided for @max_price.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get max_price;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get kg;

  /// No description provided for @dirham.
  ///
  /// In en, this message translates to:
  /// **'dh'**
  String get dirham;

  /// No description provided for @new_search.
  ///
  /// In en, this message translates to:
  /// **'New Search'**
  String get new_search;

  /// No description provided for @applied_filtter.
  ///
  /// In en, this message translates to:
  /// **'Applied Filters'**
  String get applied_filtter;

  /// No description provided for @update_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update shipment'**
  String get update_failed;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get in_progress;

  /// No description provided for @stops.
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noRating.
  ///
  /// In en, this message translates to:
  /// **'⭐ No rating'**
  String get noRating;

  /// No description provided for @noRatingYet.
  ///
  /// In en, this message translates to:
  /// **'⭐ No rating yet'**
  String get noRatingYet;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'⭐ {rating} rating'**
  String rating(Object rating);

  /// No description provided for @email_not_verified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified'**
  String get email_not_verified;

  /// No description provided for @please_verify_email.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email address to access all features'**
  String get please_verify_email;

  /// No description provided for @send_verification_email.
  ///
  /// In en, this message translates to:
  /// **'Send verification email'**
  String get send_verification_email;

  /// No description provided for @verification_email_sent.
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to your new email address. Please check your inbox.'**
  String get verification_email_sent;

  /// No description provided for @error_sending_verification.
  ///
  /// In en, this message translates to:
  /// **'Error sending verification email. Please try again'**
  String get error_sending_verification;

  /// No description provided for @email_verification_note.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send important updates and notifications to your email address'**
  String get email_verification_note;

  /// No description provided for @verify_check_email_title.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get verify_check_email_title;

  /// No description provided for @verify_sent_link_message.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to'**
  String get verify_sent_link_message;

  /// No description provided for @verify_your_email_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Your email'**
  String get verify_your_email_placeholder;

  /// No description provided for @verify_next_steps_title.
  ///
  /// In en, this message translates to:
  /// **'Next steps'**
  String get verify_next_steps_title;

  /// No description provided for @verify_step_1.
  ///
  /// In en, this message translates to:
  /// **'1. Check your email inbox'**
  String get verify_step_1;

  /// No description provided for @verify_step_2.
  ///
  /// In en, this message translates to:
  /// **'2. Click the verification link'**
  String get verify_step_2;

  /// No description provided for @verify_step_3.
  ///
  /// In en, this message translates to:
  /// **'3. Return here and click \"I\'ve verified\"'**
  String get verify_step_3;

  /// No description provided for @verify_button_verified.
  ///
  /// In en, this message translates to:
  /// **'I\'ve verified my email'**
  String get verify_button_verified;

  /// No description provided for @verify_dialog_please_verify_first.
  ///
  /// In en, this message translates to:
  /// **'Please verify your email first.'**
  String get verify_dialog_please_verify_first;

  /// No description provided for @verify_button_resend.
  ///
  /// In en, this message translates to:
  /// **'Resend verification link'**
  String get verify_button_resend;

  /// No description provided for @verify_dialog_email_resent.
  ///
  /// In en, this message translates to:
  /// **'A new email has been sent.'**
  String get verify_dialog_email_resent;

  /// No description provided for @verify_didnt_receive.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the email? Check your spam folder or contact support'**
  String get verify_didnt_receive;

  /// No description provided for @reauth_required_message.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, please log in again before changing your email address.'**
  String get reauth_required_message;

  /// No description provided for @invalid_email_message.
  ///
  /// In en, this message translates to:
  /// **'The email address you entered is not valid. Please check and try again.'**
  String get invalid_email_message;

  /// No description provided for @email_in_use_message.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use by another account.'**
  String get email_in_use_message;

  /// No description provided for @no_changes_detected.
  ///
  /// In en, this message translates to:
  /// **'No changes detected.'**
  String get no_changes_detected;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @motorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get motorcycle;

  /// No description provided for @truck.
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get truck;

  /// No description provided for @van.
  ///
  /// In en, this message translates to:
  /// **'Van'**
  String get van;

  /// No description provided for @bicycle.
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get bicycle;

  /// No description provided for @scooter.
  ///
  /// In en, this message translates to:
  /// **'Scooter'**
  String get scooter;

  /// No description provided for @box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get box;

  /// No description provided for @envelope.
  ///
  /// In en, this message translates to:
  /// **'Envelope'**
  String get envelope;

  /// No description provided for @bag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get bag;

  /// No description provided for @pallet.
  ///
  /// In en, this message translates to:
  /// **'Pallet'**
  String get pallet;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @crate.
  ///
  /// In en, this message translates to:
  /// **'Crate'**
  String get crate;

  /// No description provided for @tube.
  ///
  /// In en, this message translates to:
  /// **'Tube'**
  String get tube;

  /// No description provided for @furniture.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get furniture;

  /// No description provided for @electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronics;

  /// No description provided for @clothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get clothing;

  /// No description provided for @verify_relogin_message.
  ///
  /// In en, this message translates to:
  /// **'After clicking the link in your email, please log out and sign in again with your new email address to complete the update.'**
  String get verify_relogin_message;

  /// No description provided for @choose_from_gallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get choose_from_gallery;

  /// No description provided for @take_a_picture.
  ///
  /// In en, this message translates to:
  /// **'Take a Picture'**
  String get take_a_picture;

  /// No description provided for @upload_photo.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get upload_photo;

  /// No description provided for @photo_format_hint.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG up to 5 MB'**
  String get photo_format_hint;

  /// No description provided for @no_active_shipments_available.
  ///
  /// In en, this message translates to:
  /// **'No active shipments available'**
  String get no_active_shipments_available;

  /// No description provided for @choose_a_shipment.
  ///
  /// In en, this message translates to:
  /// **'Choose a shipment'**
  String get choose_a_shipment;

  /// No description provided for @please_select_shipment.
  ///
  /// In en, this message translates to:
  /// **'Please select a shipment'**
  String get please_select_shipment;

  /// No description provided for @request_already_sent.
  ///
  /// In en, this message translates to:
  /// **'You have already sent a request for this shipment. Please wait for the owner to accept or reject it.'**
  String get request_already_sent;

  /// No description provided for @trip_owner_cannot_request.
  ///
  /// In en, this message translates to:
  /// **'Trip owner cannot send a request for their own shipment.'**
  String get trip_owner_cannot_request;

  /// No description provided for @driver_cannot_create_trip_message.
  ///
  /// In en, this message translates to:
  /// **'You cannot create a trip right now. Please make sure your driver account is active and verified.'**
  String get driver_cannot_create_trip_message;

  /// No description provided for @onboarding_terms_text.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service'**
  String get onboarding_terms_text;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_get_started;

  /// No description provided for @onboarding_1_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to QuickDrop'**
  String get onboarding_1_title;

  /// No description provided for @onboarding_1_body.
  ///
  /// In en, this message translates to:
  /// **'Send and receive packages easily with our peer-to-peer delivery system — faster, cheaper, and more personal.'**
  String get onboarding_1_body;

  /// No description provided for @onboarding_2_title.
  ///
  /// In en, this message translates to:
  /// **'Community-Powered Delivery'**
  String get onboarding_2_title;

  /// No description provided for @onboarding_2_body.
  ///
  /// In en, this message translates to:
  /// **'Connect with trusted travelers going your way. They carry your packages safely while earning extra income.'**
  String get onboarding_2_body;

  /// No description provided for @onboarding_3_title.
  ///
  /// In en, this message translates to:
  /// **'Create Shipments & Trips'**
  String get onboarding_3_title;

  /// No description provided for @onboarding_3_body.
  ///
  /// In en, this message translates to:
  /// **'Register once and unlock everything. Create shipment requests or post your travel routes. Negotiate prices and find the perfect match.'**
  String get onboarding_3_body;

  /// No description provided for @onboarding_4_title.
  ///
  /// In en, this message translates to:
  /// **'Earn While You Travel'**
  String get onboarding_4_title;

  /// No description provided for @onboarding_4_body.
  ///
  /// In en, this message translates to:
  /// **'Deliver packages along your route and get paid instantly. QuickDrop turns every trip into an opportunity.'**
  String get onboarding_4_body;
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
