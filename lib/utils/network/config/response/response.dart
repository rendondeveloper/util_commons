class ResponseBase {
  final String jsonEmpty = "[]";
  String? message;
  bool isSuccess = false;
  Map<String, dynamic>? _mapValueJson;
  List<dynamic>? _listValueJson;
  bool? recoveryMap;
  Exception? exception;

  ResponseBase({this.isSuccess = false, this.message, this.exception});

  loadData({bool isSuccess = false, String? message}) {
    this.message = message;
    this.isSuccess = isSuccess;
  }

  Map<String, dynamic>? get mapValueJson => _mapValueJson;
  setMapValueJson(Map<String, dynamic>? map) {
    recoveryMap = true;
    _mapValueJson = map;
  }

  List<dynamic>? get listValueJson => _listValueJson;
  setListValueJson(List<dynamic>? list) {
    recoveryMap = false;
    _listValueJson = list;
  }

  ResponseBase.fromJson(Map<String, dynamic> json) {
    isSuccess = json["SUCCESS"].toString() == "1";
    message = json["MENSAJE"].toString();
  }
}
