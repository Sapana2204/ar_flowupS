class AppMessages {
  static const Map<int, String> successMessages = {
    1000: "Success",
    1001: "Created successfully",
    1002: "Updated successfully",
    1003: "Deleted successfully",
    1004: "Fetched successfully",
    1005: "Login successful",
    1006: "Logout successful",
  };

  static const Map<int, String> failureMessages = {
    2000: "Failed",
    2001: "Validation failed",
    2002: "Email already exists",
    2003: "Username already exists",
    2004: "Record not found",
    2005: "Unauthorized access",
    2006: "Token expired",
    2007: "Permission denied",
    2008: "Something went wrong",
    2029: "Too many requests. Please try again later.",
  };

  static String getMessage(int? code) {
    if (code == null) return "Unknown error";

    return successMessages[code] ??
        failureMessages[code] ??
        "Unknown error";
  }
}