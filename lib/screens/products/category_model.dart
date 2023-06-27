

import 'package:equatable/equatable.dart';

class Category1 extends Equatable{
  final String name;
  final String imageUrl;

  const Category1({
    required this.name,
    required this.imageUrl,
});
  @override
  List<Object?> get props =>  [name, imageUrl];

static List<Category1> categories = [
  Category1(
      name: 'Accesories',
      imageUrl: 'assets/products_category/categ1.png'),
  Category1(
      name: 'Air Release Valve',
      imageUrl: 'assets/products_category/categ2.png'),
  Category1(
      name: 'Automatic Control Valve',
      imageUrl: 'assets/products_category/categ3.png'),
  Category1(
      name: 'Backflow Preventer',
      imageUrl: 'assets/products_category/categ4.png'),
  Category1(
      name: 'Balancing Valves',
      imageUrl: 'assets/products_category/categ5.png'),
  Category1(
      name: 'Ball Valves',
      imageUrl: 'assets/products_category/categ6.png'),
  Category1(
      name: 'Check Valve',
      imageUrl: 'assets/products_category/categ7.png'),
  Category1(
      name: 'Concentric Butterfly Valve',
      imageUrl: 'assets/products_category/categ8.png'),
  Category1(
      name: 'Controller',
      imageUrl: 'assets/products_category/categ9.png'),
  Category1(
      name: 'Ecentric Butterfly Valves',
      imageUrl: 'assets/products_category/categ10.png'),
  Category1(
      name: 'Enye Controls Motorized Valves and Actuators',
      imageUrl: 'assets/products_category/categ11.png'),
  Category1(
      name: 'Flexible Joint',
      imageUrl: 'assets/products_category/categ12.png'),
  Category1(
      name: 'Gate Valve',
      imageUrl: 'assets/products_category/categ13.png'),
  Category1(
      name: 'Globe Valve',
      imageUrl: 'assets/products_category/categ14.png'),
  Category1(
      name: 'Flanger Valve',
      imageUrl: 'assets/products_category/categ15.png'),
  Category1(
      name: 'Softwares',
      imageUrl: 'assets/products_category/categ17.png'),
  Category1(
      name: 'Strainer',
      imageUrl: 'assets/products_category/categ18.png'),
  Category1(
      name: 'Test Equipments',
      imageUrl: 'assets/products_category/categ19.png'),
  Category1(
      name: 'Variable Frequency Drive',
      imageUrl: 'assets/products_category/categ20.png'),
  Category1(
      name: 'Water Meter',
      imageUrl: 'assets/products_category/categ21.png'),

];
}