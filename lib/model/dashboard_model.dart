class DashboardModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  Data? data;

  DashboardModel({
    this.success,
    this.code,
    this.type,
    this.message,
    this.data,
  });

  DashboardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'code': code,
      'type': type,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  String? role;
  String? scope;
  List<Summary>? summary;
  Charts? charts;
  List<dynamic>? recentActivity;

  Data({
    this.role,
    this.scope,
    this.summary,
    this.charts,
    this.recentActivity,
  });

  Data.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    scope = json['scope'];

    summary = json['summary'] != null
        ? (json['summary'] as List)
        .map((e) => Summary.fromJson(e))
        .toList()
        : [];

    charts =
    json['charts'] != null ? Charts.fromJson(json['charts']) : null;

    recentActivity = json['recentActivity'] ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'scope': scope,
      'summary': summary?.map((e) => e.toJson()).toList(),
      'charts': charts?.toJson(),
      'recentActivity': recentActivity,
    };
  }
}

class Summary {
  String? key;
  String? label;
  String? value; // Changed from int? to String?
  String? delta;
  String? tone;

  Summary({
    this.key,
    this.label,
    this.value,
    this.delta,
    this.tone,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    value = json['value']?.toString(); // Handles int and String
    delta = json['delta'];
    tone = json['tone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'value': value,
      'delta': delta,
      'tone': tone,
    };
  }
}

class Charts {
  List<dynamic>? ticketStatus;
  List<dynamic>? ticketTrend;
  List<Workload>? workload;

  Charts({
    this.ticketStatus,
    this.ticketTrend,
    this.workload,
  });

  Charts.fromJson(Map<String, dynamic> json) {
    ticketStatus = json['ticketStatus'] ?? [];
    ticketTrend = json['ticketTrend'] ?? [];

    workload = json['workload'] != null
        ? (json['workload'] as List)
        .map((e) => Workload.fromJson(e))
        .toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'ticketStatus': ticketStatus,
      'ticketTrend': ticketTrend,
      'workload': workload?.map((e) => e.toJson()).toList(),
    };
  }
}

class Workload {
  String? label;
  int? value;
  String? color;

  Workload({
    this.label,
    this.value,
    this.color,
  });

  Workload.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'color': color,
    };
  }
}