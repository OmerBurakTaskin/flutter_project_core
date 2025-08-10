class ApiResponse<T> {
  final T? data;
  final String? error;

  ApiResponse._({this.data, this.error});

  factory ApiResponse.failure(String error) {
    return ApiResponse._(error: error);
  }

  factory ApiResponse.success(T data) {
    return ApiResponse._(data: data);
  }

  R? when<R>(
      {required R? Function(T data) onSuccess,
      required R? Function(String error) onError}) {
    if (data != null) {
      return onSuccess(data as T);
    } else {
      return onError(error ?? "Unknown error occured");
    }
  }
}
