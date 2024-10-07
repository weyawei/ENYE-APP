class EngEvents {
  String id;
  String tsis_id;
  String title;
  String engineer;
  String technician;
  String start;
  String end;
  String so_no;
  String status;
  String date_completed;
  String remarks;

  EngEvents({
    required this.id,
    required this.tsis_id,
    required this.title,
    required this.engineer,
    required this.technician,
    required this.start,
    required this.end,
    required this.so_no,
    required this.status,
    required this.date_completed,
    required this.remarks,
  });

  factory EngEvents.fromJson(Map<String, dynamic> json) {
    return EngEvents(
      id: json['id'] as String? ?? '',
      tsis_id: json['tsis_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      engineer: json['engineer'] as String? ?? '',
      technician: json['technician'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      so_no: json['so_no'] as String? ?? '',
      status: json['status'] as String? ?? '',
      date_completed: json['date_completed'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
    );
  }
}
