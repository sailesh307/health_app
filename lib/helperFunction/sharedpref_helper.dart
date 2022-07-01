
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

final String _userIdKey = "USERIDKEY";
final String _userNameKey = "USERNAMEKEY";
final String _accountTypeKey = "ACCOUNTTYPEKEY";
final String _profileUrlKey = "PROFILEURLKEY";

// save data
  Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userNameKey, userName);
  }

  Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_userIdKey, userId);
  }

  Future<bool> saveAccountType(bool accountType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_accountTypeKey, accountType);
  }

  Future<bool> saveProfileUrl(String profileUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_profileUrlKey, profileUrl);
  }

  // get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<bool?> getAccountType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_accountTypeKey);
  }

  Future<String?> getProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileUrlKey);
  }


}