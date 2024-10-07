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

  String category_name;
  String subcategory_name;
  String subCat1_id;
  String subcategory_name1;
  String subCat2_id;
  String subcategory_name2;



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

    required this.category_name,
    required this.subcategory_name,
    required this.subCat1_id,
    required this.subcategory_name1,
    required this.subCat2_id,
    required this.subcategory_name2,

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

      category_name: json['category_name'] as String,
      subcategory_name: json['subcategory_name'] as String,
      subCat1_id: json['subCat1_id'] as String,
      subcategory_name1: json['subCat1_name'] as String,
      subCat2_id: json['subCat2_id'] as String,
      subcategory_name2: json['subCat2_name'] as String,
    );
  }
}