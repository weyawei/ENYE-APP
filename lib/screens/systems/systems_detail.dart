class SystemsDetail {
  String id;
  String systems_id;
  String title;
  String description;
  String image;

  SystemsDetail({
    required this.id,
    required this.systems_id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory SystemsDetail.fromJson(Map<String, dynamic> json) {
    return SystemsDetail(
      id: json['id'] as String,
      systems_id: json['systems_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
    );
  }
}