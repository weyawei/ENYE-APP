//values na meron si categories
class productCategory {
  String id;
  String name;
  String icon;
  String published;

  productCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.published,
  });

  factory productCategory.fromJson(Map<String, dynamic> json) {
    return productCategory(
      id: json['category_id'] as String,
      name: json['cat_name'] as String,
      icon: json['icon'] as String,
      published: json['published'] as String,
    );
  }
}