import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    //calling session data
    checkSession().getUserSessionStatus().then((bool) {
      if (bool == true) {
        checkSession().getClientsData().then((value) {
          setState(() {
            ClientInfo = value;
            clientNameController.text = ClientInfo!.name.toString();
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
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  String? name;
  String? address;
  String? mobileNumber;
  String? email;
  List<DateTime> unavailableDates = [];


  bool isChecked = true;
  bool isTextFieldEnabled = false;
  RemoteMessage message = RemoteMessage();

  String? selectedConcern;
  List<String> availableConcerns = [
    'Presentation/Consultation',
    'Survey',
    'Installation',
    //'Quotation',
    'Technical Support',
    'Technical Meeting',
    'Other',
  ];





  String? generatedCode;

  final clientNameController = TextEditingController();
  final clientPositionController = TextEditingController();
  final subjectController = TextEditingController();
  final descriptionController = TextEditingController();
  final compnameController = TextEditingController();
  final locationController = TextEditingController();
  final projnameController = TextEditingController();
  final contactController = TextEditingController();
  final clientRemarksController = TextEditingController();

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


  File? filePath;
  String? fileName;
  String? fileData;
  String? showData;
  ImagePicker imagePicker = ImagePicker();

  Future<void> selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = File(result.files.single.path!);
        fileName = result.files.single.name;
        fileData = base64Encode(filePath!.readAsBytesSync());
        print(filePath);
      });
    }
  }


  void generateCode() {
    final random = Random();
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    // Generate a random 6-character alphanumeric ID
    String randomId = String.fromCharCodes(
      List.generate(
          4, (index) => chars.codeUnitAt(random.nextInt(chars.length))),
    );

    String concern;
    if(selectedConcern == 'Presentation/Consultation'){
      concern = 'PRST';
    } else if(selectedConcern == 'Survey'){
      concern = 'SRVY';
    } else if(selectedConcern == 'Installation'){
      concern = 'INTS';
    } else if(selectedConcern == 'Technical Support'){
      concern = 'TS';
    } else if(selectedConcern == 'Technical Meeting'){
      concern = 'TM';
    } else if(selectedConcern == 'Other'){
      concern = 'OTHR';
    } else {
      concern = 'SVC';
    }

    generatedCode = '${concern}-${selectedDate.month}${selectedDate.day}${selectedDate.year}$randomId';
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

  clearFields(){
    subjectController.clear();
    descriptionController.clear();
    clientPositionController.clear();
    clientRemarksController.clear();
    compnameController.clear();
    locationController.clear();
    projnameController.clear();
    filePath = null;


    if(ClientInfo?.login == 'GMAIL' || ClientInfo?.login == 'APPLE'){
      contactController.clear();
    }

    setState(() {
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

  bool isLoading = false;
  void addBooking() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    if (_formKey.currentState!.validate()) {
      generateCode();
      showDialog(
        context: context,
        builder: (context) {
          bool isLoading = false;

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(
                  'CONFIRMATION',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rowdies(
                    textStyle: TextStyle(
                        fontSize: fontExtraSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        letterSpacing: 0.8),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'You have booked the following appointment:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Date Booked: ${DateFormat.yMMMd().format(DateTime.parse(selectedDate.toString()))}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Generated Code: $generatedCode',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Service: $selectedConcern',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Subject: ${subjectController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Requestor: ${clientNameController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Designated Position: ${clientPositionController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Problem/Concern: ${descriptionController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        'Remarks: ${clientRemarksController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8),
                        ),
                      ),
                      ClientInfo?.name == '' || ClientInfo?.name == null
                          ? Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.008),
                        child: Text(
                          'Name: ${clientNameController.text}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: fontNormalSize,
                                color: Colors.black,
                                letterSpacing: 0.8),
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.008),
                        child: Text(
                          'Company Name: ${compnameController.text}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: fontNormalSize,
                                color: Colors.black,
                                letterSpacing: 0.8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.008),
                        child: Text(
                          'Location: ${locationController.text}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: fontNormalSize,
                                color: Colors.black,
                                letterSpacing: 0.8),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.008),
                        child: Text(
                          'Project Name: ${projnameController.text}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: fontNormalSize,
                                color: Colors.black,
                                letterSpacing: 0.8),
                          ),
                        ),
                      ),
                      ClientInfo?.contact_no == ''
                          ? Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.008),
                        child: Text(
                          'Contact #: ${contactController.text}',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: fontNormalSize,
                                color: Colors.black,
                                letterSpacing: 0.8),
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: isLoading ? null : () async {
                      setState(() {
                        isLoading = true;
                      });

                      final String contactNumber = (ClientInfo?.login == 'SIGNIN' || ClientInfo?.login == 'APPLE')
                          ? ClientInfo!.contact_no
                          : contactController.text;

                      String result = await TechnicalDataServices.addBooking(
                        generatedCode!,
                        selectedConcern!,
                        subjectController.text,
                        descriptionController.text,
                        clientNameController.text,
                        clientPositionController.text,
                        clientRemarksController.text,
                        selectedDate.toString(),
                        ClientInfo!.client_id,
                        ClientInfo!.name,
                        compnameController.text,
                        locationController.text,
                        projnameController.text,
                        contactNumber,
                        ClientInfo!.email,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (result == 'success') {
                        custSnackbar(context, "Successfully booked.", Colors.green, Icons.check, Colors.greenAccent);
                        clearFields();
                        Navigator.of(context).pop();
                      } else {
                        custSnackbar(context, "Error occurred...", Colors.redAccent, Icons.dangerous_rounded, Colors.white);
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      'OK',
                      style: GoogleFonts.rowdies(
                        textStyle: TextStyle(
                            fontSize: fontExtraSize,
                            color: Colors.deepOrange,
                            letterSpacing: 0.8),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
        return Scaffold(
          appBar: CustomAppBar(title: 'Appointment', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05),
          resizeToAvoidBottomInset: true,
          body: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: DropdownButtonFormField<String>(
                        style: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8
                        ),
                        decoration: InputDecoration(
                          labelText: 'Select Service*',
                          labelStyle: TextStyle(
                            fontSize: fontNormalSize,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8
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

                    SizedBox(height: screenHeight * 0.01),
                    Normal2TextField(
                      controller: subjectController,
                      hintText: 'Subject *',
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: EnDisABLETextField(
                        controller: clientNameController,
                        hintText: 'Name of Requestor *',
                        enDisABLE: isTextFieldEnabled,
                      ),
                    ),

                    ClientInfo?.login == 'APPLE'
                    ? SizedBox.shrink()
                    : CheckboxListTile(
                      title: Text(
                        "Or use the Account Name registered",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontSmallSize,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.8,
                              color: Colors.black54
                          ),
                        ),
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          if (isChecked) {
                            // Set the text from ClientInfo and disable the TextField
                            clientNameController.text = ClientInfo?.name.toString() ?? '';
                            isTextFieldEnabled = false;
                          } else {
                            // Clear the text and enable the TextField
                            clientNameController.text = '';
                            isTextFieldEnabled = true;
                          }
                        });
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Normal2TextField(
                        controller: compnameController,
                        hintText: 'Company Name *',
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Normal2TextField(
                        controller: locationController,
                        hintText: 'Location *',
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Normal2TextField(
                        controller: projnameController,
                        hintText: 'Project Name *',
                      ),
                    ),

                    ClientInfo?.contact_no == ''
                    ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ContactTextField(
                        controller: contactController,
                        hintText: 'Contact # *',
                      ),
                    )
                    : SizedBox.shrink(),

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child:Normal2TextField(
                      controller: clientPositionController,
                      hintText: 'Designated Position *',
                    ),
                    ),

                    SizedBox(height: screenHeight * 0.01),
                    Normal2TextField(
                        controller: descriptionController,
                        hintText: 'Problem/Concern *',
                      ),


                    SizedBox(height: screenHeight * 0.01),
                    NormalNotRequiredTextField(
                      controller: clientRemarksController,
                      hintText: 'Remarks *',
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: customButton(
                  onTap: () {
                    addBooking();
                  },
                  text: 'BOOK',
                  clr: Colors.deepOrange,
                  fontSize: fontExtraSize,
                ),
              ),

              SizedBox(height: screenHeight * 0.02,),
              if (isKeyboardVisible) SizedBox(height: screenHeight * 0.4,),
            ],
          ),
        );
      }
    );
  }
}