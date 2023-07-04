

import 'package:equatable/equatable.dart';

class SubCategory extends Equatable{
  final String category;
  final String subcategory;
  final String imageUrl;

  const SubCategory({
    required this.category,
    required this.subcategory,
    required this.imageUrl,
  });
  @override
  List<Object?> get props =>  [category, subcategory, imageUrl];

  static List<SubCategory> categories = [
    SubCategory(
        category: 'Accesories',
        subcategory: 'Vector Accesories',
        imageUrl: 'assets/products_category/categ1.png'),
    SubCategory(
        category: 'Accesories',
        subcategory: 'Plugs and Plugin Terminal',
        imageUrl: 'assets/products_category/categ1.png'),
    SubCategory(
        category: 'Accesories',
        subcategory: 'Other Accessories',
        imageUrl: 'assets/products_category/categ1.png'),



    SubCategory(
        category: 'Air Release Valve',
        subcategory: 'Air Release Valve',
        imageUrl: 'assets/products_category/categ2.png'),
    SubCategory(
        category: 'Air Release Valve',
        subcategory: 'Brass Air Release Valve',
        imageUrl: 'assets/products_category/categ2.png'),


    SubCategory(
        category: 'Automatic Control Valve',
        subcategory: 'Pressure Reducing Valve',
        imageUrl: 'assets/products_category/categ3.png'),
    SubCategory(
        category: 'Automatic Control Valve',
        subcategory: 'Floating Valve',
        imageUrl: 'assets/products_category/categ3.png'),
    SubCategory(
        category: 'Automatic Control Valve',
        subcategory: 'Check Valve',
        imageUrl: 'assets/products_category/categ3.png'),
    SubCategory(
        category: 'Automatic Control Valve',
        subcategory: 'Pressure Relief Valve',
        imageUrl: 'assets/products_category/categ3.png'),


    SubCategory(
        category: 'Backflow Preventer',
        subcategory: 'Backflow Preventer',
        imageUrl: 'assets/products_category/categ4.png'),


    SubCategory(
        category: 'Balancing Valves',
        subcategory: 'Valves',
        imageUrl: 'assets/products_category/categ5.png'),
    SubCategory(
        category: 'Balancing Valves',
        subcategory: 'Cartridges',
        imageUrl: 'assets/products_category/categ5.png'),
    SubCategory(
        category: 'Balancing Valves',
        subcategory: 'Pressure Independent Control Valve',
        imageUrl: 'assets/products_category/categ5.png'),


    SubCategory(
        category: 'Ball Valves',
        subcategory: 'Brass Ball Valve',
        imageUrl: 'assets/products_category/categ6.png'),
    SubCategory(
        category: 'Ball Valves',
        subcategory: 'Bronze Ball Valve',
        imageUrl: 'assets/products_category/categ6.png'),
    SubCategory(
        category: 'Ball Valves',
        subcategory: 'Long Neck  Ball Valve',
        imageUrl: 'assets/products_category/categ6.png'),


    SubCategory(
        category: 'Check Valve',
        subcategory: 'Swing Check Valve',
        imageUrl: 'assets/products_category/categ7.png'),
    SubCategory(
        category: 'Check Valve',
        subcategory: 'Spring Load Check Valve',
        imageUrl: 'assets/products_category/categ7.png'),
    SubCategory(
        category: 'Check Valve',
        subcategory: 'Dual Plates Check Valve',
        imageUrl: 'assets/products_category/categ7.png'),


    SubCategory(
        category: 'Concentric Butterfly Valve',
        subcategory: 'Wafer Butterfly Valve',
        imageUrl: 'assets/products_category/categ8.png'),
    SubCategory(
        category: 'Concentric Butterfly Valve',
        subcategory: 'Electric Actuator Butterfly Valve',
        imageUrl: 'assets/products_category/categ8.png'),
    SubCategory(
        category: 'Concentric Butterfly Valve',
        subcategory: 'Lug Butterfly Valve',
        imageUrl: 'assets/products_category/categ8.png'),
    SubCategory(
        category: 'Concentric Butterfly Valve',
        subcategory: 'Flanged Concentric Disc',
        imageUrl: 'assets/products_category/categ8.png'),
    SubCategory(
        category: 'Concentric Butterfly Valve',
        subcategory: 'Flanged Concentric Type',
        imageUrl: 'assets/products_category/categ8.png'),
    SubCategory(
        category: 'Concentric Butterfly Valve',
        subcategory: 'Fire Protections Signal FeedBack Butterfly Valve',
        imageUrl: 'assets/products_category/categ8.png'),


    SubCategory(
        category: 'Controller',
        subcategory: 'Omni BEMS Controller',
        imageUrl: 'assets/products_category/categ9.png'),
    SubCategory(
        category: 'Controller',
        subcategory: 'Universal',
        imageUrl: 'assets/products_category/categ9.png'),
    SubCategory(
        category: 'Controller',
        subcategory: 'Intelligent',
        imageUrl: 'assets/products_category/categ9.png'),


    SubCategory(
        category: 'Ecentric Butterfly Valves',
        subcategory: 'Butterfly Valve',
        imageUrl: 'assets/products_category/categ10.png'),
    SubCategory(
        category: 'Ecentric Butterfly Valves',
        subcategory: 'Motorized Butterfly Valve',
        imageUrl: 'assets/products_category/categ10.png'),
    SubCategory(
        category: 'Ecentric Butterfly Valves',
        subcategory: 'Pneumatic Butterfly Valve',
        imageUrl: 'assets/products_category/categ10.png'),


    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Damper Actuator',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Spring Return Damper Actuator',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Electronic Damper Actuator',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Ball Valve Actuator',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Characteized Disc Ball Valve',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Motorized Fan Coil Valve',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Fire and Smoke Damper Actuator',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Butterfly Valve',
        imageUrl: 'assets/products_category/categ11.png'),
    SubCategory(
        category: 'Enye Controls Motorized Valves and Actuators',
        subcategory: 'Digital Actuator',
        imageUrl: 'assets/products_category/categ11.png'),


