class APIResponse {
  int status;
  String json;
  String code;
  APIResponse({required this.status, required this.json, required this.code});

  bool isSuccessful() {
    if (status == -1) {
      return false;
    }
    return (status >= 200 && status < 400);
  }

  @override
  String toString() {
    return 'APIResponse{code: $status, json: $json, message: $code}';
  }
}
