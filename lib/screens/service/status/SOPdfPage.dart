import 'package:enye_app/screens/service/ec_technical_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';
import '../ec_technical_svc.dart';
import 'SOPdf_helper.dart';

class SOPdfPreviewPage extends StatefulWidget {
  final String so_id;
  const SOPdfPreviewPage({Key? key, required this.so_id}) : super(key: key);

  @override
  State<SOPdfPreviewPage> createState() => _SOPdfPreviewPageState();
}

class _SOPdfPreviewPageState extends State<SOPdfPreviewPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    _getServiceOrder();
  }

  bool _isLoading = true;

  List<EcSO> _serviceOrder = [];
  _getServiceOrder(){
    ECTechnicalDataServices.getEcSOPDF(widget.so_id).then((getServiceOrder) {
      setState(() {
        _serviceOrder = getServiceOrder;
        if (_serviceOrder.isNotEmpty) {
          _getAccounts(_serviceOrder[0].service_by);
          _getTsis(_serviceOrder[0].tsis_id);
        } else {
          // Handle the case where no SO numbers are retrieved.
          _isLoading = false;
          print("No service order numbers retrieved");
        }
      });
    });
  }

  List<EcUsers> _users = [];
  _getAccounts(String serviced_by){
    ECTechnicalDataServices.getEcUsers().then((ecUsers){
      setState(() {
        _users = ecUsers.where((account) => _isUserAssigned(serviced_by, account.username)).toList();
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


  List<UsersInfo> _users2 = [];
  _getUsers(String servicedBy){
    TechnicalDataServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users2 = accountInfo.where((account) => account.user_id == servicedBy).toList();
      });
    });
  }

  List<EcTSIS> _services = [];
  _getTsis(String TsisId){
    ECTechnicalDataServices.getEcTSIS().then((ecTsis){
      setState(() {
        _services = ecTsis.where((service) => service.tsis_id == TsisId).toList();
        _isLoading = false;
      });
    });
  }


  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return _isLoading
        ? Center(child: SpinningContainer(controller: _controller),)
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
          pdfFileName: "SO_${_serviceOrder[0].so_no}-${_services[0].project}.pdf",
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfBuilderSO(_serviceOrder[0], _users[0].signature, _services[0]),
        ),
      ),
    );
  }
}