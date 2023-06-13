import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,

      appBar: AppBar(
        title: Image.asset("enyecontrols.png", height: 30),
        backgroundColor: Colors.orange[600],
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.menu),
        ),
      ),

      bottomNavigationBar: Container(
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: GNav(
            backgroundColor: Colors.orange,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.orange.shade300,
            padding: EdgeInsets.all(8.0),
            gap: 8,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home',),
              GButton(icon: Icons.settings, text: 'Systems1',),
              GButton(icon: Icons.hvac, text: 'Projects',),
              GButton(icon: Icons.contacts, text: 'About',),
              GButton(icon: Icons.payment
                , text: 'EC Bills',),
            ],
          ),
        ),
      ),
    );
  }
}
