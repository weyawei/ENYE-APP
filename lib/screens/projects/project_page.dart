import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  static const String routeName = '/projects';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProjectsPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Projects'),
    );
  }
}
