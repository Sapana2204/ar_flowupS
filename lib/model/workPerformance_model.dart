class WorkPerformanceModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  Data? data;

  WorkPerformanceModel(
      {this.success, this.code, this.type, this.message, this.data});

  WorkPerformanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['type'] = this.type;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  Summary? summary;
  Charts? charts;
  List<Tickets>? tickets;
  List<Activities>? activities;
  Pagination? pagination;

  Data(
      {this.user,
        this.summary,
        this.charts,
        this.tickets,
        this.activities,
        this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    summary =
    json['summary'] != null ? new Summary.fromJson(json['summary']) : null;
    charts =
    json['charts'] != null ? new Charts.fromJson(json['charts']) : null;
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(new Tickets.fromJson(v));
      });
    }
    if (json['activities'] != null) {
      activities = <Activities>[];
      json['activities'].forEach((v) {
        activities!.add(new Activities.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.summary != null) {
      data['summary'] = this.summary!.toJson();
    }
    if (this.charts != null) {
      data['charts'] = this.charts!.toJson();
    }
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    if (this.activities != null) {
      data['activities'] = this.activities!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class User {
  int? adminID;
  String? name;
  String? email;
  String? userName;
  int? roleID;

  User({this.adminID, this.name, this.email, this.userName, this.roleID});

  User.fromJson(Map<String, dynamic> json) {
    adminID = json['adminID'];
    name = json['name'];
    email = json['email'];
    userName = json['userName'];
    roleID = json['roleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminID'] = this.adminID;
    data['name'] = this.name;
    data['email'] = this.email;
    data['userName'] = this.userName;
    data['roleID'] = this.roleID;
    return data;
  }
}

class Summary {
  int? assigned;
  int? closed;
  int? pending;
  int? delegated;
  int? overdue;
  int? avgResolutionTime;
  int? productivityScore;

  Summary(
      {this.assigned,
        this.closed,
        this.pending,
        this.delegated,
        this.overdue,
        this.avgResolutionTime,
        this.productivityScore});

  Summary.fromJson(Map<String, dynamic> json) {
    assigned = json['assigned'];
    closed = json['closed'];
    pending = json['pending'];
    delegated = json['delegated'];
    overdue = json['overdue'];
    avgResolutionTime = json['avg_resolution_time'];
    productivityScore = json['productivity_score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['assigned'] = this.assigned;
    data['closed'] = this.closed;
    data['pending'] = this.pending;
    data['delegated'] = this.delegated;
    data['overdue'] = this.overdue;
    data['avg_resolution_time'] = this.avgResolutionTime;
    data['productivity_score'] = this.productivityScore;
    return data;
  }
}

class Charts {
  List<MonthlyProductivity>? monthlyProductivity;
  List<TicketStatusDistribution>? ticketStatusDistribution;
  List<DailyClosureTrend>? dailyClosureTrend;
  PendingVsClosed? pendingVsClosed;

  Charts(
      {this.monthlyProductivity,
        this.ticketStatusDistribution,
        this.dailyClosureTrend,
        this.pendingVsClosed});

  Charts.fromJson(Map<String, dynamic> json) {
    if (json['monthlyProductivity'] != null) {
      monthlyProductivity = <MonthlyProductivity>[];
      json['monthlyProductivity'].forEach((v) {
        monthlyProductivity!.add(new MonthlyProductivity.fromJson(v));
      });
    }
    if (json['ticketStatusDistribution'] != null) {
      ticketStatusDistribution = <TicketStatusDistribution>[];
      json['ticketStatusDistribution'].forEach((v) {
        ticketStatusDistribution!.add(new TicketStatusDistribution.fromJson(v));
      });
    }
    if (json['dailyClosureTrend'] != null) {
      dailyClosureTrend = <DailyClosureTrend>[];
      json['dailyClosureTrend'].forEach((v) {
        dailyClosureTrend!.add(new DailyClosureTrend.fromJson(v));
      });
    }
    pendingVsClosed = json['pendingVsClosed'] != null
        ? new PendingVsClosed.fromJson(json['pendingVsClosed'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.monthlyProductivity != null) {
      data['monthlyProductivity'] =
          this.monthlyProductivity!.map((v) => v.toJson()).toList();
    }
    if (this.ticketStatusDistribution != null) {
      data['ticketStatusDistribution'] =
          this.ticketStatusDistribution!.map((v) => v.toJson()).toList();
    }
    if (this.dailyClosureTrend != null) {
      data['dailyClosureTrend'] =
          this.dailyClosureTrend!.map((v) => v.toJson()).toList();
    }
    if (this.pendingVsClosed != null) {
      data['pendingVsClosed'] = this.pendingVsClosed!.toJson();
    }
    return data;
  }
}

class MonthlyProductivity {
  String? label;
  int? total;
  String? closed;
  String? value;

  MonthlyProductivity({this.label, this.total, this.closed, this.value});

  MonthlyProductivity.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    total = json['total'];
    closed = json['closed'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['total'] = this.total;
    data['closed'] = this.closed;
    data['value'] = this.value;
    return data;
  }
}

class TicketStatusDistribution {
  String? label;
  int? value;
  String? color;

  TicketStatusDistribution({this.label, this.value, this.color});

  TicketStatusDistribution.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    data['color'] = this.color;
    return data;
  }
}

class DailyClosureTrend {
  String? label;
  int? value;

  DailyClosureTrend({this.label, this.value});

  DailyClosureTrend.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['value'] = this.value;
    return data;
  }
}

class PendingVsClosed {
  int? pending;
  int? closed;

  PendingVsClosed({this.pending, this.closed});

  PendingVsClosed.fromJson(Map<String, dynamic> json) {
    pending = json['pending'];
    closed = json['closed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['closed'] = this.closed;
    return data;
  }
}

class Tickets {
  int? ticketId;
  String? ticketNo;
  String? createdDate;
  String? assignedDate;
  String? dueDate;
  String? contactPerson;
  String? contactNo;
  String? customerName;
  String? ticketPriority;
  String? ticketStatus;
  String? queryType;
  String? assigneeName;
  String? resolutionTime;

  Tickets(
      {this.ticketId,
        this.ticketNo,
        this.createdDate,
        this.assignedDate,
        this.dueDate,
        this.contactPerson,
        this.contactNo,
        this.customerName,
        this.ticketPriority,
        this.ticketStatus,
        this.queryType,
        this.assigneeName,
        this.resolutionTime});

  Tickets.fromJson(Map<String, dynamic> json) {
    ticketId = json['ticket_id'];
    ticketNo = json['ticket_no'];
    createdDate = json['created_date'];
    assignedDate = json['assigned_date'];
    dueDate = json['due_date'];
    contactPerson = json['contact_person'];
    contactNo = json['contact_no'];
    customerName = json['customer_name'];
    ticketPriority = json['ticket_priority'];
    ticketStatus = json['ticket_status'];
    queryType = json['query_type'];
    assigneeName = json['assignee_name'];
    resolutionTime = json['resolution_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ticket_id'] = this.ticketId;
    data['ticket_no'] = this.ticketNo;
    data['created_date'] = this.createdDate;
    data['assigned_date'] = this.assignedDate;
    data['due_date'] = this.dueDate;
    data['contact_person'] = this.contactPerson;
    data['contact_no'] = this.contactNo;
    data['customer_name'] = this.customerName;
    data['ticket_priority'] = this.ticketPriority;
    data['ticket_status'] = this.ticketStatus;
    data['query_type'] = this.queryType;
    data['assignee_name'] = this.assigneeName;
    data['resolution_time'] = this.resolutionTime;
    return data;
  }
}

class Activities {
  int? id;
  int? ticketId;
  String? actionType;
  String? fieldName;
  String? createdDate;
  String? createdAt;
  String? changedByName;
  String? ticketNo;
  String? message;

  Activities(
      {this.id,
        this.ticketId,
        this.actionType,
        this.fieldName,
        this.createdDate,
        this.createdAt,
        this.changedByName,
        this.ticketNo,
        this.message});

  Activities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ticketId = json['ticket_id'];
    actionType = json['action_type'];
    fieldName = json['field_name'];
    createdDate = json['created_date'];
    createdAt = json['created_at'];
    changedByName = json['changed_by_name'];
    ticketNo = json['ticket_no'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ticket_id'] = this.ticketId;
    data['action_type'] = this.actionType;
    data['field_name'] = this.fieldName;
    data['created_date'] = this.createdDate;
    data['created_at'] = this.createdAt;
    data['changed_by_name'] = this.changedByName;
    data['ticket_no'] = this.ticketNo;
    data['message'] = this.message;
    return data;
  }
}

class Pagination {
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? start;
  int? end;

  Pagination(
      {this.page,
        this.limit,
        this.total,
        this.totalPages,
        this.start,
        this.end});

  Pagination.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['totalPages'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['totalPages'] = this.totalPages;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}
