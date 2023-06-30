

import 'package:equatable/equatable.dart';

class ProductInfo extends Equatable{
  final String name;
  final String model;
  final String size;
  final String price;


  const ProductInfo({
    required this.name,
    required this.model,
    required this.size,
    required this.price
});

  @override
  List<Object?> get props => [model, size, price];
  static List<ProductInfo> info = [
    ProductInfo(
      name: 'Gateways',
    model: '1',
    size: 'Descriptions',
    price: '10',
    ),
    ProductInfo(
      name: 'Gateways',
      model: '2',
      size: 'Descriptions1',
      price: '101',
    ),
    ProductInfo(
      name: 'Gateways',
      model: '3',
      size: 'Descriptions2',
      price: '102',
    ),


  ];
}