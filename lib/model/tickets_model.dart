class Ticketsmodel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<Data>? data;
  Pagination? pagination;

  Ticketsmodel({
    this.success,
    this.code,
    this.type,
    this.message,
    this.data,
    this.pagination,
  });

  Ticketsmodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];

    if (json['data'] != null) {
      data = [];

      if (json['data'] is List) {
        // ✅ List API (ticket list)
        for (var v in json['data']) {
          data!.add(Data.fromJson(v));
        }
      } else if (json['data'] is Map) {
        // ✅ Single object API (ticket by ID)
        data!.add(Data.fromJson(json['data']));
      }
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['success'] = success;
    dataMap['code'] = code;
    dataMap['type'] = type;
    dataMap['message'] = message;

    if (data != null) {
      dataMap['data'] = data!.map((v) => v.toJson()).toList();
    }

    if (pagination != null) {
      dataMap['pagination'] = pagination!.toJson();
    }

    return dataMap;
  }
}

class Data {
  int? ticketId;
  String? clientId;
  String? contactPerson;
  String? contactNo;
  String? queryType;
  String? reason;
  String? description;
  String? assignee;
  String? startDate;
  String? dueDate;
  String? ticketStatus;
  String? ticketPriority;
  dynamic companyId;
  String? createdBy;
  String? createdDate;
  String? modifiedBy;
  String? modifiedDate;
  String? status;
  String? ticketNo;
  String? statusColor;
  String? priorityColor;
  String? typeColor;
  String? productId;
  String? productName;
  String? productSerialNumber;
  String? productAddOns;
  String? expectedMinutes;
  String? activeAmc;
  String? feedbackToken;
  String? feedbackSubmitted;
  String? callDirection;
  String? amcCall;
  String? visitRequired;

  Data({
    this.ticketId,
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
    this.priorityColor,
    this.typeColor,
    this.productId,
    this.productName,
    this.productSerialNumber,
    this.productAddOns,
    this.expectedMinutes,
    this.activeAmc,
    this.feedbackToken,
    this.feedbackSubmitted,
    this.callDirection,
    this.amcCall,
    this.visitRequired,
  });

  Data.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    clientId = json['client_id']?.toString();
    contactPerson = json['contact_person']?.toString();
    contactNo = json['contact_no']?.toString();
    queryType = json['query_type']?.toString();
    reason = json['reason']?.toString();
    description = json['description']?.toString();
    assignee = json['assignee']?.toString();
    startDate = json['start_date']?.toString();
    dueDate = json['due_date']?.toString();
    ticketStatus = json['ticket_status']?.toString();
    ticketPriority = json['ticket_priority']?.toString();
    companyId = json['company_id'];
    createdBy = json['created_by']?.toString();
    createdDate = json['created_date']?.toString();
    modifiedBy = json['modified_by']?.toString();
    modifiedDate = json['modified_date']?.toString();
    status = json['status']?.toString();
    ticketNo = json['ticket_no']?.toString();
    statusColor = json['status_color']?.toString();
    priorityColor = json['priority_color']?.toString();
    typeColor = json['type_color']?.toString();
    productId = json['product_id']?.toString();
    productName = json['product_name']?.toString();
    productSerialNumber =
        json['product_serial_number']?.toString();
    productAddOns =
        json['product_add_ons']?.toString();
    expectedMinutes = json['expected_minutes']?.toString();
    activeAmc = json['active_amc']?.toString();
    feedbackToken = json['feedback_token']?.toString();
    feedbackSubmitted = json['feedback_submitted']?.toString();
    callDirection = json['call_direction']?.toString();
    amcCall = json['amc_call']?.toString();
    visitRequired = json['visit_required']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['ticket_id'] = ticketId;
    dataMap['client_id'] = clientId;
    dataMap['contact_person'] = contactPerson;
    dataMap['contact_no'] = contactNo;
    dataMap['query_type'] = queryType;
    dataMap['reason'] = reason;
    dataMap['description'] = description;
    dataMap['assignee'] = assignee;
    dataMap['start_date'] = startDate;
    dataMap['due_date'] = dueDate;
    dataMap['ticket_status'] = ticketStatus;
    dataMap['ticket_priority'] = ticketPriority;
    dataMap['company_id'] = companyId;
    dataMap['created_by'] = createdBy;
    dataMap['created_date'] = createdDate;
    dataMap['modified_by'] = modifiedBy;
    dataMap['modified_date'] = modifiedDate;
    dataMap['status'] = status;
    dataMap['ticket_no'] = ticketNo;
    dataMap['status_color'] = statusColor;
    dataMap['priority_color'] = priorityColor;
    dataMap['type_color'] = typeColor;
    dataMap['product_id'] = productId;
    dataMap['product_name'] = productName;
    dataMap['product_serial_number'] =
        productSerialNumber;
    dataMap['product_add_ons'] = productAddOns;
    dataMap['expected_minutes'] = expectedMinutes;
    dataMap['active_amc'] = activeAmc;
    dataMap['feedback_token'] = feedbackToken;
    dataMap['feedback_submitted'] = feedbackSubmitted;
    dataMap['call_direction'] = callDirection;
    dataMap['amc_call'] = amcCall;
    dataMap['visit_required'] = visitRequired;
    return dataMap;
  }
}

class Pagination {
  int? total;
  int? page;
  int? limit;
  int? totalPages;
  int? start;
  int? end;

  Pagination({
    this.total,
    this.page,
    this.limit,
    this.totalPages,
    this.start,
    this.end,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataMap = {};

    dataMap['total'] = total;
    dataMap['page'] = page;
    dataMap['limit'] = limit;
    dataMap['totalPages'] = totalPages;
    dataMap['start'] = start;
    dataMap['end'] = end;

    return dataMap;
  }
}