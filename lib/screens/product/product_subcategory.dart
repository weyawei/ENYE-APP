//values na meron si categories
class productSubCategory {
  String id;
  String name;
  String category_id;

  productSubCategory({
    required this.id,
    required this.name,
    required this.category_id,
  });

  factory productSubCategory.fromJson(Map<String, dynamic> json) {
    return productSubCategory(
      id: json['subCat_id'] as String,
      name: json['subCat_name'] as String,
      category_id: json['category_id'] as String,
    );
  }
}