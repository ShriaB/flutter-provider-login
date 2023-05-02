import 'dart:developer';
import 'dart:io';

import 'package:mvvm_provider_login/data/api_exceptions.dart';
import 'package:mvvm_provider_login/data/network/base_api_services.dart';
import 'package:mvvm_provider_login/resources/api_endpoints.dart';

class LoginRepository {
  final BaseApiServices _apiService;

  LoginRepository(this._apiService);

  Future<dynamic> loginApi(dynamic data) async {
    try {
      dynamic response =
          await _apiService.postData(ApiEndpoints.LOGIN_URL, body: data);
      return response;
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

  Future<dynamic> registerApi(dynamic data) async {
    try {
      dynamic response =
          await _apiService.postData(ApiEndpoints.REGISTER_URL, body: data);
      return response;
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
}
