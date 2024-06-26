import 'package:flutter/foundation.dart';

extension CustomString on String {
  bool toBool() => this == "1";

  void log() {
    if (kDebugMode) {
      print("LOG -> $this");
    }
  }

  String toFormat(String text) {
    return replaceAll("%", text);
  }
}

extension CustomStringNull on String? {
  bool isNumber() {
    return this != null ? double.tryParse(this!) != null : false;
  }

  int toInt() {
    return this != null ? int.tryParse(this!) ?? -1 : -1;
  }

  String getDataIfNotNull() {
    return this == null ? "" : this!;
  }

  void run(Function(String) invoke) {
    if (this != null) {
      invoke(this!);
    }
  }

  void let(Function(String it) invoke) {
    if (this != null) {
      invoke(this!);
    }
  }
}
