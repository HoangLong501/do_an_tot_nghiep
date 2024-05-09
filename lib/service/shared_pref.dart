import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper{
  static String userSinup="0";
  static String userNameKey ="USERNAMEKEY";
  static String userIdKey ="USERIDKEY";
  static String userImageKey ="USERIMAGEKEY";
  static String userEmailKey ="USEREMAILKEY";
  static String userPhoneKey ="USERPHONEKEY";
  static String userSex ="USERSEX";
  static String userBirthDate="USERBIRTHDATE";

  Future<bool> saveBirthDate(String getBirthDate) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userBirthDate, getBirthDate);
  }
  Future<bool> saveSex(String getSex) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userSex, getSex);
  }
  Future<bool> savesigup(String getSigup) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userSinup, getSigup);
  }

  Future<bool> saveIdUser(String getIdUser) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userIdKey, getIdUser);
  }
  Future<bool> saveImageUser(String img) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userImageKey, img);
  }
  Future<bool> saveUserName(String getUserName) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userNameKey, getUserName);
  }
  Future<bool> saveUserEmail(String getUserEmail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userEmailKey, getUserEmail);
  }
  Future<bool> saveUserPhone(String getUserPhone) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(userPhoneKey, getUserPhone);
  }

  Future<String?> getUerBirthDate()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userBirthDate);
  }
  Future<String?> getUserSex()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userSex);
  }
  Future<String?> getUerSinup()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userSinup);
  }
  Future<String?> getIdUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userIdKey);
  }
  Future<String?> getImageUser()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userImageKey);
  }
  Future<String?> getUserName()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userNameKey);
  }
  Future<String?> getUserEmail()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userEmailKey);
  }
  Future<String?> getUserPhone()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(userPhoneKey);
  }

}