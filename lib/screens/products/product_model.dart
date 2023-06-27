import 'package:equatable/equatable.dart';

class Product extends Equatable{
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final bool isRecommended;
  final bool isPopular;

  const Product ({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.isPopular,
    required this.isRecommended,

});



  @override
  List<Object?> get props => [name, category, imageUrl, price, isRecommended, isPopular];

  static List<Product> products = [
    Product(
        name: 'Accesories',
        category: 'Accesories',
        imageUrl: 'assets/products_category/categ1.png',
        price: 24.12,
        isRecommended: true,
        isPopular: true,
    ),
    Product(
        name: 'Air Release Valve',
        category: 'Air Release Valve',
        imageUrl: 'assets/products_category/categ2.png',
        price: 24.12,
        isRecommended: false,
        isPopular: true,
    ),
    Product(
        name: 'Automatic Control Valve',
        category: 'Automatic Control Valve',
        imageUrl: 'assets/products_category/categ3.png',
        price: 24.12,
        isRecommended: false,
        isPopular: false,
    ),
    Product(
        name: 'Backflow Preventer',
        category: 'Backflow Preventer',
        imageUrl: 'assets/products_category/categ4.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Balancing Valves',
        category: 'Balancing Valves',
        imageUrl: 'assets/products_category/categ5.png',
        price: 24.12,
        isRecommended: false,
        isPopular: false,
    ),
    Product(
        name: 'Ball Valves',
        category: 'Ball Valves',
        imageUrl: 'assets/products_category/categ6.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Check Valve',
        category: 'Check Valve',
        imageUrl: 'assets/products_category/categ7.png',
        price: 24.12,
        isRecommended: true,
        isPopular: true,
    ),
    Product(
        name: 'Concentric Butterfly Valve',
        category: 'Concentric Butterfly Valve',
        imageUrl: 'assets/products_category/categ8.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Controller',
        category: 'Controller',
        imageUrl: 'assets/products_category/categ9.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Ecentric Butterfly Valves',
        category: 'Ecentric Butterfly Valves',
        imageUrl: 'assets/products_category/categ10.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Enye Controls Motorized Valves and Actuators',
        category: 'Enye Controls Motorized Valves and Actuators',
        imageUrl: 'assets/products_category/categ11.png',
        price: 24.12,
        isRecommended: false,
        isPopular: false,
    ),
    Product(
        name: 'Flexible Joint',
        category: 'Flexible Joint',
        imageUrl: 'assets/products_category/categ12.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Gate Valve',
        category: 'Gate Valve',
        imageUrl: 'assets/products_category/categ13.png',
        price: 24.12,
        isRecommended: false,
        isPopular: true,
    ),
    Product(
        name: 'Globe Valve',
        category: 'Globe Valve',
        imageUrl: 'assets/products_category/categ14.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Flanger Valve',
        category: 'Flanger Valve',
        imageUrl: 'assets/products_category/categ15.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Softwares',
        category: 'Softwares',
        imageUrl: 'assets/products_category/categ17.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
    Product(
        name: 'Strainer',
        category: 'Strainer',
        imageUrl: 'assets/products_category/categ18.png',
        price: 24.12,
        isRecommended: true,
        isPopular: true,
    ),
    Product(
        name: 'Test Equipments',
        category: 'Test Equipments',
        imageUrl: 'assets/products_category/categ19.png',
        price: 24.12,
        isRecommended: false,
        isPopular: false,
    ),
    Product(
        name: 'Variable Frequency Drive',
        category: 'Variable Frequency Drive',
        imageUrl: 'assets/products_category/categ20.png',
        price: 24.12,
        isRecommended: true,
        isPopular: true,
    ),
    Product(
        name: 'Water Meter',
        category: 'Water Meter',
        imageUrl: 'assets/products_category/categ21.png',
        price: 24.12,
        isRecommended: true,
        isPopular: false,
    ),
];
}