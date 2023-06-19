import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class SystemsPage extends StatelessWidget {
  static const String routeName = '/systems';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => SystemsPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Systems',),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}
