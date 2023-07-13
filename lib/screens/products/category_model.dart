

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  IconData get customIcon {
    switch (name) {
      case 'Accesories':
        return MyCustomIcons.accessories; // Replace with your custom icon data
      case 'Air Release Valve':
        return MyCustomIcons.airReleaseValve;
      case 'Automatic Control Valve':
        return MyCustomIcons.automaticControlValve;
      case 'Backflow Preventer':
        return MyCustomIcons.backflowPreventer;
      case 'Balancing Valves':
        return MyCustomIcons.balancingValves;
      case 'Ball Valves':
        return MyCustomIcons.ballValves;
      case 'Check Valve':
        return MyCustomIcons.checkValve;
      case 'Concentric Butterfly Valve':
        return MyCustomIcons.concentricButterflyValve;
      case 'Enye Controls Motorized Valves and Actuators':
        return MyCustomIcons.enyeControlsMotorizedValvesandActuators;
      case 'Flexible Joint':
        return MyCustomIcons.flexibleJoint;
      case 'Gate Valve':
        return MyCustomIcons.gateValve;
      case 'Globe Valve':
        return MyCustomIcons.globeValve;
      case 'Plunger Valve':
        return MyCustomIcons.plungerValve;
      case 'Softwares':
        return MyCustomIcons.softwares;
      case 'Strainers':
        return MyCustomIcons.strainer;
      case 'Test Equipments':
        return MyCustomIcons.testEquipments;
      case 'Variable Frequency Drive':
        return MyCustomIcons.variableFrequencyDrive;
      case 'Water Meter':
        return MyCustomIcons.waterMeter;

    // Add more cases for other category names and their corresponding custom icons
      default:
        return Icons.category; // Default icon for unknown category names
    }
  }

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

class MyCustomIcons {
  MyCustomIcons._();

  static const _kFontFam = 'MyCustomIcons';

  static const IconData accessories = IconData(0xe001, fontFamily: _kFontFam);
  static const IconData airReleaseValve = IconData(0xe002, fontFamily: _kFontFam);
  static const IconData automaticControlValve = IconData(0xe003, fontFamily: _kFontFam);
  static const IconData backflowPreventer = IconData(0xe004, fontFamily: _kFontFam);
  static const IconData balancingValves = IconData(0xe005, fontFamily: _kFontFam);
  static const IconData ballValves = IconData(0xe006, fontFamily: _kFontFam);
  static const IconData checkValve = IconData(0xe007, fontFamily: _kFontFam);
  static const IconData concentricButterflyValve = IconData(0xe008, fontFamily: _kFontFam);
  static const IconData enyeControlsMotorizedValvesandActuators = IconData(0xe009, fontFamily: _kFontFam);
  static const IconData flexibleJoint = IconData(0xe010, fontFamily: _kFontFam);
  static const IconData gateValve = IconData(0xe011, fontFamily: _kFontFam);
  static const IconData globeValve = IconData(0xe012, fontFamily: _kFontFam);
  static const IconData plungerValve = IconData(0xe013, fontFamily: _kFontFam);
  static const IconData softwares = IconData(0xe014, fontFamily: _kFontFam);
  static const IconData strainer = IconData(0xe015, fontFamily: _kFontFam);
  static const IconData testEquipments = IconData(0xe016, fontFamily: _kFontFam);
  static const IconData variableFrequencyDrive = IconData(0xe017, fontFamily: _kFontFam);
  static const IconData waterMeter = IconData(0xe0, fontFamily: _kFontFam);

// Define more custom icons as needed
}