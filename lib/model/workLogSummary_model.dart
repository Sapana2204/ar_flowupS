class WorkLogSummary {
  final int expectedMinutes;
  final int loggedMinutes;
  final int remainingMinutes;
  final int overtimeMinutes;
  final String canAddLog;

  WorkLogSummary({
    required this.expectedMinutes,
    required this.loggedMinutes,
    required this.remainingMinutes,
    required this.overtimeMinutes,
    required this.canAddLog,
  });

  factory WorkLogSummary.fromJson(Map<String, dynamic> json) {
    return WorkLogSummary(
      expectedMinutes: json["expected_minutes"] ?? 0,
      loggedMinutes: json["logged_minutes"] ?? 0,
      remainingMinutes: json["remaining_minutes"] ?? 0,
      overtimeMinutes: json["overtime_minutes"] ?? 0,
      canAddLog: json["can_add_log"] ?? "N",
    );
  }
}