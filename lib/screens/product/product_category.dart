//values na meron si categories
class productCategory {
  String id;
  String name;
  String icon;
  String image;
  String published;
  String arrangement;
  String status;

  productCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.image,
    required this.published,
    required this.arrangement,
    required this.status,
  });

  factory productCategory.fromJson(Map<String, dynamic> json) {
    return productCategory(
      id: json['category_id'] as String,
      name: json['cat_name'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String,
      published: json['published'] as String,
      arrangement:  json['arrangement'] as String,
      status: json['status'] as String,
    );
  }
}