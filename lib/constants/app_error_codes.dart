class AppErrorCodes {
  // Success
  static const int success = 1000;
  static const int created = 1001;
  static const int updated = 1002;
  static const int deleted = 1003;
  static const int fetched = 1004;
  static const int loginSuccess = 1005;
  static const int logoutSuccess = 1006;

  // Failures
  static const int failed = 2000;
  static const int validationFailed = 2001;
  static const int emailExists = 2002;
  static const int usernameExists = 2003;
  static const int recordNotFound = 2004;
  static const int unauthorized = 2005;
  static const int tokenExpired = 2006;
  static const int permissionDenied = 2007;
  static const int somethingWentWrong = 2008;
  static const int tooManyRequests = 2029;
}