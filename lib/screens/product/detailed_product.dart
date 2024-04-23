//values na meron si categories
class detailedProduct {
  String id;
  String product_id;
  String title;
  String description;
  String image;
  String product_pdf;

  detailedProduct({
    required this.id,
    required this.product_id,
    required this.title,
    required this.description,
    required this.image,
    required this.product_pdf,
  });

  factory detailedProduct.fromJson(Map<String, dynamic> json) {
    return detailedProduct(
      id: json['id'] as String,
      product_id: json['product_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      product_pdf: json['product_pdf'] as String,
    );
  }
}