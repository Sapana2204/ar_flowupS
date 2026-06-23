import '../constants/app_messages.dart';

class ApiResponseMessage {
  static String fromResponse(dynamic response) {
    if (response == null) {
      return "Something went wrong";
    }

    // 👇 Prefer backend message first
    if (response["message"] != null &&
        response["message"].toString().trim().isNotEmpty) {
      return response["message"].toString();
    }

    return AppMessages.getMessage(response['code']);
  }
}