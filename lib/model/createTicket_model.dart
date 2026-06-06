class CreateTicket {
  int? ticketId;
  int? clientId;
  String? contactNo;
  String? description;
  String? queryType;
  String? ticketStatus;
  String? ticketPriority;
  String? assignee;
  String? startDate;
  String? dueDate;
  int? companyId;
  int? createdBy;
  int? modifiedBy;
  String? status;
  String? contactPerson;
  String? productId;
  String? productName;
  String? productSerialNumber;
  String? productAddOns;
  String? expectedMinutes;

  CreateTicket({
    this.ticketId,
    this.clientId,
    this.contactNo,
    this.description,
    this.queryType,
    this.ticketStatus,
    this.ticketPriority,
    this.assignee,
    this.startDate,
    this.dueDate,
    this.companyId,
    this.createdBy,
    this.modifiedBy,
    this.status,
    this.contactPerson,
    this.productId,
    this.productName,
    this.productSerialNumber,
    this.productAddOns,
    this.expectedMinutes
  });

  Map<String, dynamic> toJson() {
    return {
      "ticket_id": ticketId,
      "client_id": clientId,
      "contact_no": contactNo,
      "description": description,
      "query_type": queryType,
      "ticket_status": ticketStatus,
      "ticket_priority": ticketPriority,
      "assignee": assignee,
      "start_date": startDate,
      "due_date": dueDate,
      "company_id": companyId,
      "created_by": createdBy,
      "modified_by": modifiedBy,
      "status": status,
      "contact_person": contactPerson,
      "product_id": productId,
      "product_name": productName,
      "product_serial_number": productSerialNumber,
      "product_add_ons": productAddOns ?? "[]",
      "expected_minutes": expectedMinutes,
    };
  }
}