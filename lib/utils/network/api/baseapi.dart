import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:io';

import 'package:util_commons/utils/network/config/response/response.dart';

class BaseApi {
  final int timeOutMinutes = 1;
  final String typeService = "TIPO";
  final String jsonType = 'Content-Type';
  final String jsonConfiguration = 'application/json; charset=UTF-8';

  Future<ResponseBase> connectionInternetAvailable() async {
    if (await _getConnection()) {
      log("REQUEST AVAILABLE INTERNET-> true");
      return ResponseBase(isSuccess: true);
    } else {
      log("REQUEST AVAILABLE INTERNET-> false");
      return ResponseBase(
          isSuccess: false, message: "", exception: Exception(""));
    }
  }

  void validateStatusCode(int statusCode, ResponseBase response) {
    switch (statusCode) {
      case 200:
        response.isSuccess = true;
        break;
      default:
        response.isSuccess = false;
        response.exception = Exception(
            "($statusCode) - Ocurrio un error al realizar la operación, intentelo nuevamente.");
    }
  }

  void buildErrorGeneral(ResponseBase response) {
    response.exception = Exception(
        "El tiempo para la solictud fue muy largo, intentalo nuevamente");
  }

  void buildTimeOut(ResponseBase response) {
    response.exception = Exception(
        "El tiempo para la solictud fue muy largo, intentalo nuevamente");
  }

  void buildException(ResponseBase response) {
    response.exception = Exception(
        "Ocurrio un error al intentar conectar con nuestros servidores, intentalo nuevamente");
  }

  void setBodyJson(String bodyResponse, ResponseBase response) {
    if (bodyResponse.isEmpty) {
      return;
    }

    if (_isMapJson(bodyResponse)) {
      response.setMapValueJson(
          convert.jsonDecode(bodyResponse) as Map<String, dynamic>?);
    } else if (_isListJson(bodyResponse)) {
      response
          .setListValueJson(convert.jsonDecode(bodyResponse) as List<dynamic>?);
    } else {
      response.loadData(
          isSuccess: false,
          message: "El formato de la respuesta no puede ser procesado.");
      response.exception =
          Exception("El formato de la respuesta no puede ser procesado.");
    }
  }

  bool _isMapJson(String json) {
    try {
      convert.jsonDecode(json) as Map<String, dynamic>?;
      log("RESPONSE JSON IS MAP");
      return true;
    } catch (_) {
      return false;
    }
  }

  bool _isListJson(String json) {
    try {
      convert.jsonDecode(json) as List<dynamic>?;
      log("RESPONSE JSON IS LIST");
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _getConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  bool isValidJson(String json) {
    try {
      convert.jsonDecode(json);
      return true;
    } catch (e) {
      return false;
    }
  }
}
