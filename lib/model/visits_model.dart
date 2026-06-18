class VisitsModel {
  bool? success;
  int? code;
  String? type;
  String? message;
  List<VisitData>? data;

  VisitsModel({this.success, this.code, this.type, this.message, this.data});

  VisitsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    type = json['type'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VisitData>[];
      json['data'].forEach((v) {
        data!.add(new VisitData.fromJson(v));
      });
    }
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
    return data;
  }
}

class VisitData {
  int? visitId;
  int? ticketId;
  int? employeeId;
  int? companyId;
  String? visitScheduledAt;
  String? visitedAt;
  String? visitDetails;
  String? visitStatus;
  String? visitToken;
  String? latitude;
  String? longitude;
  String? markedBy;
  int? createdBy;
  String? createdDate;
  dynamic modifiedBy;
  String? modifiedDate;
  String? status;
  String? employeeName;
  String? visitDate;
  String? visitTime;
  String? visitedDate;
  String? visitedTime;

  VisitData(
      {this.visitId,
        this.ticketId,
        this.employeeId,
        this.companyId,
        this.visitScheduledAt,
        this.visitedAt,
        this.visitDetails,
        this.visitStatus,
        this.visitToken,
        this.latitude,
        this.longitude,
        this.markedBy,
        this.createdBy,
        this.createdDate,
        this.modifiedBy,
        this.modifiedDate,
        this.status,
        this.employeeName,
        this.visitDate,
        this.visitTime,
        this.visitedDate,
        this.visitedTime});

  VisitData.fromJson(Map<String, dynamic> json) {
    visitId = json['visit_id'];
    ticketId = json['ticket_id'];
    employeeId = json['employee_id'];
    companyId = json['company_id'];

    visitScheduledAt = json['visit_scheduled_at']?.toString();
    visitedAt = json['visited_at']?.toString();
    visitDetails = json['visit_details']?.toString();
    visitStatus = json['visit_status']?.toString();
    visitToken = json['visit_token']?.toString();

    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
    markedBy = json['marked_by']?.toString();

    createdBy = json['created_by'];
    createdDate = json['created_date']?.toString();

    modifiedBy = json['modified_by'];
    modifiedDate = json['modified_date']?.toString();

    status = json['status']?.toString();
    employeeName = json['employee_name']?.toString();

    visitDate = json['visit_date']?.toString();
    visitTime = json['visit_time']?.toString();
    visitedDate = json['visited_date']?.toString();
    visitedTime = json['visited_time']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visit_id'] = this.visitId;
    data['ticket_id'] = this.ticketId;
    data['employee_id'] = this.employeeId;
    data['company_id'] = this.companyId;
    data['visit_scheduled_at'] = this.visitScheduledAt;
    data['visited_at'] = this.visitedAt;
    data['visit_details'] = this.visitDetails;
    data['visit_status'] = this.visitStatus;
    data['visit_token'] = this.visitToken;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['marked_by'] = this.markedBy;
    data['created_by'] = this.createdBy;
    data['created_date'] = this.createdDate;
    data['modified_by'] = this.modifiedBy;
    data['modified_date'] = this.modifiedDate;
    data['status'] = this.status;
    data['employee_name'] = this.employeeName;
    data['visit_date'] = this.visitDate;
    data['visit_time'] = this.visitTime;
    data['visited_date'] = this.visitedDate;
    data['visited_time'] = this.visitedTime;
    return data;
  }
}
