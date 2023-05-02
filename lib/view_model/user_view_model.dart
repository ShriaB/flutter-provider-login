import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvvm_provider_login/model/user_model.dart';

class UserViewModel with ChangeNotifier {
  UserModel? user;
  bool isUserLoggedIn = false;

  Future<void> saveUser(UserModel user) async {
    this.user = user;
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("token", user.token.toString());
    isUserLoggedIn = true;
    notifyListeners();
  }

  Future<bool> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString("token");
    if (token != null) {
      user = UserModel(token);
      isUserLoggedIn = true;
    }
    notifyListeners();
    return isUserLoggedIn;
  }

  Future<void> clearUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    isUserLoggedIn = false;
    notifyListeners();
  }
}
