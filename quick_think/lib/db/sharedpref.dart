import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences sharedPreferences;

  /// Set Username
  Future<void> setUsername(String username) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = "username";
    final storedValue = username;
    sharedPreferences.setString(key, storedValue);
  }

//Get Username
  Future<String> getUsername() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = "username";
    final userStored = sharedPreferences.getString(key) ?? '0';

    return userStored;
  }

  /// Set Username
  Future<void> setIsNewUSer(bool username) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = "new";
    final storedValue = username;
    sharedPreferences.setBool(key, storedValue);
  }

//Get Username
  Future<bool> getIsNewUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final key = "new";
    final userStored = sharedPreferences.getBool(key) ?? false;

    return userStored;
  }
}
