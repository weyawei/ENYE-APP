class QuotationPO {
  String id;
  String quotation_no;
  String date;
  String company_name;
  String contact_person;
  String po_no;
  String project_name;

  QuotationPO({
    required this.id,
    required this.quotation_no,
    required this.date,
    required this.company_name,
    required this.contact_person,
    required this.po_no,
    required this.project_name,
  });

  factory QuotationPO.fromJson(Map<String, dynamic> json) {
    return QuotationPO(
      id: json['quotation_id'] as String? ?? '',
      quotation_no: json['quotation_no'] as String? ?? '',
      date: json['quotation_date'] as String? ?? '',
      company_name: json['quotation_company_name'] as String? ?? '',
      contact_person: json['quotation_contact_person'] as String? ?? '',
      po_no: json['quotation_po_no'] as String? ?? '',
      project_name: json['quotation_project'] as String? ?? '',
    );
  }
}