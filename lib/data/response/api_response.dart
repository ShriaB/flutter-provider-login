import 'package:mvvm_provider_login/data/response/status.dart';

/// [status] stores the current status of the API call (loading/successful/error)
/// [data] Stores the data if the API request is successful
/// [errorMessage] Stores the message in case the request failed and there was an error

class ApiResponse<T> {
  Status? status;
  T? data;
  Error? error;

  ApiResponse.loading() : status = Status.LOADING;

  ApiResponse.success(this.data) : status = Status.SUCCESS;

  ApiResponse.error(this.error) : status = Status.ERROR;
}
