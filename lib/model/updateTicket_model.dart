class UpdateTicketModel {
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
  Null? companyId;
  int? createdBy;
  Null? modifiedBy;
  String? status;
  String? contactPerson;
  String? reason;
  String? createdDate;
  String? modifiedDate;
  String? ticketNo;

  UpdateTicketModel(
      {this.ticketId,
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
        this.reason,
        this.createdDate,
        this.modifiedDate,
        this.ticketNo});

  UpdateTicketModel.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    clientId = json['client_id'];
    contactNo = json['contact_no'];
    description = json['description'];
    queryType = json['query_type'];
    ticketStatus = json['ticket_status'];
    ticketPriority = json['ticket_priority'];
    assignee = json['assignee'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    status = json['status'];
    contactPerson = json['contact_person'];
    reason = json['reason'];
    createdDate = json['created_date'];
    modifiedDate = json['modified_date'];
    ticketNo = json['ticket_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['client_id'] = this.clientId;
    data['contact_no'] = this.contactNo;
    data['description'] = this.description;
    data['query_type'] = this.queryType;
    data['ticket_status'] = this.ticketStatus;
    data['ticket_priority'] = this.ticketPriority;
    data['assignee'] = this.assignee;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['company_id'] = this.companyId;
    data['created_by'] = this.createdBy;
    data['modified_by'] = this.modifiedBy;
    data['status'] = this.status;
    data['contact_person'] = this.contactPerson;
    data['reason'] = this.reason;
    data['created_date'] = this.createdDate;
    data['modified_date'] = this.modifiedDate;
    data['ticket_no'] = this.ticketNo;
    return data;
  }
}
