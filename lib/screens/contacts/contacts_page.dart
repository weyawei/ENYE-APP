import 'package:enye_app/widget/custom_drawer.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

import '../projects/project_page.dart';
import '../systems/system_page.dart';

class ContactsPage extends StatelessWidget {
  static const String routeName = '/contacts';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ContactsPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Contact Us', imagePath: '',),
      drawer: CustomDrawer(),

    );
  }
}
