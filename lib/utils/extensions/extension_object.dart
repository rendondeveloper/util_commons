
extension ObjectNull on Object? {

  void letSafe(Function(Object it) invoke) {
    if (this != null) {
      invoke(this!);
    }
  }
}
