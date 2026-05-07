class CommentModel {
  int? commentId;
  int? ticketId;
  String? recordType;
  int? userId;
  String? commentText;
  String? createdDate;
  String? userName;

  CommentModel({
    this.commentId,
    this.ticketId,
    this.recordType,
    this.userId,
    this.commentText,
    this.createdDate,
    this.userName,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json['comment_id'],
      ticketId: json['ticket_id'],
      recordType: json['record_type'],
      userId: json['user_id'],
      commentText: json['comment_text'],
      createdDate: json['created_date'],
      userName: json['user_name'],
    );
  }
}