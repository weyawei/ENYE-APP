//values na meron si booking galing sa database
class TechnicalData {
  String id;
  String svcId;
  String service;
  String svcTitle;
  String svcDesc;
  String dateSched;
  String clientId;
  String clientName;
  String clientCompany;
  String clientLocation;
  String clientProjName;
  String clientContact;
  String clientEmail;
  String status;
  String svcHandler;
  String notesComplete;

  TechnicalData({
    required this.id,
    required this.svcId,
    required this.service,
    required this.svcTitle,
    required this.svcDesc,
    required this.dateSched,
    required this.clientId,
    required this.clientName,
    required this.clientCompany,
    required this.clientLocation,
    required this.clientProjName,
    required this.clientContact,
    required this.clientEmail,
    required this.status,
    required this.svcHandler,
    required this.notesComplete
  });

  factory TechnicalData.fromJson(Map<String, dynamic> json) {
    return TechnicalData(
      id: json['id'] as String,
      svcId: json['svc_id'] as String,
      service: json['service'] as String,
      svcTitle: json['svc_title'] as String,
      svcDesc: json['svc_desc'] as String,
      dateSched: json['date_sched'] as String,
      clientId: json['client_id'] as String,
      clientName: json['client_name'] as String,
      clientCompany: json['client_company'] as String,
      clientLocation: json['client_location'] as String,
      clientProjName: json['client_projectname'] as String,
      clientContact: json['client_contact'] as String,
      clientEmail: json['client_email'] as String,
      status: json['status'] as String,
      svcHandler: json['service_handler'] as String,
      notesComplete: json['notesComplete'] as String,
    );
  }
}

//userAdmin certain data
class UserAdminData {
  String user_id;
  String name;
  String contact;
  String email;
  String position;
  String image;

  UserAdminData({
    required this.user_id,
    required this.name,
    required this.contact,
    required this.email,
    required this.position,
    required this.image,
  });

  factory UserAdminData.fromJson(Map<String, dynamic> json) {
    return UserAdminData(
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      contact: json['contact'] as String,
      email: json['email'] as String,
      position: json['position'] as String,
      image: json['image'] as String,
    );
  }
}

//get positions ng user
class Position {
  String id;
  String position;
  String departmentId;

  Position({
    required this.id,
    required this.position,
    required this.departmentId,
  });

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      id: json['id'] as String,
      position: json['position'] as String,
      departmentId: json['department_id'] as String,
    );
  }
}