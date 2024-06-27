import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class SharedPreferenceHelper{
  static String reload="0";
  static String userSinup="0";
  static String userNameKey ="USERNAMEKEY";
  static String userIdKey ="USERIDKEY";
  static String userImageKey ="USERIMAGEKEY";
  static String userEmailKey ="USEREMAILKEY";
  static String userPhoneKey ="USERPHONEKEY";
  static String userSex ="USERSEX";
  static String userBirthDate="USERBIRTHDATE";
  static String userInfoListKey="SAVERPASS";

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
  Future<bool> saveUserInfoListUser(List<Map<String, dynamic>> infoList) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userInfoListJson = json.encode(infoList); // Chuyển đổi List thành chuỗi JSON
    return preferences.setString(userInfoListKey, userInfoListJson);
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
  Future<List<Map<String, dynamic>>?> getUserInfoList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfoListJson = preferences.getString(userInfoListKey);
    if (userInfoListJson != null) {
      List<dynamic> userInfoListDynamic = json.decode(userInfoListJson);
      List<Map<String, dynamic>> userInfoList = userInfoListDynamic.cast<Map<String, dynamic>>();
      return userInfoList;
    } else {
      return null;
    }
  }
  Future<bool> addUserInfo(Map<String, dynamic> newUserInfo) async {
    List<Map<String, dynamic>>? userInfoList = await getUserInfoList();
    if (userInfoList == null) {
      userInfoList = [];
    }
    userInfoList.add(newUserInfo);
    return await saveUserInfoListUser(userInfoList);
  }
  String getChatRoomIdUserName(String a, String b) {
    if (a.compareTo(b) > 0) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
  Future<void> deleteUserInfoList(String iduser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfoListJson = preferences.getString(userInfoListKey);
    if (userInfoListJson != null) {
      List<dynamic> userInfoListDynamic = json.decode(userInfoListJson);
      List<Map<String, dynamic>> userInfoList = userInfoListDynamic.cast<Map<String, dynamic>>();
      userInfoList.removeWhere((element) => element['id'] == iduser);
      if (userInfoList.isEmpty) {
        preferences.remove(userInfoListKey);
      } else {
        String updatedUserInfoListJson = json.encode(userInfoList);
        preferences.setString(userInfoListKey, updatedUserInfoListJson);
      }
    }
  }
}