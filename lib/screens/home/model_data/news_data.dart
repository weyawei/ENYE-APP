class NewsUpdates {
  String id;
  String title;
  String description;
  String news_image;
  String status;
  bool isExpanded;

  NewsUpdates({
    required this.id,
    required this.title,
    required this.description,
    required this.news_image,
    required this.status,
    this.isExpanded = false,
  });

  factory NewsUpdates.fromJson(Map<String, dynamic> json) {
    return NewsUpdates(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      news_image: json['image'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}

class NewsContents {
  String id;
  String news_id;
  String description;
  String content_image;
  bool isExpanded;

  NewsContents({
    required this.id,
    required this.news_id,
    required this.description,
    required this.content_image,
    this.isExpanded = false,
  });

  factory NewsContents.fromJson(Map<String, dynamic> json) {
    return NewsContents(
      id: json['id'] as String? ?? '',
      news_id: json['news_updates_id'] as String? ?? '',
      description: json['content_desc'] as String? ?? '',
      content_image: json['image'] as String? ?? '',
    );
  }
}