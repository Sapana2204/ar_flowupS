class CreateWorkLogModel {
  final int ticketId;
  final String workStartAt;
  final int spentMinutes;
  final String workDetails;
  final String workStatus;

  CreateWorkLogModel({
    required this.ticketId,
    required this.workStartAt,
    required this.spentMinutes,
    required this.workDetails,
    required this.workStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "ticket_id": ticketId,
      "work_start_at": workStartAt,
      "spent_minutes": spentMinutes,
      "work_details": workDetails,
      "work_status": workStatus,
    };
  }
}