import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets.dart';

class Normal2TextField extends StatelessWidget {
  final controller;
  final String hintText;

  const Normal2TextField({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          }
          return null;
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
          labelText: hintText,
          labelStyle: TextStyle(
            fontSize: fontNormalSize,
            letterSpacing: 0.8
          ),
        ),
      ),
    ) ;
  }
}

class ContactTextField extends StatelessWidget {
  final controller;
  final String hintText;

  const ContactTextField({super.key, required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    String patttern = r'(^(?:[+0]9)?[0-9]{11,12}$)';
    RegExp regExp = new RegExp(patttern);

    double screenWidth = MediaQuery.of(context).size.width;
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (!regExp.hasMatch(value)) {
            return 'Please enter valid mobile number';
          }
          return null;
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontNormalSize,
              letterSpacing: 0.8
          ),
          labelText: hintText,
          hintText: "09xxxxxxxxx",
          labelStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
        ),
      ),
    ) ;
  }
}

class NormalTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const NormalTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);
    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          }
          return null;
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
          labelStyle: TextStyle(
            fontSize: fontNormalSize,
            letterSpacing: 0.8
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontNormalSize, letterSpacing: 0.8),
        ),
      ),
    ) ;
  }
}

class PasswordTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const PasswordTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        readOnly: widget.disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (value.length < 6) {
            return 'Password too short !';
          } else {
            return null;
          }
        },
        controller: widget.controller,
        obscureText: passToggle,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: InkWell(
            onTap: (){
              setState((){
                passToggle = !passToggle;
              });
            },
            child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontNormalSize, letterSpacing: 0.8),
        ),
      ),
    ) ;
  }
}

class EmailTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const EmailTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (EmailValidator.validate(value) == false) {
            return 'Please enter valid email';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
          prefixIcon: Icon(Icons.email),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontNormalSize, letterSpacing: 0.8),
        ),
      ),
    ) ;
  }
}

class PersonNameTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const PersonNameTextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
          prefixIcon: Icon(Icons.person),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontNormalSize, letterSpacing: 0.8),
        ),
      ),
    ) ;
  }
}

class Contact2TextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool disabling;

  const Contact2TextField({super.key, required this.controller, required this.hintText, required this.disabling});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    var fontSmallSize = ResponsiveTextUtils.getSmallFontSize(screenWidth);
    var fontNormalSize = ResponsiveTextUtils.getNormalFontSize(screenWidth);

    String patttern = r'(^(?:[+0]9)?[0-9]{11,12}$)';
    RegExp regExp = new RegExp(patttern);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      child: TextFormField(
        style: GoogleFonts.lato(
          textStyle:
          TextStyle(fontSize: fontNormalSize, fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        readOnly: disabling,
        onEditingComplete: (){},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required !';
          } else if (!regExp.hasMatch(value)) {
            return 'Please enter valid mobile number';
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          errorStyle: TextStyle(
              fontSize: fontSmallSize,
              letterSpacing: 0.8
          ),
          prefixIcon: Icon(Icons.call),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepOrange),
          ),
          fillColor: Colors.deepOrange.shade50,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: fontNormalSize, letterSpacing: 0.8),
        ),
      ),
    ) ;
  }
}

