class Ticket {
  final String title;
  final String status;
  final String category;
  final String assignedBy;
  final String assignedTo;
  final String resolvedBy;
  final String resolvedOn;

  Ticket({
    required this.title,
    required this.status,
    required this.category,
    required this.assignedBy,
    required this.assignedTo,
    required this.resolvedBy,
    required this.resolvedOn,
  });
}