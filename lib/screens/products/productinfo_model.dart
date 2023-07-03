

import 'package:equatable/equatable.dart';

class ProductInfo extends Equatable{
  final String subcategory;
  final String name;
  final String model;
  final String size;
  final String price;


  const ProductInfo({
    required this.subcategory,
    required this.name,
    required this.model,
    required this.size,
    required this.price
});

  @override
  List<Object?> get props => [subcategory, name, model, size, price];
  static List<ProductInfo> info = [
    ProductInfo(
      subcategory: 'Vector Accesories',
      name: 'Gateways',
    model: 'AEX-SMP-BAC',
    size: 'HMI/Server/Controller Atrius solution builder license included',
    price: '47,218.12',
    ),
    ProductInfo(
      subcategory: 'Vector Accesories',
      name: 'Gateways',
      model: 'AEX-SMP-MOD',
      size: 'HMI/Server/Controller Atrius Solution Builder License included   ',
      price: '47,218.12',
    ),
    ProductInfo(
      subcategory: 'Air Release Valve',
      name: 'AVMX series Air Release Valve',
      model: '1x',
      size: 'Descriptions',
      price: '1012',
    ),
    ProductInfo(
      subcategory: 'Air Release Valve',
      name: 'AVMX series Air Release Valve',
      model: '2x',
      size: 'Descriptions',
      price: '1025',
    ),
    ProductInfo(
      subcategory: 'Air Release Valve',
      name: 'AVRX Series Air Release Valve',
      model: '3x',
      size: 'Descriptions',
      price: '1033',
    ),



  ];
}