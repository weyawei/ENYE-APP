class ClientPOItems {
  String item_id;
  String po_id;
  String item_type;
  String item_name;
  String item_desc;
  String qty;
  String status_remarks;

  ClientPOItems({
    required this.item_id,
    required this.po_id,
    required this.item_type,
    required this.item_name,
    required this.item_desc,
    required this.qty,
    required this.status_remarks,
  });

  factory ClientPOItems.fromJson(Map<String, dynamic> json) {
    return ClientPOItems(
      item_id: json['quotation_id'] as String? ?? '',
      po_id: json['po_id'] as String? ?? '',
      item_type: json['quotation_item_type'] as String? ?? '',
      item_name: json['quotation_item_name'] as String? ?? '',
      item_desc: json['quotation_item_desc'] as String? ?? '',
      qty: json['quotation_item_quantity'] as String? ?? '',
      status_remarks: json['quotation_item_status'] as String? ?? '',
    );
  }
}

class QuotationPOItems {
  String id;
  String quotation_id;
  String item_type;
  String item_name;
  String item_desc;
  String qty;

  QuotationPOItems({
    required this.id,
    required this.quotation_id,
    required this.item_type,
    required this.item_name,
    required this.item_desc,
    required this.qty,
  });

  factory QuotationPOItems.fromJson(Map<String, dynamic> json) {
    return QuotationPOItems(
      id: json['quotation_item_id'] as String? ?? '',
      quotation_id: json['quotation_id'] as String? ?? '',
      item_type: json['quotation_item_type'] as String? ?? '',
      item_name: json['quotation_item_name'] as String? ?? '',
      item_desc: json['quotation_item_desc'] as String? ?? '',
      qty: json['quotation_item_quantity'] as String? ?? '',
    );
  }
}