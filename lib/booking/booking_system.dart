import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BookingSystem extends StatefulWidget {
  @override
  _BookingSystemState createState() => _BookingSystemState();
}

class _BookingSystemState extends State<BookingSystem> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? name;
  String? address;
  String? mobileNumber;
  final Uuid _uuid = Uuid();
  List<DateTime> availableDates = [
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
  ];
  List<TimeOfDay> availableTimes = [
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
    TimeOfDay(hour: 18, minute: 0),
  ];

  String? selectedConcern;
  List<String> availableConcerns = [
    'Repair',
    'Quotation',
    'Other',
  ];

  String? customConcern;
  String? generatedCode;

  void generateCode() {
    // Generate the code based on your desired logic
    // Example: Concatenate the selected date and time
    final formattedDate = selectedDate!.toString().split(' ')[0];
    final formattedTime = selectedTime!.format(context);
    final uniqueId = _uuid.v4();
    generatedCode = '$formattedDate - $formattedTime - $uniqueId';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking System'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Select a date:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.toString().split(' ')[0]}'
                          : 'Select a date',
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select a time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<TimeOfDay>(
              decoration: InputDecoration(
                labelText: 'Time',
              ),
              value: selectedTime,
              items: availableTimes.map((time) {
                final formattedTime = time.format(context);
                return DropdownMenuItem<TimeOfDay>(
                  value: time,
                  child: Text(formattedTime),
                );
              }).toList(),
              onChanged: (time) {
                setState(() {
                  selectedTime = time;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address',
              ),
              onChanged: (value) {
                setState(() {
                  address = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Mobile Number',
              ),
              onChanged: (value) {
                setState(() {
                  mobileNumber = value;
                });
              },
            ),

            SizedBox(height: 20),
            Text(
              'Select a concern:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Concern',
              ),
              value: selectedConcern,
              items: availableConcerns.map((concern) {
                return DropdownMenuItem<String>(
                  value: concern,
                  child: Text(concern),
                );
              }).toList(),
              onChanged: (concern) {
                setState(() {
                  selectedConcern = concern;
                });
              },
            ),

            if (selectedConcern == 'Other')
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Specify your concern',
                ),
                onChanged: (value) {
                  setState(() {
                    customConcern = value;
                  });
                },
              ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDate != null &&
                    selectedTime != null &&
                    name != null &&
                    address != null &&
                    mobileNumber != null) {
                  generateCode();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirmation'),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('You have booked the following appointment:'),
                          SizedBox(height: 10),
                          Text('Date: ${selectedDate!.toString().split(' ')[0]}'),
                          Text('Time: ${selectedTime!.format(context)}'),
                          if (selectedConcern != null && selectedConcern != 'Other')
                            Text('Concern: $selectedConcern'),
                          if (selectedConcern == 'Other' && customConcern != null)
                            Text('Concern: $customConcern'),
                          Text('Generated Code: $generatedCode'),
                          Text('Name: $name'),
                          Text('Address: $address'),
                          Text('Mobile Number: $mobileNumber'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              selectedDate = null;
                              selectedTime = null;
                              selectedConcern = null;
                              customConcern = null;
                              generatedCode = null;
                              name = null;
                              address = null;
                              mobileNumber = null;
                            });
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill in all the fields.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Book'),
            ),
          ],
        ),
      ),
    );
  }
}
