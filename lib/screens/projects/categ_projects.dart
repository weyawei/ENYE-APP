class projCategories {
  String category;
  String title;
  String images;

  projCategories({
    required this.category,
    required this.title,
    required this.images,
  });

  factory projCategories.fromJson(Map<String, dynamic> json) {
    return projCategories(
      category: json['projCateg_id'] as String,
      title: json['projCateg_name'] as String,
      images: json['projCateg_image'] as String,
    );
  }
}

final List<projCategories> projCategoriesList = [
  projCategories(category: 'ALL', images: 'assets/icons/select-all.png', title: 'ALL'),
  projCategories(category: '7', images: 'assets/icons/proj_school.png', title: 'SCHOOL & LEARNING CENTERS'),
  projCategories(category: '1', images: 'assets/icons/proj_buildings.png', title: 'BUILDINGS'),
  projCategories(category: '2', images: 'assets/icons/proj_hospital.png', title: 'HOSPITALS'),
  projCategories(category: '3', images: 'assets/icons/proj_condo.png', title: 'CONDOMINIUM'),
  projCategories(category: '4', images: 'assets/icons/proj_resort.png', title: 'HOTEL & RESORT'),
  projCategories(category: '5', images: 'assets/icons/proj_airport.png', title: 'INDUSTRIES'),
  projCategories(category: '6', images: 'assets/icons/proj_mall.png', title: 'MALLS'),
];
