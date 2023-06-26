import 'package:enye_app/screens/screens.dart';
import 'package:enye_app/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

  static const String routeName = '/projects';

  static Route route(){
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProjectsPage()
    );
  }

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String selectedCategory = 'ALL';

  List<Projects> filteredProjects = [];

  void initState() {
    super.initState();
    // Initially, show all products
    filteredProjects = projectList;
  }

  @override
  Widget build(BuildContext context) {

    );
  }

  void filterProjects() {
    if (selectedCategory == 'ALL') {
      filteredProjects = projectList;
    } else {
      filteredProjects =
          projectList.where((projectList) => projectList.category == selectedCategory).toList();
    }
  }
}
