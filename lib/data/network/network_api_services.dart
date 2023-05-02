import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mvvm_provider_login/data/api_exceptions.dart';
import 'package:mvvm_provider_login/data/network/base_api_services.dart';
import 'package:http/http.dart';

class NetworkApiServices extends BaseApiServices {
  dynamic responseData;

  @override
  Future getData(String url) async {
    try {
      Response apiResponse = await get(Uri.parse(url));
      responseData = getDataFromJson(apiResponse);
      return responseData;
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

  @override
  Future postData(String url, {body, headers}) async {
    try {
      Response apiResponse =
          await post(Uri.parse(url), body: body, headers: headers);
      responseData = getDataFromJson(apiResponse);
      return responseData;
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

  dynamic getDataFromJson(Response apiResponse) {
    switch (apiResponse.statusCode) {
      case 200:
        {
          return jsonDecode(apiResponse.body);
        }
      case 400:
        {
          throw UnauthorisedException();
        }
      case 500:
        {
          throw ServerError();
        }
    }
  }
}
