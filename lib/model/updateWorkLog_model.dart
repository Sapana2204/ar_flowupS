class UpdateWorkLogModel {
  final int workLogId;
  final int ticketId;
  final String workDetails;
  final String workStatus;

  UpdateWorkLogModel({
    required this.workLogId,
    required this.ticketId,
    required this.workDetails,
    required this.workStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "work_log_id": workLogId,
      "ticket_id": ticketId,
      "work_details": workDetails,
      "work_status": workStatus,
    };
  }
}