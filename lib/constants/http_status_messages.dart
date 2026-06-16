class HttpStatusMessages {
  static const Map<int, String> messages = {
    200: "OK",
    201: "Created",
    204: "No Content",
    400: "Bad Request",
    401: "Unauthorized",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    409: "Conflict",
    422: "Unprocessable Entity",
    500: "Internal Server Error",
    503: "Service Unavailable",
  };

  static String getMessage(int statusCode) {
    return messages[statusCode] ?? "Unknown Status";
  }
}