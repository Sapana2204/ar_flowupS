class AppUrls {
  // static const baseUrl = "https://flowups-be.onrender.com/api/v1";
  static const baseUrl = "https://api.calldesk.flowups.in/api/v1";  //local
  // static const baseUrl = "http://192.168.1.5:3000/api/v1";  //local

  /// SOCKET URL (IMPORTANT - no /api/v1)
  static const socketUrl = "https://api.calldesk.flowups.in";
  // static const socketUrl = "http://192.168.1.23";
  static const unreadCount = "$baseUrl/notifications/unread-count";
  static const userStatus = "$baseUrl/users/status";

  //API end points
  static const loginEndPoint = "$baseUrl/login";
  static const dashboardApi = "$baseUrl/dashboard";
  static const ticketsList = "$baseUrl/tickets";
  static const queryTypes = "$baseUrl/system/searchSlugList";
  static const searchList = "$baseUrl/system/searchList";
  static const searchAssignee =
      "$baseUrl/system/searchAssignee";

  static const createTicket = "$baseUrl/tickets/create";
  static const ticketDetailsById = "$baseUrl/tickets/";
  static const updateTicket = "$baseUrl/tickets/";
  
  static const customersList = "$baseUrl/customers";
  static const createCustomer = "$baseUrl/customers/create";
  static const customerById = "$baseUrl/customers/";
  static const updateCustomer = "$baseUrl/customers/";

  static const String commentsList = "$baseUrl/comments";
  static const String createComment = "$baseUrl/comments/create";

  static const String ticketHistory =
      "/tickets/history";

  static const String profile =
      "/users/profile";

  static const String ticketWorkLogs =
      "$baseUrl/tickets/work-logs";
  static const String createWorkLog =
      "$baseUrl/tickets/work-logs/create";
  static const String updateWorkLog =
      "$baseUrl/tickets/work-logs/update";

  static const workReport = "$baseUrl/reports/work-report";
  static const userPerformanceReport =
      "$baseUrl/reports/user-performance";
  static const String productExpiryReport =
      "$baseUrl/reports/product-expiry";

  static const amcReminders = "$baseUrl/amc-reminders";
  static const String sendAMCReminder =
      "$baseUrl/amc-reminders/send";
  static const String scheduleAMCVisit =
      "$baseUrl/amc-reminders/visit";
  static const String amcActivity =
      "$baseUrl/amc-reminders/activity";

  static const customerTicketReport =
      "$baseUrl/reports/customer";

  static const String ticketVisits =
      "$baseUrl/tickets/visits";

  static const String createVisit =
      "$baseUrl/tickets/visits/create";

}