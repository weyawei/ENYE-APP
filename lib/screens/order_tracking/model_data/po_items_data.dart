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