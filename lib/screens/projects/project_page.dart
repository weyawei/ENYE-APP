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

  final List <Map<String, dynamic>> gridProjCategories = [
    {"proCateg": "1", "title": "BUILDINGS", "images": "assets/icons/proj_buildings.png"},
    {"proCateg": "2", "title": "HOSPITALS", "images": "assets/icons/proj_hospital.png"},
    {"proCateg": "3", "title": "CONDOMINIUM", "images": "assets/icons/proj_condo.png"},
    {"proCateg": "4", "title": "HOTEL & RESORT", "images": "assets/icons/proj_resort.png"},
    {"proCateg": "5", "title": "INDUSTRIES", "images": "assets/icons/proj_airport.png"},
    {"proCateg": "6", "title": "MALLS", "images": "assets/icons/proj_mall.png"},
    {"proCateg": "7", "title": "SCHOOL & LEARNING CENTERS", "images": "assets/icons/proj_school.png"}
  ];

  List <Map<String, dynamic>> gridProjects = [
    {"title": "1 Nito Tower", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622619484.jpg", "proCateg": "1"},
    {"title": "8912 Aseana", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620662.jpg", "proCateg": "1"},
    {"title": "Alveo Financial Tower", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620397.png", "proCateg": "1"},
    {"title": "Alveo High Park", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620529.jpg", "proCateg": "1"},
    {"title": "Ayala Land Vermosa BLDG.", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622687669.jpg", "proCateg": "1"},
    {"title": "Ayala Triangle Gardens", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622620781.jpg", "proCateg": "1"},
    {"title": "BA Lepanto Building", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622621124.jpg", "proCateg": "1"},
    {"title": "BDO Tower", "images": "https://enyecontrols.com/ec_cpanel/images/projects/1622621376.jpg", "proCateg": "1"}
  ];

  List <Map<String, dynamic>> filteredProjects = [];

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(title: 'Projects'),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              //project categories
              Container(
                height: 115,
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 16.0),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 115,
                  ),
                  itemCount: gridProjCategories.length,
                  itemBuilder: (context, index){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.deepOrange.shade100, width: 1.0,),
                          left: BorderSide(color: Colors.deepOrange.shade100, width: 1.0,),
                        ),
                      ),
                      child: Column(
                        children: [
                          Image.asset("${gridProjCategories.elementAt(index)['images']}", color: Colors.deepOrange.shade400, height: 50, width: 50,),

                          Expanded(
                            child: TextButton(
                                child: Text(
                                  "${gridProjCategories.elementAt(index)['title']}",
                                  style: TextStyle(fontSize: 12.0, color: Colors.deepOrange.shade400, fontWeight: FontWeight.bold),
                                  softWrap: false,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onPressed: (){},
                            ),
                          )
                        ],
                      )
                    );
                  },
                ),
              ),

              //project items
              GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  mainAxisExtent: 270,
                ),
                itemCount: gridProjects.length,
                itemBuilder: (context, index){
                  final projects = gridProjects.elementAt(index)['proCateg'];

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.orange[200],
                    ), //no function??nasasapawan ng pictures
                    child: Column(
                      children: [
                        ClipRRect(borderRadius: BorderRadius.circular(12.0),
                            child: Container(
                              height: 270,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage("${gridProjects.elementAt(index)['images']}"), fit: BoxFit.cover),
                              ),

                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.withOpacity(0.2), Colors.deepOrange.shade100.withOpacity(0.3)],
                                    stops: [0.0, 1],
                                    begin: Alignment.topCenter,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 150,
                                    margin: EdgeInsets.only(top: 50.0),
                                    padding: EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.deepOrange.shade300, Colors.deepOrange.withOpacity(0)],
                                      ),
                                    ),
                                    child: Text(
                                      "${gridProjects.elementAt(index)['title']}",
                                      style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
