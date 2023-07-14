

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

    static const String accessories = 'assets/icons/icon_product_categ/plug.png';
    static const String airReleaseValve ='assets/icons/icon_product_categ/valve1.png';
    static const String automaticControlValve = 'assets/icons/icon_product_categ/controller.png';
    static const String backflowPreventer = 'assets/icons/icon_product_categ/valve1.png';
    static const String balancingValves = 'assets/icons/icon_product_categ/valve2.png';
    static const String ballValves = 'assets/icons/icon_product_categ/valve3.png';
    static const String checkValve = 'assets/icons/icon_product_categ/valve4.png';
    static const String concentricButterflyValve = 'assets/icons/icon_product_categ/valve1.png';
    static const String enyeControlsMotorizedValvesandActuators = 'assets/icons/icon_product_categ/valve1.png';
    static const String flexibleJoint = 'assets/icons/icon_product_categ/valve1.png';
    static const String gateValve = 'assets/icons/icon_product_categ/valve1.png';
    static const String globeValve = 'assets/icons/icon_product_categ/valve1.png';
    static const String plungerValve = 'assets/icons/icon_product_categ/valve1.png';
    static const String softwares = 'assets/icons/icon_product_categ/valve1.png';
    static const String strainer = 'assets/icons/icon_product_categ/valve1.png';
    static const String testEquipments = 'assets/icons/icon_product_categ/valve1.png';
    static const String variableFrequencyDrive = 'assets/icons/icon_product_categ/valve1.png';
    static const String waterMeter = 'assets/icons/icon_product_categ/valve1.png';

  // Define more custom icons as needed
  }