sealed class ApiResponseError {}

class FormatWrongJson extends ApiResponseError {}

class IntertnetNotAvailable extends ApiResponseError {}

class TimeoutError extends ApiResponseError {}

class ErrorServerError extends ApiResponseError {}