    SubCategory(
        category: 'Flexible Joint',
        subcategory: 'Rubber Flexible Joint',
        imageUrl: 'assets/products_category/categ12.png'),
    SubCategory(
        category: 'Flexible Joint',
        subcategory: 'SS Expansion Joint',
        imageUrl: 'assets/products_category/categ12.png'),


    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Brass Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Bronze Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Lockable Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Extension Length Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'PN16 Flanged Resilient Seated Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Stem Cap Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Spigot Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Fire Protection Signal Feedback Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),
    SubCategory(
        category: 'Gate Valve',
        subcategory: 'Fire Protection Signal Feedback Gate Valve',
        imageUrl: 'assets/products_category/categ13.png'),


    SubCategory(
        category: 'Globe Valve',
        subcategory: 'Brass Globe Valve',
        imageUrl: 'assets/products_category/categ14.png'),
    SubCategory(
        category: 'Globe Valve',
        subcategory: 'Bronze Globe Valve',
        imageUrl: 'assets/products_category/categ14.png'),


    SubCategory(
        category: 'Plunger Valve',
        subcategory: 'Plunger valve',
        imageUrl: 'assets/products_category/categ15.png'),


    SubCategory(
        category: 'Softwares',
        subcategory: 'Softwares and Utilities',
        imageUrl: 'assets/products_category/categ17.png'),


    SubCategory(
        category: 'Strainer',
        subcategory: 'Y Strainer',
        imageUrl: 'assets/products_category/categ18.png'),
    SubCategory(
        category: 'Strainer',
        subcategory: 'Suction Diffuser',
        imageUrl: 'assets/products_category/categ18.png'),
    SubCategory(
        category: 'Strainer',
        subcategory: 'Basket Strainer',
        imageUrl: 'assets/products_category/categ18.png'),


    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Thermo-Animometer',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Air Meter',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Test Kits',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Thermo-Hygrometer',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Signal Generators',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Data Logger',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Pump',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Aspirator Bulb',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Anemometer',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Manometer',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Pressure Module',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Thermometer',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Pilot Tube',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Pump',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Tachometer',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Balancing Instrument',
        imageUrl: 'assets/products_category/categ19.png'),
    SubCategory(
        category: 'Test Equipments',
        subcategory: 'Windmeter',
        imageUrl: 'assets/products_category/categ19.png'),


    SubCategory(
        category: 'Variable Frequency Drive',
        subcategory: 'F510 Variable Frequency Drive',
        imageUrl: 'assets/products_category/categ20.png'),


    SubCategory(
        category: 'Water Meter',
        subcategory: 'Water Meter',
        imageUrl: 'assets/products_category/categ21.png'),

  ];
}