class Ticketsmodel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  Pagination? pagination;

  Ticketsmodel(
      {this.success,
        this.code,
        this.type,
        this.message,
        this.data,
        this.pagination});

  Ticketsmodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Data {
  int? ticketId;
  String? clientId;
  String? contactPerson;
  String? contactNo;
  String? queryType;
  Null? reason;
  String? description;
  String? assignee;
  String? startDate;
  String? dueDate;
  String? ticketStatus;
  String? ticketPriority;
  Null? companyId;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  String? status;
  String? ticketNo;
  String? statusColor;
  Null? typeColor;

  Data(
      {this.ticketId,
        this.clientId,
        this.contactPerson,
        this.contactNo,
        this.queryType,
        this.reason,
        this.description,
        this.assignee,
        this.startDate,
        this.dueDate,
        this.ticketStatus,
        this.ticketPriority,
        this.companyId,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.status,
        this.ticketNo,
        this.statusColor,
        this.typeColor});

  Data.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    clientId = json['client_id'];
    contactPerson = json['contact_person'];
    contactNo = json['contact_no'];
    queryType = json['query_type'];
    reason = json['reason'];
    description = json['description'];
    assignee = json['assignee'];
    startDate = json['start_date'];
    dueDate = json['due_date'];
    ticketStatus = json['ticket_status'];
    ticketPriority = json['ticket_priority'];
    companyId = json['company_id'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    modifiedBy = json['modified_by'];
    modifiedDate = json['modified_date'];
    status = json['status'];
    ticketNo = json['ticket_no'];
    statusColor = json['status_color'];
    typeColor = json['type_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['client_id'] = this.clientId;
    data['contact_person'] = this.contactPerson;
    data['contact_no'] = this.contactNo;
    data['query_type'] = this.queryType;
    data['reason'] = this.reason;
    data['description'] = this.description;
    data['assignee'] = this.assignee;
    data['start_date'] = this.startDate;
    data['due_date'] = this.dueDate;
    data['ticket_status'] = this.ticketStatus;
    data['ticket_priority'] = this.ticketPriority;
    data['company_id'] = this.companyId;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['modified_by'] = this.modifiedBy;
    data['modified_date'] = this.modifiedDate;
    data['status'] = this.status;
    data['ticket_no'] = this.ticketNo;
    data['status_color'] = this.statusColor;
    data['type_color'] = this.typeColor;
    return data;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  int? start;
  int? end;

  Pagination(
      {this.total,
        this.page,
        this.limit,
        this.totalPages,
        this.start,
        this.end});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['totalPages'] = this.totalPages;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
