import 'package:util_commons/utils/network/config/response/api_response_error.dart';

class ApiResponse<T> {
  final int code;
  String? body;
  T? data;
  ApiResponseError? error;
  ApiResponse({required this.code, this.body, this.data, this.error});
}
