class ResponseGeneral<T> {
  T success;
  ErrorGeneral? error;
  ResponseGeneral(this.success, this.error);
}

class ErrorGeneral {
  int? identifier;
  Exception? error;
  ErrorGeneral(this.error, {this.identifier});
}

class SuccessGeneral<T> {
  T success;
  SuccessGeneral(this.success);
}
