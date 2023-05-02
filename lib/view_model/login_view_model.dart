import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mvvm_provider_login/data/api_exceptions.dart';
import 'package:mvvm_provider_login/data/response/api_response.dart';
import 'package:mvvm_provider_login/data/response/status.dart';
import 'package:mvvm_provider_login/model/user_model.dart';
import 'package:mvvm_provider_login/repository/login_repository.dart';
import 'package:mvvm_provider_login/view_model/user_view_model.dart';

class LoginViewModel with ChangeNotifier {
  final LoginRepository repository;
  ApiResponse<UserModel>? _data;
  ApiResponse<UserModel>? get data => _data;

  LoginViewModel(this.repository);

  setApiResponse(ApiResponse<UserModel> res) {
    print(" data : ${_data?.status}, ${_data?.data?.token}, ${_data?.error}");

    _data = res;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    print("In viewModel login");
    Map<String, String> data = {"email": email, "password": password};

    setApiResponse(ApiResponse.loading());

    await repository.loginApi(data).then((value) {
      print(" response : ${value.token}");
      setApiResponse(ApiResponse.success(value));
      UserViewModel().saveUser(value);
    }).onError<SocketException>((error, stackTrace) {
      setApiResponse(ApiResponse.error(Error.NO_INTERNET));
    }).onError<UnauthorisedException>((error, stackTrace) {
      setApiResponse(ApiResponse.error(Error.UNAUTHORISED));
    }).onError((error, stackTrace) {
      setApiResponse(ApiResponse.error(Error.SERVER_ERROR));
    });
  }

  Future<void> signup(String email, String password) async {
    Map<String, String> data = {"email": email, "password": password};

    await repository.registerApi(data).then((value) {
      setApiResponse(ApiResponse.success(value));
    }).onError<SocketException>((error, stackTrace) {
      setApiResponse(ApiResponse.error(Error.NO_INTERNET));
    }).onError((error, stackTrace) {
      setApiResponse(ApiResponse.error(Error.SERVER_ERROR));
    });
  }
}
