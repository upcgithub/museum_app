// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Museum App';

  @override
  String get loginTitle => 'Log In';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get logInButton => 'Log In';

  @override
  String get orLoginWith => 'Or login with';

  @override
  String get google => 'Google';

  @override
  String get apple => 'Apple';

  @override
  String get createAccount => 'Create Account';

  @override
  String get signUp => 'Sign Up';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get firstNameLabel => 'First Name';

  @override
  String get lastNameLabel => 'Last Name';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get acceptTerms => 'I accept the Terms and Conditions';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get orSignUpWith => 'Or sign up with';

  @override
  String get signupAgreementPrefix => 'By signing up, you agree to the ';

  @override
  String get signupAgreementConjunction => ' and ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get dataProcessingAgreement => 'Data Processing Agreement';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String get profileName => 'Jane Doe';

  @override
  String get profileEmail => 'jane@gmail.com';

  @override
  String get savedArtworks => 'Saved Artworks';

  @override
  String get tickets => 'Tickets';

  @override
  String get exhibitions => 'Exhibitions';

  @override
  String get qrScans => 'QR Scans';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get languagePreferences => 'Language Preferences';

  @override
  String get accessibilitySettings => 'Accessibility Settings';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get artQuote =>
      'Art enables us to find ourselves and lose ourselves at the same time.';

  @override
  String get location => 'Location';

  @override
  String get limaPeru => 'Lima, Peru';

  @override
  String get searchExhibitionsEvents => 'Search exhibitions, events...';

  @override
  String get exhibition => 'Exhibition';

  @override
  String get events => 'Events';

  @override
  String get artwork => 'Artwork';

  @override
  String get artist => 'Artist';

  @override
  String get popular => 'Popular';

  @override
  String get viewAll => 'View All';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get artworks => 'Artworks';

  @override
  String get noArtworksFound => 'No artworks found';

  @override
  String get loadingSavedArtworks => 'Loading saved artworks...';

  @override
  String get retry => 'Retry';

  @override
  String get noSavedArtworksYet => 'No saved artworks yet';

  @override
  String get startExploringAndSave =>
      'Start exploring and save your favorite artworks!';

  @override
  String get remove => 'Remove';

  @override
  String get removeFromSaved => 'Remove from Saved';

  @override
  String areYouSureRemove(String artworkTitle) {
    return 'Are you sure you want to remove \"$artworkTitle\" from your saved artworks?';
  }

  @override
  String artworkRemovedFromSaved(String artworkTitle) {
    return '$artworkTitle removed from saved';
  }

  @override
  String artworkSavedToCollection(String artworkTitle) {
    return '$artworkTitle saved to your collection';
  }

  @override
  String get undo => 'Undo';

  @override
  String get undoFunctionalityComingSoon => 'Undo functionality coming soon!';

  @override
  String savedOn(String date) {
    return 'Saved on $date';
  }

  @override
  String get ticketsScreen => 'Tickets Screen';

  @override
  String get playAudio => 'Play Audio';

  @override
  String get pauseAudio => 'Pause Audio';

  @override
  String get relatedArtworks => 'Related Artworks';

  @override
  String get saveArtwork => 'Save Artwork';

  @override
  String get removeFromSavedArtworks => 'Remove from Saved Artworks';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get relatedToThisArtwork => 'Related to this artwork';

  @override
  String get viewed => 'Viewed';

  @override
  String get captchaInstruction => 'Select the icons alphabetically';

  @override
  String get captchaSolved => 'Verified';

  @override
  String get captchaReset => 'Try a different sequence';

  @override
  String get captchaMuseumLabel => 'Museum';

  @override
  String get captchaPaletteLabel => 'Palette';

  @override
  String get captchaTheaterLabel => 'Theater';
}
