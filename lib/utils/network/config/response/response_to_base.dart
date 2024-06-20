abstract class ResponseToApiD {
  dynamic fromJson(dynamic data);
}



abstract class ResponseToApi<T> {
  T fromJson(dynamic data);
}

abstract class ResponseToApiMap<T> implements ResponseToApi<T> {
  @override
  T fromJson(dynamic map);
}

abstract class ResponseToApiList<T> implements ResponseToApi<T> {
  @override
  T fromJson(dynamic map);
}

class Data implements ResponseToApi<Data> {
  final String data;
  final String dataDos;
  final String dataTres;

  Data({required this.data, required this.dataDos, required this.dataTres});

  @override
  Data fromJson(dynamic data) {
    final json = data as Map<String, dynamic>;
    return Data(
      data: json['data'],
      dataDos: json['dataDos'],
      dataTres: json['dataTres'],
    );
  }
}
