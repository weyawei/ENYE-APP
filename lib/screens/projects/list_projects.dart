class Projects {
  String proj_id;
  String title;
  String images;
  String category;
  String description1;
  String description2;
  String projCatalogs;
  String status;
  bool isExpanded;

  Projects({
    required this.proj_id,
    required this.title,
    required this.images,
    required this.category,
    required this.description1,
    required this.description2,
    required this.projCatalogs,
    required this.status,
    this.isExpanded = false,
  });

  factory Projects.fromJson(Map<String, dynamic> json) {
    return Projects(
      proj_id: json['project_id'] as String,
      title: json['proj_name'] as String,
      images: json['proj_image'] as String,
      category: json['projCateg_id'] as String,
      description1: json['proj_sys'] as String,
      description2: json['proj_description'] as String,
      projCatalogs: json['proj_catalogs'] as String,
      status:  json['status'] as String,
    );
  }
}