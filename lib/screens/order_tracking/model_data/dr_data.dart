class DRDetails {
  String dr_id;
  String dr_no;
  String date;
  String po_no;
  String address_one;
  String address_two;
  String terms;
  String dr_to;
  String date_received;
  List<DRItem> dr_items;

  DRDetails({
    required this.dr_id,
    required this.dr_no,
    required this.date,
    required this.po_no,
    required this.address_one,
    required this.address_two,
    required this.terms,
    required this.dr_to,
    required this.date_received,
    required this.dr_items,
  });

  factory DRDetails.fromJson(Map<String, dynamic> json) {
    return DRDetails(
      dr_id: json['id'] as String? ?? '',
      dr_no: json['dr_no'] as String? ?? '',
      date: json['dr_date'] as String? ?? '',
      po_no: json['po_no'] as String? ?? '',
      address_one: json['address_one'] as String? ?? '',
      address_two: json['address_two'] as String? ?? '',
      terms: json['terms'] as String? ?? '',
      dr_to: json['dr_to'] as String? ?? '',
      date_received: json['date_received'] as String? ?? '',
      dr_items: (json['dr_items'] as List<dynamic>?)?.map((item) => DRItem.fromJson(item as Map<String, dynamic>)).toList() ?? [],
    );
  }
}

class DRItem {
  String id;
  String dr_id;
  String quantity;
  String item;
  String item_not_exist;
  String description;

  DRItem({
    required this.id,
    required this.dr_id,
    required this.quantity,
    required this.item,
    required this.item_not_exist,
    required this.description,
  });

  factory DRItem.fromJson(Map<String, dynamic> json) {
    return DRItem(
      id: json['id'] as String? ?? '',
      dr_id: json['dr_id'] as String? ?? '',
      quantity: json['quantity'] as String? ?? '',
      item: json['item'] as String? ?? '',
      item_not_exist: json['item_not_exist'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}



