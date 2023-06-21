import 'package:enye_app/screens/projects/list_projects.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';

class detailedProjPage extends StatelessWidget {
  static const String routeName = '/detailedproj';

  static Route route({required Projects projects}){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => detailedProjPage(projects: projects),
    );
  }

  final Projects projects;

  const detailedProjPage({required this.projects});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'detailed'),
      body: Container(),
    );
  }
}
