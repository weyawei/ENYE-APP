import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../screens.dart';

Future<Uint8List> pdfBuilderDR() async {
  final pdf = Document();

  pdf.addPage(
    MultiPage(
      pageTheme: PageTheme(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      ),
      header: (context) => Column(
          children: [
            Center(
              child: Column(
                children: [
                  compTextTitle("ENYECONTROLS"),
                  compTextDetails("Blk 4 Lot 10 Agnesville Subd.,"),
                  compTextDetails("Mambugan City Of Antipolo, Rizal"),
                  compTextDetails("Telefax: 352-3251"),
                  compTextDetails("VAT Reg. TIN: 010-033-855-00000")
                ]
              )
            ),

            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "No.: 0004",
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                  color: PdfColor.fromHex("#FF0000"),
                )
              )
            ),

            SizedBox(height: 10),
            Center(
              child: Text(
                "DELIVERY RECEIPT",
                style: TextStyle(
                  fontSize: 11.5,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.bold,
                )
              )
            ),

            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Table(
                        columnWidths: {
                          0: FixedColumnWidth(65),
                          1: FixedColumnWidth(10),
                          2: FixedColumnWidth(210),
                        },
                        children: [
                          TableRow(
                            children: [
                              tableTextTitleStart("Delivered To"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("Carlson Innotech Corp"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart("Address"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("Blk 9 Lot Sto. Nino Ave Vill,"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart(""),
                              tableTextTitleStart(""),
                              tableTextBodyStart("Tunasan Muntinlupa City"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart(""),
                              tableTextTitleStart(""),
                              tableTextBodyStart("-"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart("TIN"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("-"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart("Project Name"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("Sync Y"),
                            ],
                          ),
                        ]
                    ),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Table(
                        columnWidths: {
                          0: FixedColumnWidth(55),
                          1: FixedColumnWidth(10),
                          2: FixedColumnWidth(130),
                        },
                        children: [
                          TableRow(
                            children: [
                              tableTextTitleStart("Date"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("2024-04-26"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart("P.O. No."),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("SYNC-24-06"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart("Terms"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("20% DP, 80% 45 days PDC"),
                            ],
                          ),
                          TableRow(
                            children: [
                              tableTextTitleStart("Delivered To"),
                              tableTextTitleStart(":"),
                              tableTextBodyStart("SITE"),
                            ],
                          ),
                        ]
                    ),
                  ],
                ),
              ],
            ),
          ]
      ),
      build: (context) => [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

          ],
        ),

      ],
    ),

  );
  return pdf.save();
}

Widget compTextTitle(
    final String text, {
      final TextAlign align = TextAlign.center,
    }) =>
    Padding(
      padding: const EdgeInsets.all(3),
      child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold,
          )
      ),
    );

Widget compTextDetails(
    final String text, {
      final TextAlign align = TextAlign.center,
    }) =>
    Padding(
      padding: const EdgeInsets.all(1.5),
      child: Text(
          text,
          textAlign: align,
          style: TextStyle(
            letterSpacing: 0.5,
            fontSize: 8.5,
          )
      ),
    );