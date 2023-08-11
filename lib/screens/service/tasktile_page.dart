import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../screens.dart';

class TaskTile extends StatefulWidget {
  final TechnicalData services;
  const TaskTile({super.key, required this.services});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  List<UserAdminData> _handler = [];

  _getServices(){
    if (widget.services.status != "Unread") {
      TechnicalDataServices.handlerData(widget.services.svcHandler).then((
          UserAdminData) {
        setState(() {
          _handler = UserAdminData;
        });
        print("Length ${UserAdminData.length}");
      });
    }
  }

  @override
  void initState(){
    super.initState();
    _getServices();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getStatusColor(widget.services.status),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${widget.services.svcId}",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

                SizedBox(height: 12,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "${widget.services.service} - ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                      ),),
                    TextSpan(text: "(${widget.services.svcTitle})",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                  ]
                  ),
                ),

                SizedBox(height: 12,),
                RichText(
                  softWrap: true,
                  text: TextSpan(children:
                  [
                    TextSpan(text: "Description : ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                    TextSpan(text: "${widget.services.svcDesc}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                  ]
                  ),
                ),

                SizedBox(height: 12,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    SizedBox(width: 4),
                    Text(
                      DateFormat.yMMMd().format(DateTime.parse(widget.services.dateSched)),
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 15, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),

                //handler data's
                SizedBox(height: 12),
                widget.services.status == "On Process"
                  ? RichText(
                  softWrap: true,
                  text: TextSpan(children: <TextSpan>
                  [
                    TextSpan(text: "Handler : ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey[100], letterSpacing: 0.5, fontWeight: FontWeight.bold),
                      ),),

                    TextSpan(text: "${_handler.elementAtOrNull(0)?.name} || ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),

                    TextSpan(text: "${_handler.elementAtOrNull(0)?.position} || ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                    TextSpan(text: "${_handler.elementAtOrNull(0)?.contact} || ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                    TextSpan(text: "${_handler.elementAtOrNull(0)?.email}",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey[100], letterSpacing: 0.8),
                      ),),
                  ]
                  ),
                )
                  : SizedBox.shrink(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              widget.services.status.toUpperCase(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == "On Process") {
      return Colors.orangeAccent;
    } else if (status == "Unread") {
      return Colors.blue;
    } else if (status == "Completed") {
      return Colors.green;
    } else {
      return Colors.redAccent;
    }
  }
}
