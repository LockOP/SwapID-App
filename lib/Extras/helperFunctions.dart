import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USERPHONEKEY";
  static String sharedPreferenceMemberPhoneKey = "MEMBERPHONEKEY";
  static String sharedPreferenceMemberNameKey = "MEMBERNAMEKEY";
  static String sharedPreferenceCaptionKey = "IMAGEKEY";

  /// saving data to sharedpreference

  static Future<bool> saveUserLoggedInSharedPreference(bool isUserLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveMemberPhoneSharedPreference(String memberPhone) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceMemberPhoneKey, memberPhone);
  }

  static Future<bool> saveMemberNameSharedPreference(String memberName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceMemberNameKey, memberName);
  }

  static Future<bool> saveCaptionSharedPreference(String caption) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceCaptionKey, caption);
  }

  /// fetching data from sharedpreference

  static Future<bool> getUserLoggedInSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceUserEmailKey);
  }

  static Future<String> getMemberPhoneSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceMemberPhoneKey);
  }

  static Future<String> getMemberNameSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceMemberNameKey);
  }

  static Future<String> getCaptionSharedPreference() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(sharedPreferenceCaptionKey);
  }


}