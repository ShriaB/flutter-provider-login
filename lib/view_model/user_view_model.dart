import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mvvm_provider_login/model/user_model.dart';

class UserViewModel with ChangeNotifier {
  UserModel? user;

  Future<bool> saveUser(UserModel user) async {
    this.user = user;
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("token", user.token.toString());
    notifyListeners();
    return true;
  }

  Future<void> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? token = sp.getString("token");
    if (token != null) {
      user = UserModel(token);
    }
    notifyListeners();
  }

  Future<bool> clearUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
    notifyListeners();
    return true;
  }
}
