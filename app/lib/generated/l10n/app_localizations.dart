import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'BharatTesting Utilities'**
  String get appTitle;

  /// Title for the home screen
  ///
  /// In en, this message translates to:
  /// **'Developer Tools'**
  String get homeTitle;

  /// Title for the document scanner tool
  ///
  /// In en, this message translates to:
  /// **'Document Scanner'**
  String get documentScannerTitle;

  /// Title for the image size reducer tool
  ///
  /// In en, this message translates to:
  /// **'Image Size Reducer'**
  String get imageSizeReducerTitle;

  /// Title for the PDF merger tool
  ///
  /// In en, this message translates to:
  /// **'PDF Merger'**
  String get pdfMergerTitle;

  /// Title for the string-to-JSON converter tool
  ///
  /// In en, this message translates to:
  /// **'String-to-JSON Converter'**
  String get stringToJsonTitle;

  /// Title for the JSON converter screen
  ///
  /// In en, this message translates to:
  /// **'String-to-JSON Converter'**
  String get jsonConverterTitle;

  /// Subtitle for the JSON converter screen
  ///
  /// In en, this message translates to:
  /// **'Auto-detect format, repair JSON, convert to JSON'**
  String get jsonConverterSubtitle;

  /// Title for the Indian data faker tool
  ///
  /// In en, this message translates to:
  /// **'Indian Data Faker'**
  String get dataFakerTitle;

  /// Title for the about page
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// Subtitle for document scanner
  ///
  /// In en, this message translates to:
  /// **'Scan documents with camera, edge detection, OCR, and PDF export'**
  String get documentScannerSubtitle;

  /// Camera permission required message
  ///
  /// In en, this message translates to:
  /// **'Camera Permission Required'**
  String get cameraPermissionRequired;

  /// Camera permission description
  ///
  /// In en, this message translates to:
  /// **'Allow camera access to scan documents'**
  String get cameraPermissionDescription;

  /// Open settings button text
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Batch scanning mode title
  ///
  /// In en, this message translates to:
  /// **'Batch Scanning Mode'**
  String get batchScanningMode;

  /// Batch scanning mode description
  ///
  /// In en, this message translates to:
  /// **'Scan multiple documents in sequence'**
  String get batchScanningDescription;

  /// Start scanning button text
  ///
  /// In en, this message translates to:
  /// **'Start Scanning'**
  String get startScanning;

  /// Scanner mode label
  ///
  /// In en, this message translates to:
  /// **'Scanner Mode'**
  String get scannerMode;

  /// Camera settings section title
  ///
  /// In en, this message translates to:
  /// **'Camera Settings'**
  String get cameraSettings;

  /// Flashlight toggle label
  ///
  /// In en, this message translates to:
  /// **'Flash'**
  String get flashlight;

  /// Flashlight toggle description
  ///
  /// In en, this message translates to:
  /// **'Enable camera flash'**
  String get flashlightDescription;

  /// Auto capture toggle label
  ///
  /// In en, this message translates to:
  /// **'Auto Capture'**
  String get autoCapture;

  /// Auto capture toggle description
  ///
  /// In en, this message translates to:
  /// **'Automatically capture when document is stable'**
  String get autoCaptureDescription;

  /// Zoom control label
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoom;

  /// OCR text detected indicator
  ///
  /// In en, this message translates to:
  /// **'OCR text detected'**
  String get ocrTextDetected;

  /// Scanner settings title
  ///
  /// In en, this message translates to:
  /// **'Scanner Settings'**
  String get scannerSettings;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
