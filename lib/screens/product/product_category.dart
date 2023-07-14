//values na meron si categories
class productCategory {
  String id;
  String name;
  String icon;

  productCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory productCategory.fromJson(Map<String, dynamic> json) {
    return productCategory(
      id: json['category_id'] as String,
      name: json['cat_name'] as String,
      icon: json['icon'] as String,
    );
  }
}