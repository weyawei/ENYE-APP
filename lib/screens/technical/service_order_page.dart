
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';

import '../../widget/widgets.dart';
import '../screens.dart';

class ServiceOrderPage extends StatefulWidget {
  final String so_id;
  const ServiceOrderPage({Key? key, required this.so_id}) : super(key: key);

  @override
  State<ServiceOrderPage> createState() => _ServiceOrderPageState();
}

class _ServiceOrderPageState extends State<ServiceOrderPage> {

  @override
  void initState() {
    super.initState();

    _getServiceOrder();
  }

  bool _isLoadingTSIS = true;
  bool _isLoadingEngineer = true;

  List<EcSO> _serviceOrder = [];
  _getServiceOrder(){
    EngineeringServices.getSObyID(widget.so_id).then((getServiceOrder) {
      setState(() {
        _serviceOrder = getServiceOrder;
        if (_serviceOrder.isNotEmpty) {
          _getEngAccounts(_serviceOrder[0].service_by);
          _getTsis(_serviceOrder[0].tsis_id);
        } else {
          // Handle the case where no SO numbers are retrieved.
          _isLoadingTSIS = false;
          _isLoadingEngineer = false;
          print("No service order numbers retrieved");
        }
      });
    });
  }

  late List<EcUsers> _engUsers;
  _getEngAccounts(String serviced_by){
    EngineeringServices.getEngineeringUsers().then((EcUsers){
      setState(() {
        _engUsers = EcUsers.where((account) => _isUserAssigned(serviced_by, account.username)).toList();
        _isLoadingEngineer = false;
      });
    });
  }

  bool _isUserAssigned(String usersInCharge, String userId) {
    if (usersInCharge != null || usersInCharge != "") {
      List<String> userInChargeList = usersInCharge.split(',').map((e) => e.trim()).toList();
      return userInChargeList.contains(userId);
    }

    return false;
  }

  List<EngTSIS> _tsis = [];
  _getTsis(String tsis_id){
    EngineeringServices.getTSISbyID(tsis_id).then((TSIS){
      setState(() {
        _tsis = TSIS;
        _isLoadingTSIS = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return _isLoadingTSIS || _isLoadingEngineer
    ? Center(child: CircularProgressIndicator(),)
    : Scaffold(
      appBar: AppBar(
        title: Text(
          "SO# ${_serviceOrder[0].so_no}",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: fontNormalSize,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: Colors.white
            ),
          ),
        ),
      ),
      body: InteractiveViewer(
        panEnabled: false,
        boundaryMargin: const EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
        child: PdfPreview(
          pdfFileName: "SO_${_serviceOrder[0].so_no}-${_tsis[0].project}.pdf",
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => ServiceOrderPDFBuilder(_serviceOrder[0], _tsis[0], _engUsers.isEmpty? '' : _engUsers[0].signature),
        ),
      ),
    );
  }
}