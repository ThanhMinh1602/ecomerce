import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Keys for preferences
  static const String _onboardingShownKey = 'onboarding_shown';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';

  // ==========================================
  // Onboarding preferences
  // ==========================================

  Future<bool> isOnboardingShown() async {
    return _prefs.getBool(_onboardingShownKey) ?? false;
  }

  Future<void> setOnboardingShown() async {
    await _prefs.setBool(_onboardingShownKey, true);
  }

  // ==========================================
  // Login preferences
  // ==========================================

  Future<bool> isUserLoggedIn() async {
    return _prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setUserLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // ==========================================
  // User email preferences
  // ==========================================

  Future<String?> getUserEmail() async {
    return _prefs.getString(_userEmailKey);
  }

  Future<void> setUserEmail(String email) async {
    await _prefs.setString(_userEmailKey, email);
  }

  // ==========================================
  // Clear all preferences (logout)
  // ==========================================

  Future<void> clearAll() async {
    await _prefs.clear();
  }

  Future<void> clearLoginData() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userEmailKey);
  }
}
