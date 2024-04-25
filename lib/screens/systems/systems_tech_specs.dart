class SystemsTechSpecs {
  String id;
  String title;
  String features;
  String image;
  List product_pdf;

  SystemsTechSpecs({
    required this.id,
    required this.title,
    required this.features,
    required this.image,
    required this.product_pdf,
  });

  factory SystemsTechSpecs.fromJson(Map<String, dynamic> json) {
    return SystemsTechSpecs(
      id: json['id'] as String,
      title: json['title'] as String,
      features: json['features'] as String,
      image: json['image'] as String,
      product_pdf: json['product_catalog'] as List,
    );
  }
}