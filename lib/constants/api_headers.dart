class ApiHeaders {
  static Map<String, String> headers({
    String? token,
  }) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json, text/plain, */*",
      "isMobile": "true",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
    };
  }

  static Map<String, String> multipartHeaders({
    String? token,
  }) {
    return {
      "isMobile": "true",
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
    };
  }
}