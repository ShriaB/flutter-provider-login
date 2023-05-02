import 'dart:io';

import 'package:mvvm_provider_login/data/api_exceptions.dart';
import 'package:mvvm_provider_login/data/network/base_api_services.dart';
import 'package:mvvm_provider_login/model/user_model.dart';
import 'package:mvvm_provider_login/repository/login_repository.dart';
import 'package:mvvm_provider_login/utils/resources/api_endpoints.dart';

class LoginRepositoryImpl extends LoginRepository {
  final BaseApiServices _apiService;

  LoginRepositoryImpl(this._apiService);

  /// Takes the data that is to be posted to server
  /// If successful Returns the UserModel containing the aunthorisation token
  @override
  Future<UserModel> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiService.postData(ApiEndpoints.LOGIN_URL, body: data);
      return UserModel(response['token']);
    } on SocketException {
      rethrow;
    } on UnauthorisedException {
      rethrow;
    } on ServerError {
      rethrow;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  /// Takes the data that is to be posted to server
  /// If successful Returns the UserModel containing the aunthorisation token
  @override
  Future<dynamic> registerApi(dynamic data) async {
    try {
      dynamic response =
          await _apiService.postData(ApiEndpoints.REGISTER_URL, body: data);
      return UserModel(response['token']);
    } on SocketException {
      rethrow;
    } on ServerError {
      rethrow;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
