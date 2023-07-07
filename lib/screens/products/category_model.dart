

import 'package:equatable/equatable.dart';

class Category1 extends Equatable{
  final String categoryId;
  final String name;
  final String subcategory;
  final String imageUrl;

  const Category1({
    required this.categoryId,
    required this.name,
    required this.subcategory,
    required this.imageUrl,
});
  @override
  List<Object?> get props =>  [name, subcategory, imageUrl];

static List<Category1> categories = [
  Category1(
      categoryId: '1',
      name: 'Accesories',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ1.png'),
  Category1(
      categoryId: '2',
      name: 'Air Release Valve',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ2.png'),
  Category1(
      categoryId: '3',
      name: 'Automatic Control Valve',
      subcategory: 'Vector1',
      imageUrl: 'assets/products_category/categ3.png'),
  Category1(
      categoryId: '4',
      name: 'Backflow Preventer',
      subcategory: 'Vector1',
      imageUrl: 'assets/products_category/categ4.png'),
  Category1(
      categoryId: '5',
      name: 'Balancing Valves',
      subcategory: 'Vector1',
      imageUrl: 'assets/products_category/categ5.png'),
  Category1(
      categoryId: '6',
      name: 'Ball Valves',
      subcategory: 'Vector1',
      imageUrl: 'assets/products_category/categ6.png'),
  Category1(
      categoryId: '7',
      name: 'Check Valve',
      subcategory: 'Vector2',
      imageUrl: 'assets/products_category/categ7.png'),
  Category1(
      categoryId: '8',
      name: 'Concentric Butterfly Valve',
      subcategory: 'Vector2',
      imageUrl: 'assets/products_category/categ8.png'),
  Category1(
      categoryId: '9',
      name: 'Controller',
      subcategory: 'Vector3',
      imageUrl: 'assets/products_category/categ9.png'),
  Category1(
      categoryId: '10',
      name: 'Ecentric Butterfly Valves',
      subcategory: 'Vector3',
      imageUrl: 'assets/products_category/categ10.png'),
  Category1(
      categoryId: '11',
      name: 'Enye Controls Motorized Valves and Actuators',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ11.png'),
  Category1(
      categoryId: '12',
      name: 'Flexible Joint',
      subcategory: 'Vector3',
      imageUrl: 'assets/products_category/categ12.png'),
  Category1(
      categoryId: '13',
      name: 'Gate Valve',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ13.png'),
  Category1(
      categoryId: '14',
      name: 'Globe Valve',
      subcategory: 'Vector4',
      imageUrl: 'assets/products_category/categ14.png'),
  Category1(
      categoryId: '15',
      name: 'Plunger Valve',
      subcategory: 'Vector4',
      imageUrl: 'assets/products_category/categ15.png'),
  Category1(
      categoryId: '16',
      name: 'Softwares',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ17.png'),
  Category1(
      categoryId: '17',
      name: 'Strainer',
      subcategory: 'Vector4',
      imageUrl: 'assets/products_category/categ18.png'),
  Category1(
      categoryId: '18',
      name: 'Test Equipments',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ19.png'),
  Category1(
      categoryId: '19',
      name: 'Variable Frequency Drive',
      subcategory: 'Vector',
      imageUrl: 'assets/products_category/categ20.png'),
  Category1(
      categoryId: '20',
      name: 'Water Meter',
      subcategory: 'Vector4',
      imageUrl: 'assets/products_category/categ21.png'),

];
}