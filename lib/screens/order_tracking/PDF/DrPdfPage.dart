import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import '../../../widget/widgets.dart';
import '../../screens.dart';

class DrPdfPreviewPage extends StatefulWidget {
  final String dr_no;
  const DrPdfPreviewPage({Key? key, required this.dr_no}) : super(key: key);

  @override
  State<DrPdfPreviewPage> createState() => _DrPdfPreviewPageState();
}

class _DrPdfPreviewPageState extends State<DrPdfPreviewPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DR# ${widget.dr_no}",
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
          pdfFileName: "DR_${widget.dr_no}.pdf",
          loadingWidget: const CupertinoActivityIndicator(),
          build: (context) => pdfBuilderDR(),
        ),
      ),
    );
  }
}