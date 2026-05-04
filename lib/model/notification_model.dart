class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int referenceId;
  final String isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.referenceId,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notification_id'],
      title: json['title'],
      message: json['message'],
      referenceId: json['reference_id'],
      isRead: json['is_read'],
    );
  }

  /// ✅ ADD THIS
  NotificationModel copyWith({
    String? isRead,
  }) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      referenceId: referenceId,
      isRead: isRead ?? this.isRead,
    );
  }
}