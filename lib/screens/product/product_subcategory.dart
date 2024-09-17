//values na meron si categories
class productSubCategory {
  String id;
  String name;
  String category_id;
  String sub_image;
  String sub_desc;
  String status;

  productSubCategory({
    required this.id,
    required this.name,
    required this.category_id,
    required this.sub_image,
    required this.sub_desc,
    required this.status,
  });

  factory productSubCategory.fromJson(Map<String, dynamic> json) {
    return productSubCategory(
      id: json['subCat_id'] as String,
      name: json['subCat_name'] as String,
      category_id: json['category_id'] as String,
      sub_image: json['sub_image'] as String,
      sub_desc: json['sub_desc'] as String,
      status: json['status'] as String,
    );
  }
}