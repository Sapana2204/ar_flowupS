class TicketHistoryModel {
  final int? historyId;
  final int? ticketId;
  final String? actionType;
  final String? fieldName;
  final String? oldValue;
  final String? newValue;
  final String? createdDate;
  final String? changedByName;
  final String? comment;
  final String? oldLabel;
  final String? newLabel;

  TicketHistoryModel({
    this.historyId,
    this.ticketId,
    this.actionType,
    this.fieldName,
    this.oldValue,
    this.newValue,
    this.createdDate,
    this.changedByName,
    this.comment,
    this.oldLabel,
    this.newLabel,
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
      changedByName: json["changed_by_name"],
      comment: json["comment"],
      oldLabel: json["old_label"],
      newLabel: json["new_label"],
    );
  }
}

String getLabelText(String? field) {
  switch (field) {
    case "ticket_status":
      return "Status";
    case "ticket_priority":
      return "Priority";
    case "due_date":
      return "Due Date";
    case "description":
      return "Description";
    default:
      return field ?? "";
  }
}

String getHistoryMessage(TicketHistoryModel item) {
  if (item.actionType == "created") {
    return item.comment ?? "New ticket created.";
  }

  if (item.actionType == "reassigned") {
    return "Ticket assigned to ${item.newLabel ?? item.newValue ?? ''}";
  }

  if (item.actionType == "updated") {
    return "${getLabelText(item.fieldName)} changed from "
        "${item.oldLabel ?? item.oldValue ?? ''} "
        "to "
        "${item.newLabel ?? item.newValue ?? ''}";
  }

  return item.comment ?? "Updated";
}