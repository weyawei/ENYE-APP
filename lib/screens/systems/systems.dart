//values na meron si categories
class Systems {
  String id;
  String title;
  String description;
  String image;
  String catalogs_pdf;
  String sys_tech_id;

  Systems({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.catalogs_pdf,
    required this.sys_tech_id,
  });

  factory Systems.fromJson(Map<String, dynamic> json) {
    return Systems(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      catalogs_pdf: json['catalogs_pdf'] as String,
      sys_tech_id : json['sys_tech_id'] as String,
    );
  }
}