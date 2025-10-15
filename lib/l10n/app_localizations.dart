import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Museum App'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @logInButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logInButton;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get orLoginWith;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms and Conditions'**
  String get acceptTerms;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign up with'**
  String get orSignUpWith;

  /// No description provided for @signupAgreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you agree to the '**
  String get signupAgreementPrefix;

  /// No description provided for @signupAgreementConjunction.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get signupAgreementConjunction;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @dataProcessingAgreement.
  ///
  /// In en, this message translates to:
  /// **'Data Processing Agreement'**
  String get dataProcessingAgreement;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Jane Doe'**
  String get profileName;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'jane@gmail.com'**
  String get profileEmail;

  /// No description provided for @savedArtworks.
  ///
  /// In en, this message translates to:
  /// **'Saved Artworks'**
  String get savedArtworks;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @exhibitions.
  ///
  /// In en, this message translates to:
  /// **'Exhibitions'**
  String get exhibitions;

  /// No description provided for @qrScans.
  ///
  /// In en, this message translates to:
  /// **'QR Scans'**
  String get qrScans;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @languagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Language Preferences'**
  String get languagePreferences;

  /// No description provided for @accessibilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
  String get accessibilitySettings;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @artQuote.
  ///
  /// In en, this message translates to:
  /// **'Art enables us to find ourselves and lose ourselves at the same time.'**
  String get artQuote;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @limaPeru.
  ///
  /// In en, this message translates to:
  /// **'Lima, Peru'**
  String get limaPeru;

  /// No description provided for @searchExhibitionsEvents.
  ///
  /// In en, this message translates to:
  /// **'Search exhibitions, events...'**
  String get searchExhibitionsEvents;

  /// No description provided for @exhibition.
  ///
  /// In en, this message translates to:
  /// **'Exhibition'**
  String get exhibition;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @artwork.
  ///
  /// In en, this message translates to:
  /// **'Artwork'**
  String get artwork;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get whatsNew;

  /// No description provided for @artworks.
  ///
  /// In en, this message translates to:
  /// **'Artworks'**
  String get artworks;

  /// No description provided for @noArtworksFound.
  ///
  /// In en, this message translates to:
  /// **'No artworks found'**
  String get noArtworksFound;

  /// No description provided for @loadingSavedArtworks.
  ///
  /// In en, this message translates to:
  /// **'Loading saved artworks...'**
  String get loadingSavedArtworks;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noSavedArtworksYet.
  ///
  /// In en, this message translates to:
  /// **'No saved artworks yet'**
  String get noSavedArtworksYet;

  /// No description provided for @startExploringAndSave.
  ///
  /// In en, this message translates to:
  /// **'Start exploring and save your favorite artworks!'**
  String get startExploringAndSave;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeFromSaved.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved'**
  String get removeFromSaved;

  /// No description provided for @areYouSureRemove.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{artworkTitle}\" from your saved artworks?'**
  String areYouSureRemove(String artworkTitle);

  /// No description provided for @artworkRemovedFromSaved.
  ///
  /// In en, this message translates to:
  /// **'{artworkTitle} removed from saved'**
  String artworkRemovedFromSaved(String artworkTitle);

  /// No description provided for @artworkSavedToCollection.
  ///
  /// In en, this message translates to:
  /// **'{artworkTitle} saved to your collection'**
  String artworkSavedToCollection(String artworkTitle);

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @undoFunctionalityComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Undo functionality coming soon!'**
  String get undoFunctionalityComingSoon;

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOn(String date);

  /// No description provided for @ticketsScreen.
  ///
  /// In en, this message translates to:
  /// **'Tickets Screen'**
  String get ticketsScreen;

  /// No description provided for @playAudio.
  ///
  /// In en, this message translates to:
  /// **'Play Audio'**
  String get playAudio;

  /// No description provided for @pauseAudio.
  ///
  /// In en, this message translates to:
  /// **'Pause Audio'**
  String get pauseAudio;

  /// No description provided for @relatedArtworks.
  ///
  /// In en, this message translates to:
  /// **'Related Artworks'**
  String get relatedArtworks;

  /// No description provided for @saveArtwork.
  ///
  /// In en, this message translates to:
  /// **'Save Artwork'**
  String get saveArtwork;

  /// No description provided for @removeFromSavedArtworks.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved Artworks'**
  String get removeFromSavedArtworks;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @relatedToThisArtwork.
  ///
  /// In en, this message translates to:
  /// **'Related to this artwork'**
  String get relatedToThisArtwork;

  /// No description provided for @viewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get viewed;

  /// No description provided for @captchaInstruction.
  ///
  /// In en, this message translates to:
  /// **'Select the icons alphabetically'**
  String get captchaInstruction;

  /// No description provided for @captchaSolved.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get captchaSolved;

  /// No description provided for @captchaReset.
  ///
  /// In en, this message translates to:
  /// **'Try a different sequence'**
  String get captchaReset;

  /// No description provided for @captchaMuseumLabel.
  ///
  /// In en, this message translates to:
  /// **'Museum'**
  String get captchaMuseumLabel;

  /// No description provided for @captchaPaletteLabel.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get captchaPaletteLabel;

  /// No description provided for @captchaTheaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Theater'**
  String get captchaTheaterLabel;

  /// No description provided for @aiFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get aiFeaturesTitle;

  /// No description provided for @playAudioGuide.
  ///
  /// In en, this message translates to:
  /// **'Play Audio Guide'**
  String get playAudioGuide;

  /// No description provided for @playAudioGuideDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen to narration about this artwork'**
  String get playAudioGuideDesc;

  /// No description provided for @chatWithArtist.
  ///
  /// In en, this message translates to:
  /// **'Chat with {artist}'**
  String chatWithArtist(String artist);

  /// No description provided for @chatWithArtistDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask questions about this artwork'**
  String get chatWithArtistDesc;

  /// No description provided for @stylizeYourPhoto.
  ///
  /// In en, this message translates to:
  /// **'Stylize Your Photo'**
  String get stylizeYourPhoto;

  /// No description provided for @stylizeYourPhotoDesc.
  ///
  /// In en, this message translates to:
  /// **'Transform a photo in {artist}\'s style'**
  String stylizeYourPhotoDesc(String artist);

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendMessage;

  /// No description provided for @typeYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type your question...'**
  String get typeYourQuestion;

  /// No description provided for @applyingStyle.
  ///
  /// In en, this message translates to:
  /// **'Applying {artist}\'s style...'**
  String applyingStyle(String artist);

  /// No description provided for @selectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Photo'**
  String get selectPhoto;

  /// No description provided for @shareStylizedImage.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareStylizedImage;

  /// No description provided for @downloadImage.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadImage;

  /// No description provided for @originalImage.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalImage;

  /// No description provided for @stylizedImage.
  ///
  /// In en, this message translates to:
  /// **'Stylized'**
  String get stylizedImage;

  /// No description provided for @chatError.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please try again.'**
  String get chatError;

  /// No description provided for @styleTransferError.
  ///
  /// In en, this message translates to:
  /// **'Failed to stylize image. Please try again.'**
  String get styleTransferError;

  /// No description provided for @qrScannerTitle.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get qrScannerTitle;

  /// No description provided for @qrScannerInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the artwork\'s\nQR code'**
  String get qrScannerInstruction;

  /// No description provided for @qrScannerKeepInArea.
  ///
  /// In en, this message translates to:
  /// **'Keep the code within\nthe scan area'**
  String get qrScannerKeepInArea;

  /// No description provided for @artistStyle.
  ///
  /// In en, this message translates to:
  /// **'{artist} style'**
  String artistStyle(String artist);

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @thisMayTakeAMoment.
  ///
  /// In en, this message translates to:
  /// **'This may take a moment...'**
  String get thisMayTakeAMoment;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @imageStylizedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image stylized successfully using {artist}\'s artistic style!'**
  String imageStylizedSuccessfully(String artist);

  /// No description provided for @aiStyleTransferGuide.
  ///
  /// In en, this message translates to:
  /// **'AI Style Transfer Guide'**
  String get aiStyleTransferGuide;

  /// No description provided for @aiStyleGuideNote.
  ///
  /// In en, this message translates to:
  /// **'Note: This is an AI-generated style guide for {artist}\'s artistic approach.'**
  String aiStyleGuideNote(String artist);

  /// No description provided for @tryAnother.
  ///
  /// In en, this message translates to:
  /// **'Try Another'**
  String get tryAnother;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @imageSaved.
  ///
  /// In en, this message translates to:
  /// **'Image saved successfully!'**
  String get imageSaved;

  /// No description provided for @imageSharedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image shared successfully!'**
  String get imageSharedSuccessfully;

  /// No description provided for @shareError.
  ///
  /// In en, this message translates to:
  /// **'Failed to share image. Please try again.'**
  String get shareError;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save image. Please try again.'**
  String get saveError;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent'**
  String get passwordResetEmailSent;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @stylizedGallery.
  ///
  /// In en, this message translates to:
  /// **'Stylized Gallery'**
  String get stylizedGallery;

  /// No description provided for @photosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =0{photos} =1{photo} other{photos}}'**
  String photosCount(int count);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noPhotosForArtist.
  ///
  /// In en, this message translates to:
  /// **'No photos for {artist}'**
  String noPhotosForArtist(String artist);

  /// No description provided for @noStylizedPhotosYet.
  ///
  /// In en, this message translates to:
  /// **'No Stylized Photos Yet'**
  String get noStylizedPhotosYet;

  /// No description provided for @createYourFirstStylizedPhoto.
  ///
  /// In en, this message translates to:
  /// **'Create your first stylized photo by exploring artworks and using the AI style transfer feature!'**
  String get createYourFirstStylizedPhoto;

  /// No description provided for @startCreating.
  ///
  /// In en, this message translates to:
  /// **'Start Creating'**
  String get startCreating;

  /// No description provided for @deletePhoto.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get deletePhoto;

  /// No description provided for @deletePhotoConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this photo? This action cannot be undone.'**
  String get deletePhotoConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @photoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted successfully'**
  String get photoDeleted;

  /// No description provided for @stylizedPhotos.
  ///
  /// In en, this message translates to:
  /// **'Stylized Photos'**
  String get stylizedPhotos;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
