import 'package:flutter/material.dart';
import 'package:util_commons/utils/commons/device_type.dart';

extension CustomContext on BuildContext {

  ThemeData get getThemeData => Theme.of(this);

  MediaQueryData get getMediaQuery => MediaQuery.of(this);

  DeviceType get getDeviceType {
    final data = getMediaQuery.size.shortestSide;
    return data < 550 ? DeviceType.phone : DeviceType.tablet;
  }
}
