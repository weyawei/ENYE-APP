import 'package:flutter/material.dart';

import '../../widget/widgets.dart';

class ServicePage extends StatelessWidget {
  static const String routeName = '/service';

  const ServicePage({super.key});

  static Route route(){
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const ServicePage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Service', imagePath: 'assets/logo/enyecontrols.png',),
      /*drawer: CustomDrawer(),*/
      body: Center(
        child: (Text(
          "Service Page",
          style: TextStyle(
              fontSize: 40,
              color: Colors.grey
          ),
        )),
      ),
    );
  }
}

