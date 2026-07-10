import 'customerContact_model.dart';

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
  String? clientName;
  String? delegationFlag;
  String? isDelegated;
  String? isReassigned;
  String? visibilityReason;
  int? customerId;
  String? name;
  String? email;
  String? mobileNo;
  String? waNo;
  String? panNumber;
  String? gstNumber;
  String? companyName;
  String? address;
  String? isAmc;
  String? amcTermPeriod;
  String? amcStartDate;
  String? amcEndDate;
  String? expCallCount;
  String? responsiblePerson;

  List<CustomerContact>? customerContacts;
  List<CustomerContact>? contactPersons;

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
    this.clientName,
    this.delegationFlag,
    this.isDelegated,
    this.isReassigned,
    this.visibilityReason,
    this.customerId,
    this.name,
    this.email,
    this.mobileNo,
    this.waNo,
    this.panNumber,
    this.gstNumber,
    this.companyName,
    this.address,
    this.isAmc,
    this.amcTermPeriod,
    this.amcStartDate,
    this.amcEndDate,
    this.expCallCount,
    this.responsiblePerson,
    this.customerContacts,
    this.contactPersons,
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
    clientName = json['client_name']?.toString();
    delegationFlag = json['delegation_flag']?.toString();
    isDelegated = json['is_delegated']?.toString();
    isReassigned = json['is_reassigned']?.toString();
    visibilityReason = json['visibility_reason']?.toString();
    customerId = json['customer_id'];
    name = json['name']?.toString();
    email = json['email']?.toString();
    mobileNo = json['mobile_no']?.toString();
    waNo = json['wa_no']?.toString();
    panNumber = json['pan_number']?.toString();
    gstNumber = json['gst_number']?.toString();
    companyName = json['company_name']?.toString();
    address = json['address']?.toString();
    isAmc = json['is_amc']?.toString();
    amcTermPeriod = json['amc_term_period']?.toString();
    amcStartDate = json['amc_start_date']?.toString();
    amcEndDate = json['amc_end_date']?.toString();
    expCallCount = json['exp_call_count']?.toString();
    responsiblePerson = json['responsible_person']?.toString();

    if (json['customer_contacts'] != null) {
      customerContacts = (json['customer_contacts'] as List)
          .map((e) => CustomerContact.fromJson(e))
          .toList();
    }

    if (json['contact_persons'] != null) {
      contactPersons = (json['contact_persons'] as List)
          .map((e) => CustomerContact.fromJson(e))
          .toList();
    }
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
    dataMap['client_name'] = clientName;
    dataMap['delegation_flag'] = delegationFlag;
    dataMap['is_delegated'] = isDelegated;
    dataMap['is_reassigned'] = isReassigned;
    dataMap['visibility_reason'] = visibilityReason;
    dataMap['customer_id'] = customerId;
    dataMap['name'] = name;
    dataMap['email'] = email;
    dataMap['mobile_no'] = mobileNo;
    dataMap['wa_no'] = waNo;
    dataMap['pan_number'] = panNumber;
    dataMap['gst_number'] = gstNumber;
    dataMap['company_name'] = companyName;
    dataMap['address'] = address;
    dataMap['is_amc'] = isAmc;
    dataMap['amc_term_period'] = amcTermPeriod;
    dataMap['amc_start_date'] = amcStartDate;
    dataMap['amc_end_date'] = amcEndDate;
    dataMap['exp_call_count'] = expCallCount;
    dataMap['responsible_person'] = responsiblePerson;

    if (customerContacts != null) {
      dataMap['customer_contacts'] =
          customerContacts!.map((e) => e.toJson()).toList();
    }

    if (contactPersons != null) {
      dataMap['contact_persons'] =
          contactPersons!.map((e) => e.toJson()).toList();
    }
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
    total = int.tryParse(json['total']?.toString() ?? '');
    page = int.tryParse(json['page']?.toString() ?? '');
    limit = int.tryParse(json['limit']?.toString() ?? ''); // ✅ FIXED
    totalPages = int.tryParse(json['totalPages']?.toString() ?? '');
    start = int.tryParse(json['start']?.toString() ?? '');
    end = int.tryParse(json['end']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
      'start': start,
      'end': end,
    };
  }
}