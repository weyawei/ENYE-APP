class PODetails {
  String id;
  String po_id;
  String sort_no;
  String estimated_delivery;
  String status;
  String payment_status;
  String remarks;
  String date_created;

  PODetails({
    required this.id,
    required this.po_id,
    required this.sort_no,
    required this.estimated_delivery,
    required this.status,
    required this.payment_status,
    required this.remarks,
    required this.date_created,
  });

  factory PODetails.fromJson(Map<String, dynamic> json) {
    return PODetails(
      id: json['id'] as String? ?? '',
      po_id: json['po_id'] as String? ?? '',
      sort_no: json['sort_no'] as String? ?? '',
      estimated_delivery: json['estimated_delivery'] as String? ?? '',
      status: json['status'] as String? ?? '',
      payment_status: json['payment_status'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      date_created: json['date_created'] as String? ?? '',
    );
  }
}