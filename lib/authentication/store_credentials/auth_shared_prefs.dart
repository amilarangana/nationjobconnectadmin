import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../user_profile/models/user.dart';

class AuthSharedPrefs{
 late final SharedPreferences sharedPrefs;
  final String _PREF_USER = "prefs_user";

  static final AuthSharedPrefs _instance = AuthSharedPrefs._internal();

  factory AuthSharedPrefs() => _instance;

  AuthSharedPrefs._internal();

  Future init() async{
    sharedPrefs = await SharedPreferences.getInstance();
  }

  Future<bool> storeUserCredentials(User user) async {
    return sharedPrefs.setString(_PREF_USER, jsonEncode(user.toJson()));
  }

  User? retrieveSavedUserCredentials() { 
    var userJson = sharedPrefs.getString(_PREF_USER);
    if (userJson != null) {
      return User.fromSPJson(jsonDecode(userJson)) ;
    }
    return null;
  }

  User? removeSavedUserCredentials() { 
    var userJson = sharedPrefs.remove(_PREF_USER);
    
    return null;
  }
}