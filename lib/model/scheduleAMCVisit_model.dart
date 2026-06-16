class ScheduleAMCVisitRequest {
  final int customerId;
  final int clientId;
  final String contactPerson;
  final String contactNo;
  final String description;
  final String visitDetails;
  final String visitScheduledAt;
  final String? queryType;
  final String ticketStatus;
  final String? ticketPriority;
  final String assignee;
  final String employeeId;
  final String startDate;
  final String dueDate;
  final String status;
  final String createdBy;

  ScheduleAMCVisitRequest({
    required this.customerId,
    required this.clientId,
    required this.contactPerson,
    required this.contactNo,
    required this.description,
    required this.visitDetails,
    required this.visitScheduledAt,
    this.queryType,
    required this.ticketStatus,
    this.ticketPriority,
    required this.assignee,
    required this.employeeId,
    required this.startDate,
    required this.dueDate,
    required this.status,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      "customer_id": customerId,
      "client_id": clientId,
      "contact_person": contactPerson,
      "contact_no": contactNo,
      "description": description,
      "visit_details": visitDetails,
      "visit_scheduled_at": visitScheduledAt,
      "query_type": queryType,
      "ticket_status": ticketStatus,
      "ticket_priority": ticketPriority,
      "assignee": assignee,
      "employee_id": employeeId,
      "start_date": startDate,
      "due_date": dueDate,
      "status": status,
      "created_by": createdBy,
    };
  }
}