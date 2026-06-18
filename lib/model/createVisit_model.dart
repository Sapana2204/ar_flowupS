class CreateVisitModel {
  int? ticketId;
  int? employeeId;
  String? visitScheduledAt;
  String? visitDetails;

  CreateVisitModel({
    this.ticketId,
    this.employeeId,
    this.visitScheduledAt,
    this.visitDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "ticket_id": ticketId,
      "employee_id": employeeId,
      "visit_scheduled_at": visitScheduledAt,
      "visit_details": visitDetails,
    };
  }
}