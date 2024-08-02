//values na meron si categories
class product {
  String id;
  String name;
  String prod_desc;
  String category_id;
  String subCategory_id;
  String isPopular;
  String image;
  String model_3d;
  String catalogs_pdf;
  String status;
  bool isExpanded;

  product({
    required this.id,
    required this.name,
    required this.prod_desc,
    required this.category_id,
    required this.subCategory_id,
    required this.isPopular,
    required this.image,
    required this.model_3d,
    required this.catalogs_pdf,
    required this.status,
    this.isExpanded = false,
  });

  factory product.fromJson(Map<String, dynamic> json) {
    return product(
      id: json['product_id'] as String,
      name: json['prod_name'] as String,
      prod_desc: json['prod_desc'] as String,
      category_id: json['category_id'] as String,
      subCategory_id: json['subCategory_id'] as String,
      isPopular: json['isPopular'] as String,
      image: json['image'] as String,
      model_3d: json['3d_model'] as String? ?? '',
      catalogs_pdf: json['catalogs_pdf'] as String,
      status: json['status'] as String,
    );
  }
}