import '../constants/app_messages.dart';

class ApiResponseMessage {
  static String fromResponse(dynamic response) {
    if (response == null) {
      return "Something went wrong";
    }

    return AppMessages.getMessage(
      response['code'],
    );
  }
}