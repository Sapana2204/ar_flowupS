import 'customerContact_model.dart';

class CreateTicket {
  int? ticketId;
  int? clientId;
  String? contactNo;
  bool? saveContact;
  CustomerContact? contactDetails;
  String? description;
  String? queryType;
  String? queryTypeName;
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
  String? visitRequired;

  CreateTicket({
    this.ticketId,
    this.clientId,
    this.contactNo,
    this.saveContact,
    this.contactDetails,
    this.description,
    this.queryType,
    this.queryTypeName,
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
    this.expectedMinutes,
    this.visitRequired,
  });

  Map<String, dynamic> toJson() {
    return {
      "ticket_id": ticketId,
      "client_id": clientId,
      "contact_no": contactNo,
      "save_contact": saveContact,
      "contact_details": saveContact == true
          ? contactDetails?.toJson()
          : null,
      "description": description,
      "query_type": queryType,
      "query_type_name": queryTypeName,
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
      "visit_required": visitRequired,
    };
  }
}