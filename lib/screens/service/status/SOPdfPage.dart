import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';
import 'SOPdf_helper.dart';

class SOPdfPreviewPage extends StatefulWidget {
  final ServiceOrder serviceOrder;
  const SOPdfPreviewPage({Key? key, required this.serviceOrder}) : super(key: key);

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

  List<ServiceOrder> _serviceOrder = [];
  _getServiceOrder(){
    TechnicalDataServices.getServiceOrderData(widget.serviceOrder.id).then((getServiceOrder) {
      setState(() {
        _serviceOrder = getServiceOrder;
        if (_serviceOrder.isNotEmpty) {
          _getUsers(_serviceOrder[0].serviceBy);
          _getServices(_serviceOrder[0].svc_id);
        } else {
          // Handle the case where no SO numbers are retrieved.
          _isLoading = false;
          print("No service order numbers retrieved");
        }
      });
    });
  }

  List<UserAdminData2> _users = [];
  _getAccounts(String servicedBy){
    TechnicalDataServices.handlerData2().then((UserAdminData){
      setState(() {
        _users = UserAdminData.where((account) => account.user_id == servicedBy).toList();
      });
    });
  }

  List<UsersInfo> _users2 = [];
  _getUsers(String servicedBy){
    TechnicalDataServices.getUsersInfo().then((accountInfo){
      setState(() {
        _users2 = accountInfo.where((account) => account.user_id == servicedBy).toList();
      });
    });
  }

  List<TechnicalData> _services = [];
  _getServices(String svcId){
    TechnicalDataServices.getTechnicalData().then((technicalData){
      setState(() {
        _services = technicalData.where((service) => service.id == svcId).toList();
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
          pdfFileName: "SO_${_serviceOrder[0].so_no}-${_services[0].clientProjName}.pdf",
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfBuilderSO(_serviceOrder[0], _users2[0], _services[0]),
        ),
      ),
    );
  }
}