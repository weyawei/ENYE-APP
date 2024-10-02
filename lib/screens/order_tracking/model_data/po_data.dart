class ClientPO {
  String id;
  String tracking_no;
  String po_no;
  String quotation_no;
  String quotation_id;
  String company;
  String project;
  String terms;
  String estimated_delivery;
  String status;

  ClientPO({
    required this.id,
    required this.tracking_no,
    required this.po_no,
    required this.quotation_no,
    required this.quotation_id,
    required this.company,
    required this.project,
    required this.terms,
    required this.estimated_delivery,
    required this.status,
  });

  factory ClientPO.fromJson(Map<String, dynamic> json) {
    return ClientPO(
      id: json['id'] as String? ?? '',
      tracking_no: json['code'] as String? ?? '',
      po_no: json['po_no'] as String? ?? '',
      quotation_no: json['quotation_no'] as String? ?? '',
      quotation_id: json['quotation_id'] as String? ?? '',
      company: json['company'] as String? ?? '',
      project: json['project'] as String? ?? '',
      terms: json['terms'] as String? ?? '',
      estimated_delivery: json['estimated_delivery'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class QuotationPO {
  String id;
  String quotation_no;
  String date;
  String company_name;
  String contact_person;
  String po_no;
  String terms;
  String project_name;

  QuotationPO({
    required this.id,
    required this.quotation_no,
    required this.date,
    required this.company_name,
    required this.contact_person,
    required this.po_no,
    required this.terms,
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
      terms: json['quotation_terms'] as String? ?? '',
      project_name: json['quotation_project'] as String? ?? '',
    );
  }
}