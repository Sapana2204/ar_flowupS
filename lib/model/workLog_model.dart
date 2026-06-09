class WorkLog {
  final int? workLogId;
  final int? ticketId;
  final int? employeeId;
  final int? companyId;
  final String? workStartAt;
  final String? workEndAt;
  final int? spentMinutes;
  final String? workDetails;
  final String? workStatus;
  final int? createdBy;
  final String? createdDate;
  final int? modifiedBy;
  final String? modifiedDate;
  final String? status;
  final String? employeeName;
  final String? workDate;
  final String? workTime;

  WorkLog({
    this.workLogId,
    this.ticketId,
    this.employeeId,
    this.companyId,
    this.workStartAt,
    this.workEndAt,
    this.spentMinutes,
    this.workDetails,
    this.workStatus,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.status,
    this.employeeName,
    this.workDate,
    this.workTime,
  });

  factory WorkLog.fromJson(Map<String, dynamic> json) {
    return WorkLog(
      workLogId: json["work_log_id"],
      ticketId: json["ticket_id"],
      employeeId: json["employee_id"],
      companyId: json["company_id"],
      workStartAt: json["work_start_at"],
      workEndAt: json["work_end_at"],
      spentMinutes: json["spent_minutes"],
      workDetails: json["work_details"],
      workStatus: json["work_status"],
      createdBy: json["created_by"],
      createdDate: json["created_date"],
      modifiedBy: json["modified_by"],
      modifiedDate: json["modified_date"],
      status: json["status"],
      employeeName: json["employee_name"],
      workDate: json["work_date"],
      workTime: json["work_time"],
    );
  }
}