class TicketHistoryModel {
  final int? historyId;
  final int? ticketId;
  final String? actionType;
  final String? fieldName;
  final String? oldValue;
  final String? newValue;
  final String? createdDate;
  final String? userName;
  final String? comment;

  TicketHistoryModel({
    this.historyId,
    this.ticketId,
    this.actionType,
    this.fieldName,
    this.oldValue,
    this.newValue,
    this.createdDate,
    this.userName,
    this.comment,

  });

  factory TicketHistoryModel.fromJson(Map<String, dynamic> json) {
    return TicketHistoryModel(
      historyId: json["history_id"],
      ticketId: json["ticket_id"],
      actionType: json["action_type"],
      fieldName: json["field_name"],
      oldValue: json["old_value"]?.toString(),
      newValue: json["new_value"]?.toString(),
      createdDate: json["created_date"],
      userName: json["user_name"],
      comment: json["comment"],
    );
  }
}