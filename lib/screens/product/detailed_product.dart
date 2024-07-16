//values na meron si categories
class detailedProduct {
  String id;
  String product_id;
  String title;
  String description;
  String image;
  String product_pdf;
  bool isExpanded;

  detailedProduct({
    required this.id,
    required this.product_id,
    required this.title,
    required this.description,
    required this.image,
    required this.product_pdf,
    this.isExpanded = false,
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

//values na meron si categories
class thumb {
  String id;
  String product_id;
  String thumbnails;
  String name;

  thumb({
    required this.id,
    required this.product_id,
    required this.thumbnails,
    required this.name,
  });

  factory thumb.fromJson(Map<String, dynamic> json) {
    return thumb(
      id: json['id'] as String,
      product_id: json['product_id'] as String,
      thumbnails: json['thumbnails'] as String,
      name: json['thumb_name'] as String,
    );
  }
}

class size {
  String id;
  String product_id;
  String sizes;

  size({
    required this.id,
    required this.product_id,
    required this.sizes,
  });

  factory size.fromJson(Map<String, dynamic> json) {
    return size(
      id: json['id'] as String,
      product_id: json['product_id'] as String,
      sizes: json['size'] as String,
    );
  }
}