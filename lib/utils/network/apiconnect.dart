import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:util_commons/utils/extensions/extension_string.dart';
import 'package:util_commons/utils/network/config/response/api_request.dart';
import 'package:util_commons/utils/network/config/response/api_response.dart';
import 'package:util_commons/utils/network/config/response/api_response_error.dart';
import 'package:util_commons/utils/network/config/response/request_base.dart';
import 'package:util_commons/utils/network/config/response/response.dart';
import 'package:util_commons/utils/network/config/response/response_to_base.dart';

import 'api/baseapi.dart';

class ApiConnect extends BaseApi {
  String? baseUrl;

  ApiConnect(this.baseUrl);

  Future<ApiResponse<T>> executePost2<T>(
      {required ApiRequest request,
      String? otherAuthority,
      String? path,
      Map<String, String>? headers}) async {
    final uri = Uri.https(otherAuthority ?? baseUrl ?? "");

    final internetavailable = await super.connectionInternetAvailable();
    if (!internetavailable.isSuccess) {
      return ApiResponse(code: 0, error: IntertnetNotAvailable());
    }
    try {
      final response =
          await http.post(uri, headers: headers, body: request.toJson());
      if (response.body.isNotEmpty && super.isValidJson(response.body)) {
        final baseData = T is ResponseToApi ? T as ResponseToApi : null;
        return ApiResponse<T>(
            code: response.statusCode,
            body: response.body,
            data: baseData?.fromJson(response.body));
      } else {
        return ApiResponse<T>(
            code: response.statusCode,
            body: response.body,
            error: FormatWrongJson());
      }
    } catch (ex) {
      if (ex is TimeoutException) {
        return ApiResponse(code: 0, error: TimeoutError());
      } else {
        return ApiResponse(code: 0, error: ErrorServerError());
      }
    }
  }

  Future<ResponseBase> executeGet(
      {required String path,
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      String? key,
      String? otherAuthority}) async {
    final uri = Uri.https(otherAuthority ?? baseUrl ?? "", path, params);
    ResponseBase responseData = await super.connectionInternetAvailable();

    if (!responseData.isSuccess) {
      return responseData;
    }

    "REQUEST -> GET".log();
    "REQUEST URL -> ${uri.toString()}".log();

    await http.get(uri, headers: headers).then((response) {
      "RESPONSE CODE-> ${response.statusCode}".log();
      "RESPONSE BODY-> ${response.body}".log();

      super.validateStatusCode(response.statusCode, responseData);
      if (responseData.isSuccess) {
        super.setBodyJson(response.body, responseData);
      }
    }).onError((dynamic error, stackTrace) {
      super.buildErrorGeneral(responseData);
    }).timeout(Duration(minutes: super.timeOutMinutes), onTimeout: () {
      super.buildTimeOut(responseData);
    }).catchError((onError, stack) {
      super.buildException(responseData);
    });

    return responseData;
  }

  Future<ResponseBase> executePost(String request,
      {RequestBase? requestData, String? otherAuthority, String? path}) async {
    final uri = Uri.https(otherAuthority ?? baseUrl ?? "");
    final ResponseBase responseData = await super.connectionInternetAvailable();

    if (!responseData.isSuccess) {
      return responseData;
    }

    "REQUEST -> POST".log();
    "REQUEST -> $request".log();
    "REQUEST URL -> ${uri.toString()}".log();

    await http
        .post(uri,
            headers: <String, String>{
              super.jsonType: super.jsonConfiguration,
            },
            body: requestData?.toJson() ?? request)
        .then((response) {
      "RESPONSE CODE-> ${response.statusCode}".log();
      "RESPONSE BODY-> ${response.body}".log();

      super.validateStatusCode(response.statusCode, responseData);
      if (responseData.isSuccess) {
        super.setBodyJson(response.body, responseData);
      }
    }).onError((dynamic error, stackTrace) {
      super.buildErrorGeneral(responseData);
    }).timeout(Duration(minutes: super.timeOutMinutes), onTimeout: () {
      super.buildTimeOut(responseData);
    }).catchError((onError, stack) {
      super.buildException(responseData);
    });

    return responseData;
  }

  Future<ResponseBase> executeMultipart(
      {required String path,
      required File file,
      String method = "POST",
      String fieldName = "file",
      Map<String, dynamic>? params,
      Map<String, String>? headers,
      String? key,
      String? otherAuthority}) async {
    final uri = Uri.https(otherAuthority ?? baseUrl ?? "", path);
    ResponseBase responseData = await super.connectionInternetAvailable();

    if (!responseData.isSuccess) {
      return responseData;
    }

    "REQUEST -> MULTIPART $method".log();
    "REQUEST URL -> ${uri.toString()}".log();

    final request = http.MultipartRequest(method, uri);

    params?.forEach((key, value) {
      request.fields[key] = value;
    });

    headers?.forEach((key, value) {
      request.headers[key] = value;
    });

    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();
    request.files.add(http.MultipartFile(
      fieldName,
      fileStream,
      fileLength,
      filename: file.path.split('/').last,
    ));

    await http.Response.fromStream(await request.send()).then((response) {
      "RESPONSE CODE-> ${response.statusCode}".log();
      "RESPONSE BODY-> ${response.body}".log();

      super.validateStatusCode(response.statusCode, responseData);
      if (responseData.isSuccess) {
        super.setBodyJson(response.body, responseData);
      }
    }).onError((dynamic error, stackTrace) {
      super.buildErrorGeneral(responseData);
    }).timeout(Duration(minutes: super.timeOutMinutes), onTimeout: () {
      super.buildTimeOut(responseData);
    }).catchError((onError, stack) {
      super.buildException(responseData);
    });

    return responseData;
  }
}
