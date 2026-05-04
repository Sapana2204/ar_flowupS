class AppUrls {
  // static const baseUrl = "https://flowups-be.onrender.com/api/v1";
  static const baseUrl = "http://192.168.1.23:3000/api/v1";  //local

  /// SOCKET URL (IMPORTANT - no /api/v1)
  static const socketUrl = "http://192.168.1.23:3000";
  static const unreadCount = "$baseUrl/notifications/unread-count";

  //API end points
  static const loginEndPoint = "$baseUrl/login";
  static const ticketsList = "$baseUrl/tickets";
  static const queryTypes = "$baseUrl/system/searchSlugList";
  static const searchList = "$baseUrl/system/searchList";
  static const createTicket = "$baseUrl/tickets/create";
  static const ticketDetailsById = "$baseUrl/tickets/";
  static const updateTicket = "$baseUrl/tickets/";

}