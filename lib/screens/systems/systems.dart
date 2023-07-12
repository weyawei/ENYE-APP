//values na meron si categories
class Systems {
  String id;
  String title;
  String description;
  String image;
  String catalogs_pdf;

  Systems({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.catalogs_pdf,
  });

  factory Systems.fromJson(Map<String, dynamic> json) {
    return Systems(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      catalogs_pdf: json['catalogs_pdf'] as String,
    );
  }
}