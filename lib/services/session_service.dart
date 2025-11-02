import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyEmail = 'user_email';
  static const String _keyUsername = 'user_username';

  static Future<void> saveUserSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, user['email']);
    await prefs.setString(_keyUsername, user['username']);
  }

  static Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyEmail);
    final username = prefs.getString(_keyUsername);
    if (email != null && username != null) {
      return {'email': email, 'username': username};
    }
    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
