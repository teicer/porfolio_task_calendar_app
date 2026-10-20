import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @we_have_work_to_do.
  ///
  /// In en, this message translates to:
  /// **'We have work to do'**
  String get we_have_work_to_do;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signin;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signup;

  /// No description provided for @login_message.
  ///
  /// In en, this message translates to:
  /// **'Please enter your credentials to login'**
  String get login_message;

  /// No description provided for @register_message.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the form to register'**
  String get register_message;

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

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Switch to login'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Switch to register'**
  String get dont_have_account;

  /// No description provided for @success_login.
  ///
  /// In en, this message translates to:
  /// **'Successful login'**
  String get success_login;

  /// No description provided for @success_register.
  ///
  /// In en, this message translates to:
  /// **'Successful registration'**
  String get success_register;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @please_fill_all_fields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get please_fill_all_fields;

  /// No description provided for @invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalid_credentials;

  /// No description provided for @email_not_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email address first.'**
  String get email_not_confirmed;

  /// No description provided for @user_already_exists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get user_already_exists;

  /// No description provided for @email_address_invalid.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid.'**
  String get email_address_invalid;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'The password is too weak.'**
  String get weak_password;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'The password is too short.'**
  String get password_too_short;

  /// No description provided for @signup_disabled.
  ///
  /// In en, this message translates to:
  /// **'Sign up is currently disabled.'**
  String get signup_disabled;

  /// No description provided for @session_not_found.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again.'**
  String get session_not_found;

  /// No description provided for @refresh_token_not_found.
  ///
  /// In en, this message translates to:
  /// **'Your session is no longer valid.'**
  String get refresh_token_not_found;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get user_not_found;

  /// No description provided for @email_exists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists.'**
  String get email_exists;

  /// No description provided for @user_not_authenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated.'**
  String get user_not_authenticated;

  /// No description provided for @unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Unknown error.'**
  String get unknown_error;

  /// No description provided for @home_related.
  ///
  /// In en, this message translates to:
  /// **'Home Related'**
  String get home_related;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @fitness_health.
  ///
  /// In en, this message translates to:
  /// **'Fitness & Health'**
  String get fitness_health;

  /// No description provided for @mandatory_work.
  ///
  /// In en, this message translates to:
  /// **'Mandatory Work'**
  String get mandatory_work;

  /// No description provided for @educational.
  ///
  /// In en, this message translates to:
  /// **'Educational'**
  String get educational;

  /// No description provided for @work_related.
  ///
  /// In en, this message translates to:
  /// **'Work Related'**
  String get work_related;

  /// No description provided for @hobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get hobbies;

  /// No description provided for @grocery.
  ///
  /// In en, this message translates to:
  /// **'Grocery'**
  String get grocery;

  /// No description provided for @personal_notes.
  ///
  /// In en, this message translates to:
  /// **'Personal Notes'**
  String get personal_notes;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get scheduled;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @no_tasks_available.
  ///
  /// In en, this message translates to:
  /// **'No tasks available'**
  String get no_tasks_available;

  /// No description provided for @todays_tasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get todays_tasks;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @task.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task;

  /// No description provided for @calendar_days_str.
  ///
  /// In en, this message translates to:
  /// **'M,T,W,T,F,S,S'**
  String get calendar_days_str;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @task_details.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get task_details;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @subtasks.
  ///
  /// In en, this message translates to:
  /// **'Subtasks'**
  String get subtasks;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @insert_success.
  ///
  /// In en, this message translates to:
  /// **'Insert successful'**
  String get insert_success;

  /// No description provided for @update_success.
  ///
  /// In en, this message translates to:
  /// **'Update successful'**
  String get update_success;

  /// No description provided for @delete_success.
  ///
  /// In en, this message translates to:
  /// **'Delete successful'**
  String get delete_success;

  /// No description provided for @edit_sub_task.
  ///
  /// In en, this message translates to:
  /// **'Edit Sub-Task'**
  String get edit_sub_task;

  /// No description provided for @add_sub_task.
  ///
  /// In en, this message translates to:
  /// **'Add Sub-Task'**
  String get add_sub_task;

  /// No description provided for @enter_sub_task.
  ///
  /// In en, this message translates to:
  /// **'Enter sub-task....'**
  String get enter_sub_task;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @create_task.
  ///
  /// In en, this message translates to:
  /// **'Create Task'**
  String get create_task;

  /// No description provided for @update_task.
  ///
  /// In en, this message translates to:
  /// **'Update Task'**
  String get update_task;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @title_hint.
  ///
  /// In en, this message translates to:
  /// **'Give a title'**
  String get title_hint;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @notes_hint.
  ///
  /// In en, this message translates to:
  /// **'Add a description'**
  String get notes_hint;

  /// No description provided for @save_task.
  ///
  /// In en, this message translates to:
  /// **'Save Task'**
  String get save_task;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
