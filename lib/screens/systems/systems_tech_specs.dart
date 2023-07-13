class SystemsTechSpecs {
  String id;
  String systems_id;
  String title;
  String features;
  String image;
  String product_pdf;

  SystemsTechSpecs({
    required this.id,
    required this.systems_id,
    required this.title,
    required this.features,
    required this.image,
    required this.product_pdf,
  });

  factory SystemsTechSpecs.fromJson(Map<String, dynamic> json) {
    return SystemsTechSpecs(
      id: json['id'] as String,
      systems_id: json['systems_id'] as String,
      title: json['title'] as String,
      features: json['features'] as String,
      image: json['image'] as String,
      product_pdf: json['product_catalog'] as String,
    );
  }
}