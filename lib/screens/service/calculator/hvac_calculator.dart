

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HVACCalcutor extends StatefulWidget {
  const HVACCalcutor({super.key});

  @override
  State<HVACCalcutor> createState() => _HVACCalcutorState();
}

class _HVACCalcutorState extends State<HVACCalcutor> {
  HVACInput input = HVACInput();
  double heatingLoad = 0.0;
  double coolingLoad = 0.0;

  List<String> climateRegions = [
    'Region 1',
    'Region 2',
    'Region 3 - Yellow',
    // Add more regions as needed
  ];

  List<String> hvacSystemTypes = [
    'Cooling Only',
    'Heating Only',
    'Heating and Cooling',
    // Add more HVAC system types as needed
  ];

  List<String> insulationGrades = [
    'Poor (R-5 walls)',
    'Average (R-13 walls)',
    'Good (R-19 walls)',
    // Add more insulation grades as needed
  ];

  List<String> sunExposureLevels = [
    'Low Exposure',
    'Average Exposure',
    'High Exposure',
    // Add more sun exposure levels as needed
  ];

  List<String> windowOptions = [
    'Low Amount',
    'Average Amount',
    'High Amount',
    // Add more window options as needed
  ];

  List<String> airTightnessOptions = [
    'Poor Design',
    'Average Design',
    'Good Design',
    // Add more air tightness options as needed
  ];

  void calculateLoads() {
    // Step 1: Climate Region
    // Define heating and cooling factors based on the selected climate region.
    double heatingFactor = 0.0;
    double coolingFactor = 0.0;
    switch (input.climateRegion) {
      case 'Region 1':
        heatingFactor = 1.0;
        coolingFactor = 1.0;
        break;
      case 'Region 2':
        heatingFactor = 1.2;
        coolingFactor = 1.1;
        break;
      case 'Region 3 - Yellow':
        heatingFactor = 1.3;
        coolingFactor = 1.2;
        break;
    // Add more cases for other regions as needed.
    }

    // Step 2: Area Size
    // Calculate heating and cooling loads based on area size.
    heatingLoad = input.areaSize * 20.0 * heatingFactor; // Example BTU per sq. ft. for heating.
    coolingLoad = input.areaSize * 25.0 * coolingFactor; // Example BTU per sq. ft. for cooling.

    // Step 3: Rooms / Zones
    // Consider the number of rooms/zones.
    heatingLoad *= input.numberOfRooms;
    coolingLoad *= input.numberOfRooms;

    // Step 4: Space Height
    // Adjust loads based on average ceiling height.
    if (input.spaceHeight > 8.0) {
      // For higher ceilings, adjust the load based on volume.
      heatingLoad *= input.spaceHeight / 8.0;
      coolingLoad *= input.spaceHeight / 8.0;
    }

    // Step 5: Insulation Grade
    // Adjust loads based on insulation grade.
    switch (input.insulationGrade) {
      case 'More than Average':
        heatingLoad *= 0.9; // Example adjustment factor for better insulation.
        coolingLoad *= 0.9; // Example adjustment factor for better insulation.
        break;
      case 'Less than Average':
        heatingLoad *= 1.1; // Example adjustment factor for poorer insulation.
        coolingLoad *= 1.1; // Example adjustment factor for poorer insulation.
        break;
      case 'Poorly Insulated':
        heatingLoad *= 1.2; // Example adjustment factor for very poor insulation.
        coolingLoad *= 1.2; // Example adjustment factor for very poor insulation.
        break;
    // You can add more cases for other insulation grades.
    }

    // Step 6: Windows
    // Adjust loads based on the average amount of windows.
    switch (input.windows) {
      case 'More than Average':
        coolingLoad *= 1.1; // Example adjustment factor for more windows.
        break;
    // Add more cases for other window options.
    }

    // Additional adjustments can be made based on Step 6 (Windows/Doors air tightness) if needed.

    // You have now calculated the heating and cooling loads. You can display the results to the user.
    // For demonstration, we will show a dialog with the results.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('HVAC Load Results'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Heating Load: ${heatingLoad.toStringAsFixed(2)} BTU/h'),
              Text('Cooling Load: ${coolingLoad.toStringAsFixed(2)} BTU/h'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog.
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HVAC Calculator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildDropdown(
                'Climate Region',
                input.climateRegion,
                climateRegions,
                    (value) {
                  setState(() {
                    input.climateRegion = value ?? '';
                  });
                },
              ),
              _buildDropdown(
                'HVAC System Type',
                input.hvacSystemType,
                hvacSystemTypes,
                    (value) {
                  setState(() {
                    input.hvacSystemType = value ?? '';
                  });
                },
              ),
              _buildInputField(
                'Area Size (sq. ft.)',
                TextInputType.number,
                    (value) {
                  setState(() {
                    input.areaSize = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              _buildSwitch(
                'Do you have ducts?',
                input.hasDucts,
                    (value) {
                  setState(() {
                    input.hasDucts = value;
                  });
                },
              ),
              _buildDropdown(
                'Insulation Grade',
                input.insulationGrade,
                insulationGrades,
                    (value) {
                  setState(() {
                    input.insulationGrade = value ?? '';
                  });
                },
              ),
              _buildInputField(
                'Rooms (zones)',
                TextInputType.number,
                    (value) {
                  setState(() {
                    input.numberOfRooms = int.tryParse(value) ?? 0;
                  });
                },
              ),
              _buildInputField(
                'Space Height (ft.)',
                TextInputType.number,
                    (value) {
                  setState(() {
                    input.spaceHeight = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              _buildDropdown(
                'Sun Exposure',
                input.sunExposure,
                sunExposureLevels,
                    (value) {
                  setState(() {
                    input.sunExposure = value ?? '';
                  });
                },
              ),
              _buildDropdown(
                'Windows',
                input.windows,
                windowOptions,
                    (value) {
                  setState(() {
                    input.windows = value ?? '';
                  });
                },
              ),
              _buildDropdown(
                'Windows/Doors Air Tightness',
                input.airTightness,
                airTightnessOptions,
                    (value) {
                  setState(() {
                    input.airTightness = value ?? '';
                  });
                },
              ),
              _buildSwitch(
                'Do you have baseboard radiators?',
                input.hasBaseboardRadiators,
                    (value) {
                  setState(() {
                    input.hasBaseboardRadiators = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  calculateLoads(); // Calculate heating and cooling loads.
                  // You can now display the results or navigate to another screen for details.
                  // For demonstration, we will show a dialog with the results.
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('HVAC Load Results'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Heating Load: ${heatingLoad.toStringAsFixed(2)} BTU/h'),
                            Text('Cooling Load: ${coolingLoad.toStringAsFixed(2)} BTU/h'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog.
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildInputField(String label, TextInputType keyboardType, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          keyboardType: keyboardType,
          onChanged: onChanged,
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class HVACInput {
  String climateRegion = 'Region 1';
  String hvacSystemType = 'Cooling Only';
  double areaSize = 0.0;
  bool hasDucts = false;
  String insulationGrade = 'Poor (R-5 walls)';
  int numberOfRooms = 0;
  double spaceHeight = 0.0;
  String sunExposure = 'Low Exposure';
  String windows = 'Low Amount';
  String airTightness = 'Poor Design';
  bool hasBaseboardRadiators = false;
}