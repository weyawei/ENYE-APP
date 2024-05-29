import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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

  _custSnackbar(context, message, Color color, IconData iconData){
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        content: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: (screenHeight + screenWidth) / 75,
            ),
            SizedBox(width: screenWidth * 0.01,),
            Text(
              message.toString().toUpperCase(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: fontNormalSize,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearFields(){
    subjectController.clear();
    descriptionController.clear();
    clientNameController.clear();
    clientPositionController.clear();
    clientRemarksController.clear();
    filePath = null;


    if(ClientInfo?.login == 'GMAIL' || ClientInfo?.login == 'APPLE'){
      compnameController.clear();
      locationController.clear();
      projnameController.clear();
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

  //kapag wala pa na-select na date
  String? _dropdownError;
  addBooking() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);

    if (_formKey.currentState!.validate()) {
        generateCode();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'CONFIRMATION',
              textAlign: TextAlign.center,
              style: GoogleFonts.rowdies(
                textStyle: TextStyle(
                    fontSize: fontExtraSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    letterSpacing: 0.8
                ),
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
                          letterSpacing: 0.8
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text('Date Booked: ${DateFormat.yMMMd().format(DateTime.parse(selectedDate.toString()))}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.black,
                        letterSpacing: 0.8
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text('Generated Code: $generatedCode',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Service: $selectedConcern',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Subject: ${subjectController.text}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),


                SizedBox(height: screenHeight * 0.008),
                Text(
                  'Requestor: ${clientNameController.text}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.black,
                        letterSpacing: 0.8
                    ),
                  ),
                ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Designated Position: ${clientPositionController.text}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    'Problem/Concern: ${descriptionController.text}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),

                SizedBox(height: screenHeight * 0.008),
                Text(
                  'Remarks: ${clientRemarksController.text}',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: fontNormalSize,
                        color: Colors.black,
                        letterSpacing: 0.8
                    ),
                  ),
                ),

              //    SizedBox(height: screenHeight * 0.05),






                ClientInfo?.name == '' || ClientInfo?.name == null
                ? Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.008),
                  child: Text(
                    'Name: ${clientNameController.text}',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: fontNormalSize,
                          color: Colors.black,
                          letterSpacing: 0.8
                      ),
                    ),
                  ),
                )
                : SizedBox.shrink(),

                ClientInfo?.company_name == ''
                  ? Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.008),
                      child: Text(
                        'Company Name: ${compnameController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

                ClientInfo?.location == ''
                  ? Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.008),
                      child: Text(
                        'Location: ${locationController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

                ClientInfo?.project_name == ''
                  ? Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.008),
                      child: Text(
                        'Project Name: ${projnameController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

                ClientInfo?.contact_no == ''
                  ? Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.008),
                      child: Text(
                        'Contact #: ${contactController.text}',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              fontSize: fontNormalSize,
                              color: Colors.black,
                              letterSpacing: 0.8
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

                      SizedBox(height: screenHeight * 0.03),
                  Column(
                    children: [
                      if (filePath != null || (showData != null && showData!.isNotEmpty))
                        InkWell(
                          onTap: () {
                            if (disabling != false) {
                              selectFile();
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if ((filePath != null && _isImage(filePath!.path)) ||
                                  (showData != null && showData!.isNotEmpty && _isImage(showData!)))
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: (filePath != null && _isImage(filePath!.path))
                                      ? FileImage(filePath!)
                                      : (showData != null && showData!.isNotEmpty && _isImage(showData!))
                                      ? FileImage(File(API.clientsImages + showData!))
                                      : null,
                                  child: null,
                                ),
                              
                            ],
                          ),
                        ),
                      if (filePath != null || (showData != null && showData!.isNotEmpty))
                        SizedBox(height: 8), // Add some space between the avatar and the text
                      if (filePath != null || (showData != null && showData!.isNotEmpty))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (filePath != null && !_isImage(filePath!.path))
                              Icon(Icons.insert_drive_file, color: Colors.deepOrange, size: 24)
                            else if (showData != null && !_isImage(showData!))
                              Icon(Icons.insert_drive_file, color: Colors.deepOrange, size: 24),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                filePath != null ? filePath!.path.split('/').last : showData!.split('/').last,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fontNormalSize,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          "No Attachment",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),

                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (ClientInfo?.login == 'SIGNIN'){
                    TechnicalDataServices.addBooking(
                        generatedCode!, selectedConcern!,
                        subjectController.text, descriptionController.text,
                        clientNameController.text, clientPositionController.text,
                        clientRemarksController.text, fileName.toString(), fileData.toString(),
                        selectedDate.toString(), ClientInfo!.client_id,
                        ClientInfo!.name, ClientInfo!.company_name,
                        ClientInfo!.location, ClientInfo!.project_name,
                        ClientInfo!.contact_no, ClientInfo!.email
                    ).then((result) {
                      if('success' == result){
                        sendPushNotifications();
                        _getServices();
                        _custSnackbar(
                          context,
                          "Successfully booked.",
                          Colors.green,
                          Icons.check_box
                        );
                        clearFields();
                        Navigator.of(context).pop();

                      } else {
                        _custSnackbar(
                            context,
                            "Error occured...",
                            Colors.redAccent,
                            Icons.dangerous_rounded
                        );
                      }
                    });
                  } else if (ClientInfo?.login == 'GMAIL'){
                    TechnicalDataServices.addBooking(
                        generatedCode!, selectedConcern!,
                        subjectController.text, descriptionController.text,
                        clientNameController.text, clientPositionController.text,
                        clientRemarksController.text, fileName.toString(), fileData.toString(),
                        selectedDate.toString(), ClientInfo!.client_id,
                        ClientInfo!.name, compnameController.text,
                        locationController.text, projnameController.text,
                        contactController.text, ClientInfo!.email
                    ).then((result) {
                      if('success' == result){
                        sendPushNotifications();
                        _getServices();
                        _custSnackbar(
                            context,
                            "Successfully booked.",
                            Colors.green,
                            Icons.check_box
                        );
                        clearFields();
                        Navigator.of(context).pop();

                      } else {
                        _custSnackbar(
                            context,
                            "Error occured...",
                            Colors.redAccent,
                            Icons.dangerous_rounded
                        );
                      }
                    });
                  } else if (ClientInfo?.login == 'APPLE'){
                    TechnicalDataServices.addBooking(
                        generatedCode!, selectedConcern!,
                        subjectController.text, descriptionController.text,
                        clientNameController.text, clientPositionController.text,
                        clientRemarksController.text, fileName.toString(), fileData.toString(),
                        selectedDate.toString(), ClientInfo!.client_id,
                        clientNameController.text, compnameController.text,
                        locationController.text, projnameController.text,
                        contactController.text, ClientInfo!.email
                    ).then((result) {
                      if('success' == result){
                        sendPushNotifications();
                        _getServices();
                        _custSnackbar(
                            context,
                            "Successfully booked.",
                            Colors.green,
                            Icons.check_box
                        );
                        clearFields();
                        Navigator.of(context).pop();

                      } else {
                        _custSnackbar(
                            context,
                            "Error occured...",
                            Colors.redAccent,
                            Icons.dangerous_rounded
                        );
                      }
                    });
                  } else {
                    _custSnackbar(
                        context,
                        "Error occured...",
                        Colors.redAccent,
                        Icons.dangerous_rounded
                    );
                  }
                },
                child: Text(
                  'OK',
                  style: GoogleFonts.rowdies(
                    textStyle: TextStyle(
                        fontSize: fontExtraSize,
                        color: Colors.deepOrange,
                        letterSpacing: 0.8
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

    Future<void> sendPushNotifications() async {
    //final url = 'https://enye.com.ph/enyecontrols_app/login_user/send1.php'; // Replace this with the URL to your PHP script
    String name = clientNameController.text;

    final response = await http.post(
      Uri.parse(API.pushNotif),
      body: {
        'action' : 'Booking',
        'code' : generatedCode,
        'name' : name,
        'company' : ClientInfo!.company_name.isEmpty ? compnameController.text : ClientInfo!.company_name,
        'date_booked' : selectedDate.toString(),
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontExtraSize = ResponsiveTextUtils.getExtraFontSize(screenWidth);
    var fontXXSize = ResponsiveTextUtils.getXXFontSize(screenWidth);

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible){
        return Scaffold(
          appBar: CustomAppBar(title: 'Booking System', imagePath: '', appBarHeight: MediaQuery.of(context).size.height * 0.05),
          resizeToAvoidBottomInset: true,
          body: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              SizedBox(height: screenHeight * 0.05),
              Center(
                child: Text(
                  'APPOINTMENT :',
                  style: GoogleFonts.rowdies(
                    textStyle: TextStyle(
                      fontSize: fontXXSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                    )
                  )
                ),
              ),


              SizedBox(height: screenHeight * 0.05),
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: DropdownButtonFormField<String>(
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: fontExtraSize,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8
                          ),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Select Service*',
                          labelStyle: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: fontExtraSize,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8
                            ),
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
                    Normal2TextField(
                      controller: clientRemarksController,
                      hintText: 'Remarks *',
                    ),


                    SizedBox(height: screenHeight * 0.05),
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            if(disabling != true){
                              selectFile();
                            }
                          },
                          child: Stack(
                            children: [
                              if (filePath != null && _isImage(filePath!.path))
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage: FileImage(filePath!),
                                )
                              else if (showData != null && showData!.isNotEmpty && _isImage(showData!))
                                CircleAvatar(
                                  radius: 64,
                                  backgroundImage: FileImage(File(API.clientsImages + showData!)),
                                )
                              else
                                CircleAvatar(
                                  radius: 64,
                                  foregroundColor: Colors.deepOrange,
                                  child: Icon(Icons.insert_drive_file, color: Colors.deepOrange, size: 50),
                                ),
                              if (!disabling)
                                Positioned(
                                  bottom: 2,
                                  left: 90,
                                  child: Icon(Icons.add_a_photo, color: Colors.deepOrange),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8), // Add some space between the avatar and the text
                        Text(
                          filePath != null ? filePath!.path.split('/').last : "Attach file", // Display file name if file is selected
                          style: TextStyle(
                            fontSize: 14, // Adjust font size as needed
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                            color: Colors.black54,
                          ),
                        ),
                      ],
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

// Function to check if a file path represents an image
bool _isImage(String filePath) {
  final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
  final ext = filePath.split('.').last.toLowerCase();
  return imageExtensions.contains(ext);
}