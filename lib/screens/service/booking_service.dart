import 'dart:math';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../config/config.dart';
import '../../widget/widgets.dart';
import '../screens.dart';

class BookingSystem extends StatefulWidget {
  @override
  _BookingSystemState createState() => _BookingSystemState();
}

class _BookingSystemState extends State<BookingSystem> {
  void initState(){
    super.initState();
    _services = [];
    _ecCalendar = [];
    _getServices();
    _getEcCalendar();

    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
          });
        });
        userSessionFuture = bool;
      } else {
        userSessionFuture = bool;
      }
    });
  }

  clientInfo? ClientInfo;
  bool? userSessionFuture;
  bool disabling = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? name;
  String? address;
  String? mobileNumber;
  String? email;
  List<DateTime> unavailableDates = [];

  String? selectedConcern;
  List<String> availableConcerns = [
    'Repair',
    //'Quotation',
    'Consultation',
    'Other',
  ];

  String? generatedCode;

  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final compnameController = TextEditingController();
  final locationController = TextEditingController();
  final projnameController = TextEditingController();
  final contactController = TextEditingController();

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
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    // Generate a random 6-character alphanumeric ID
    String randomId = String.fromCharCodes(
      List.generate(
          6, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );

    String concern;
    if(selectedConcern == 'Repair'){
      concern = 'RPR';
    } else if(selectedConcern == 'Consultation'){
      concern = 'CONSLT';
    } else if(selectedConcern == 'Other'){
      concern = 'OTHR';
    } else {
      concern = 'SVC';
    }

    generatedCode = '${concern}-${selectedDate?.month}${selectedDate?.day}${selectedDate?.year}$randomId';
  }

  //initialDate configurator kapag naka-disable yung date +1 sa days and so on
  bool selectableDayPredicate(DateTime date) {

    int scheduledServiceCount = _services.where((services) {
      if (services.status != "Cancelled"){
        if(DateTime.parse(services.dateSched).month == date.month
            && DateTime.parse(services.dateSched).day == date.day
            && DateTime.parse(services.dateSched).year == date.year){
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }).length;

    bool isDateDisabled = _ecCalendar.any((CalendarData) {
      DateTime startDate = DateTime.parse(CalendarData.start);
      DateTime endDate = DateTime.parse(CalendarData.end);

      for (DateTime currentDate = startDate;
      currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
      currentDate = currentDate.add(Duration(days: 1))) {
        if (currentDate.month == date.month
            && currentDate.day == date.day
            && currentDate.year == date.year) {
          return true;
        }
      }
      return false;
    });

    if (scheduledServiceCount >= 2){
      return true;
    } else if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return true;
    } else if (isDateDisabled) {
      return true;
    } else {
      return false;
    }
  }

  //datepicker para sa date sched
  late List<CalendarData> _ecCalendar; //get the ec calendar
  DateTime initialDate = DateTime.now().add(Duration(days: 7));
  DateTime firstDate = DateTime.now().add(Duration(days: 5));
  DateTime lastDate = DateTime.now().add(Duration(days: 60));

  _getEcCalendar(){
    CalendarServices.calendarData(
        "${DateFormat('yyyy-MM-dd').format(firstDate)}",
        "${DateFormat('yyyy-MM-dd').format(lastDate)}"
    ).then((CalendarData){
      setState(() {
        _ecCalendar = CalendarData;
      });
      print("Length ${CalendarData.length}");
    });
  }

  Future<void> _selectDate(BuildContext context) async {

    //initialDate configurator kapag naka-disable yung date +1 sa days and so on
    while (selectableDayPredicate(initialDate)) {
      initialDate = initialDate.add(Duration(days: 1));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime date) {
        if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
          return false;
        }

        //this code is from ChatGPT to disable dates came from ec calendar HR
        bool isDateDisabled = _ecCalendar.any((CalendarData) {
          DateTime startDate = DateTime.parse(CalendarData.start);
          DateTime endDate = DateTime.parse(CalendarData.end);

          for (DateTime currentDate = startDate;
          currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate);
          currentDate = currentDate.add(Duration(days: 1))) {
            if (currentDate.isAtSameMomentAs(date)) {
              return true;
            }
          }
          return false;
        });

        if (isDateDisabled) {
          return false;
        }

        //database counting if may sched na disabled na sya
        int scheduledServiceCount = _services.where((services) {
          if (services.status != "Cancelled"){
            return DateTime.parse(services.dateSched).isAtSameMomentAs(date);
          } else {
            return false;
          }
        }).length;
        return scheduledServiceCount < 2;
      }
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _successSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.check, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  _errorSnackbar(context, message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.7,),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(message),
          ],
        ),
      ),
    );
  }

  clearFields(){
    subjectController.clear();
    descriptionController.clear();

    if(ClientInfo?.login == 'GMAIL'){
      compnameController.clear();
      locationController.clear();
      projnameController.clear();
      contactController.clear();
    }

    setState(() {
      selectedDate = null;
      selectedConcern = null;
      generatedCode = null;
    });
  }

  //list of services para lang makuha yung mga date sched na available
  late List<TechnicalData> _services;
  _getServices(){
    TechnicalDataServices.getTechnicalData().then((technicalData){
      setState(() {
        _services = technicalData;
      });
      print("Length ${technicalData.length}");
    });
  }

  //kapag wala pa na-select na date
  String? _dropdownError;
  addBooking() {
    if (_formKey.currentState!.validate()) {
      if(selectedDate == null){
        setState(() => _dropdownError = "Please select a DATE !");
      } else {
        setState(() => _dropdownError = "");
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
                SizedBox(height: 20),
                Text('Date: ${DateFormat.yMMMd().format(DateTime.parse(selectedDate.toString()))}',
                  style: GoogleFonts.lato(
                    textStyle:
                    TextStyle(fontSize: 16, letterSpacing: 0.5),
                  ),
                ),
                SizedBox(height: 5),
                Text('Generated Code: $generatedCode',
                  style: GoogleFonts.lato(
                    textStyle:
                    TextStyle(fontSize: 16, letterSpacing: 0.5),
                  ),
                ),
                SizedBox(height: 5),
                Text('Service: $selectedConcern'),
                SizedBox(height: 5),
                Text('Subject: ${subjectController.text}'),
                SizedBox(height: 5),
                Text('Description: ${descriptionController.text}'),

                ClientInfo?.company_name == ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('Company Name: ${compnameController.text}'),
                    )
                  : SizedBox.shrink(),

                ClientInfo?.location == ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('Location: ${locationController.text}'),
                    )
                  : SizedBox.shrink(),

                ClientInfo?.project_name == ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('Project Name: ${projnameController.text}'),
                    )
                  : SizedBox.shrink(),

                ClientInfo?.contact_no == ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('Contact #: ${contactController.text}'),
                    )
                  : SizedBox.shrink(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (ClientInfo?.login == 'SIGNIN'){
                    TechnicalDataServices.addBooking(
                        generatedCode!, selectedConcern!,
                        subjectController.text, descriptionController.text,
                        selectedDate.toString(), ClientInfo!.client_id,
                        ClientInfo!.name, ClientInfo!.company_name,
                        ClientInfo!.location, ClientInfo!.project_name,
                        ClientInfo!.contact_no, ClientInfo!.email
                    ).then((result) {
                      if('success' == result){
                        sendPushNotifications();
                        _getServices();
                        _successSnackbar(context, "Successfully booked.");
                        clearFields();
                        Navigator.of(context).pop();
                      } else {
                        _errorSnackbar(context, "Error occured...");
                      }
                    });
                  } else if (ClientInfo?.login == 'GMAIL'){
                    TechnicalDataServices.addBooking(
                        generatedCode!, selectedConcern!,
                        subjectController.text, descriptionController.text,
                        selectedDate.toString(), ClientInfo!.client_id,
                        ClientInfo!.name, compnameController.text,
                        locationController.text, projnameController.text,
                        contactController.text, ClientInfo!.email
                    ).then((result) {
                      if('success' == result){
                        sendPushNotifications();
                        _getServices();
                        _successSnackbar(context, "Successfully booked.");
                        clearFields();
                        Navigator.of(context).pop();
                      } else {
                        _errorSnackbar(context, "Error occured...");
                      }
                    });
                  } else {
                    _errorSnackbar(context, "Error occured...");
                  }
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> sendPushNotifications() async {
    //final url = 'https://enye.com.ph/enyecontrols_app/login_user/send1.php'; // Replace this with the URL to your PHP script
    final response = await http.post(
      Uri.parse(API.pushNotif),
      body: {
        'code' : generatedCode,
        'name' : ClientInfo!.name,
        'company' : ClientInfo!.company_name.isEmpty ? compnameController.text : ClientInfo!.company_name,
        'date_sched' : selectedDate.toString(),
      },
    );
    if (response.statusCode == 200) {
      if(response.body == "success"){
        print('send push notifications.');
      }
    } else {
      print('Failed to send push notifications.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
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
                SizedBox(height: 30),
                Center(
                  child: Text(
                    'APPOINTMENT :',
                    style: GoogleFonts.rowdies(
                      textStyle: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black54)
                    )
                  ),
                ),


                SizedBox(height: 30),
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
                          style: GoogleFonts.lato(
                            textStyle:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.8),
                          ),
                        ),
                        Icon(Icons.calendar_today, color: Colors.deepOrange,),
                      ],
                    ),
                  ),
                ),
                _dropdownError == null
                    ? SizedBox.shrink()
                    : Text(
                  _dropdownError ?? "",
                  style: TextStyle(color: Colors.red),
                ),

                SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      SizedBox(height: 8),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonFormField<String>(
                          style: GoogleFonts.lato(
                            textStyle:
                            TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500, letterSpacing: 0.8),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Select Service*',
                            labelStyle: GoogleFonts.lato(
                              textStyle:
                              TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.8),
                            ),
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
                      ),

                      SizedBox(height: 8),
                      Normal2TextField(
                        controller: subjectController,
                        hintText: 'Subject *',
                      ),

                      SizedBox(height: 8),
                      Normal2TextField(
                        controller: descriptionController,
                        hintText: 'Description *',
                      ),

                      ClientInfo?.company_name == ''
                       ? Padding(
                         padding: const EdgeInsets.only(top: 8.0),
                         child: Normal2TextField(
                            controller: compnameController,
                            hintText: 'Company Name *',
                          ),
                       )
                       : SizedBox.shrink(),

                      ClientInfo?.location == ''
                       ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Normal2TextField(
                            controller: locationController,
                            hintText: 'Location *',
                          ),
                        )
                        : SizedBox.shrink(),

                      ClientInfo?.project_name == ''
                       ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Normal2TextField(
                            controller: projnameController,
                            hintText: 'Project Name *',
                          ),
                        )
                       : SizedBox.shrink(),

                      ClientInfo?.contact_no == ''
                       ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ContactTextField(
                            controller: contactController,
                            hintText: 'Contact # *',
                          ),
                        )
                        : SizedBox.shrink(),
                    ],
                  ),
                ),

                SizedBox(height: 40),
                customButton(
                  onTap: () {
                    addBooking();
                  },
                  text: 'BOOK',
                  clr: Colors.deepOrange,
                  fontSize: 18.0,
                ),

                const SizedBox(height: 20,),
                if (isKeyboardVisible) SizedBox(height: MediaQuery.of(context).size.height * 0.4,),
              ],
            ),
          ),
        );
      }
    );
  }
}

