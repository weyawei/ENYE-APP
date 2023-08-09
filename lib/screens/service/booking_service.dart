import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../screens.dart';

class BookingSystem extends StatefulWidget {
  @override
  _BookingSystemState createState() => _BookingSystemState();
}

class _BookingSystemState extends State<BookingSystem> {
  void initState(){
    super.initState();
    _services = [];
    _getServices();
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? name;
  String? address;
  String? mobileNumber;
  String? email;
  final Uuid _uuid = Uuid();
  List<DateTime> unavailableDates = [];

  String? selectedConcern;
  List<String> availableConcerns = [
    'Repair',
    //'Quotation',
    'Consultation',
    'Other',
  ];

  String? customConcern;
  String? generatedCode;

  final _formKey = GlobalKey<FormState>();

  /* void generateCode() {
    // Generate the code based on your desired logic
    // Example: Concatenate the selected date and time
    final formattedDate = selectedDate!.toString().split(' ')[0];
    final formattedTime = selectedTime!.format(context);
    final uniqueId = _uuid.v4();
   // generatedCode = '$uniqueId';
    generatedCode = '${name ?? 'Unknown'}${selectedDate?.day}${selectedDate?.month}$uniqueId';
    //generatedCode = '$formattedDate - $formattedTime - $uniqueId';
  }*/

  void generateCode() {
    final random = Random();
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

    // Generate a random 6-character alphanumeric ID
    String randomId = String.fromCharCodes(
      List.generate(
          6, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    generatedCode = '${name ?? 'Unknown'}${selectedDate?.month}${selectedDate?.day}$randomId';
  }

  Map<DateTime, int> bookingCountMap = {};

  bool isBookingAvailable(DateTime date) {
    if (bookingCountMap.containsKey(date)) {
      int count = bookingCountMap[date]!;
      return count < 2; // para sa limit ng booking
    }
    return true;
  }

  void incrementBookingCount(DateTime date) {
    if (bookingCountMap.containsKey(date)) {
      int count = bookingCountMap[date]!;
      bookingCountMap[date] = count + 1;
    } else {
      bookingCountMap[date] = 1;
    }
  }

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(Duration(days: 5)),
      firstDate: DateTime.now().add(Duration(days: 5)),
      lastDate: DateTime.now().add(Duration(days: 60)),
      selectableDayPredicate: (DateTime date) {
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          return false;
        }

        //database counting if may sched na disabled na sya
        int scheduledServiceCount = _services.where((services) {
          return DateTime.parse(services.dateSched).isAtSameMomentAs(date);
        }).length;
        return scheduledServiceCount < 2;
      }
    );
    if (picked != null) {
      if (isBookingAvailable(picked)) {
        incrementBookingCount(picked);
        setState(() {
          selectedDate = picked;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Booking Unavailable'),
            content: Text('Sorry, all slots for this date are booked.'),
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
    }
  }

  late List<TechnicalData> _services;
  _getServices(){
    TechnicalDataServices.getTechnicalData().then((technicalData){
      setState(() {
        _services = technicalData;
      });
      print("Length ${technicalData.length}");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking System'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Center(
              child: Text(
                'APPOINTMENT:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(10.0),
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
                          : 'Select Date*',
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: mobileNumberController,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number*',
                    ),
                    onChanged: (value) {
                      setState(() {
                        mobileNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a mobile number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Service*',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a service';
                }
                return null;
              },
            ),
            if (selectedConcern == 'Other')
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Specify here...',
                ),
                onChanged: (value) {
                  setState(() {
                    customConcern = value;
                  });
                },
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    selectedDate != null &&
                    selectedTime != null &&
                    selectedConcern != null) {
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
                            Text('Service: $customConcern'),
                          Text('Generated Code: $generatedCode'),
                          Text('Name: $name'),
                          Text('Address: $address'),
                          Text('Mobile Number: $mobileNumber'),
                          Text('Email: $email'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            nameController.clear();
                            addressController.clear();
                            mobileNumberController.clear();
                            emailController.clear();
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
                              email = null;
                            });
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                  await sendPushNotifications();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Incomplete Form'),
                      content: Text('Please fill in all the required fields.'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await sendPushNotifications();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 12.0,
                ),

                child: Text(
                  'Book',
                  style: TextStyle(fontSize: 18.0),
                ),

              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.deepOrangeAccent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Future<void> sendPushNotifications() async {
  final url = 'https://enye.com.ph/enyecontrols_app/login_user/send1.php'; // Replace this with the URL to your PHP script
  final response = await http.post(Uri.parse(url));
  if (response.statusCode == 200) {
    print('Push notifications sent successfully!');
  } else {
    print('Failed to send push notifications.');
  }
}