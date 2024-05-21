//values na meron si booking galing sa database
class TechnicalData {
  String id;
  String svcId;
  String service;
  String svcTitle;
  String svcDesc;
  String dateSched;
  String sDateSched;
  String eDateSched;
  String reqName;
  String reqPosition;
  String cliRemarks;
  String atchFile;
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
    required this.sDateSched,
    required this.eDateSched,
    required this.reqName,
    required this.reqPosition,
    required this.cliRemarks,
    required this.atchFile,
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
      sDateSched: json['sDate_sched'] as String,
      eDateSched: json['eDate_sched'] as String,
      reqName: json['requestor_name'] as String,
      reqPosition: json['requestor_position'] as String,
      cliRemarks: json['client_remarks'] as String,
      atchFile: json['attach_file'] as String,
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


class UserAdminData2 {
  String user_id;
  String name;
  String contact;
  String email;
  String position;
  String image;

  UserAdminData2({
    required this.user_id,
    required this.name,
    required this.contact,
    required this.email,
    required this.position,
    required this.image,
  });

  factory UserAdminData2.fromJson(Map<String, dynamic> json) {
    return UserAdminData2(
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

class ServiceOrder {
  String id;
  String so_no;
  String svc_id;
  String project;
  String address;
  String client_person;
  String svc_no;
  String time_in;
  String time_out;
  String day;
  String date_so;
  String system_product;
  String location;
  String complaint;
  String status;
  String remark;
  String service;
  String serviceBy;
  String conforme;
  String conformeSig;
  String coc;
  String stat;
  String date_completed;

  ServiceOrder({
    required this.id,
    required this.so_no,
    required this.svc_id,
    required this.project,
    required this.address,
    required this.client_person,
    required this.svc_no,
    required this.time_in,
    required this.time_out,
    required this.day,
    required this.date_so,
    required this.system_product,
    required this.location,
    required this.complaint,
    required this.status,
    required this.remark,
    required this.service,
    required this.serviceBy,
    required this.conforme,
    required this.conformeSig,
    required this.coc,
    required this.stat,
    required this.date_completed,
  });

  factory ServiceOrder.fromJson(Map<String, dynamic> json) {
    return ServiceOrder(
      id: json['so_id'] as String,
      so_no: json['so_no'] as String,
      svc_id: json['svc_id'] as String,
      project: json['project'] as String,
      address: json['address'] as String,
      client_person: json['client_person'] as String,
      svc_no: json['svc_no'] as String,
      time_in: json['time_in'] as String,
      time_out: json['time_out'] as String,
      day: json['day'] as String,
      date_so: json['date_so'] as String,
      system_product: json['system_product'] as String,
      location: json['location'] as String,
      complaint: json['complaint'] as String,
      status: json['status'] as String,
      remark: json['remark'] as String,
      service: json['service'] as String,
      serviceBy: json['serviced_by'] as String,
      conforme: json['conforme'] as String,
      conformeSig: json['conforme_signature'] as String,
      coc: json['coc'] as String,
      stat: json['stat'] as String,
      date_completed: json['date_completed'] as String,

    );
  }
}

//values na meron si categories
class UsersInfo {
  String user_id;
  String name;
  String username;
  String contact;
  String email;
  String department;
  String position;
  String status;
  String image;
  String signImg;

  UsersInfo({
    required this.user_id,
    required this.name,
    required this.username,
    required this.contact,
    required this.email,
    required this.department,
    required this.position,
    required this.status,
    required this.image,
    required this.signImg,
  });

  factory UsersInfo.fromJson(Map<String, dynamic> json) {
    return UsersInfo(
      user_id: json['user_id'] as String,
      name: json['name'] as String,
      username: json['username'] as String,
      contact: json['contact'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      position: json['position'] as String,
      status: json['status'] as String,
      image: json['image'] as String,
      signImg: json['signature_img'] as String,
    );
  }
}


class ServiceAppointment {
  String id;
  String svc_id;
  String start_datetime;
  String end_datetime;
  String agenda;
  String location;
  String in_charge;
  String notes;
  String attach_file;
  String engineer;
  String technician;
  String assigned_by;
  String status;
  String category;
  String date_modified;

  ServiceAppointment({
    required this.id,
    required this.svc_id,
    required this.start_datetime,
    required this.end_datetime,
    required this.agenda,
    required this.location,
    required this.in_charge,
    required this.notes,
    required this.attach_file,
    required this.engineer,
    required this.technician,
    required this.assigned_by,
    required this.status,
    required this.category,
    required this.date_modified,
  });

  factory ServiceAppointment.fromJson(Map<String, dynamic> json) {
    return ServiceAppointment(
      id: json['id'] as String,
      svc_id: json['svc_id'] as String,
      start_datetime: json['start_datetime'] as String,
      end_datetime: json['end_datetime'] as String,
      agenda: json['agenda'] as String,
      location: json['location'] as String,
      in_charge: json['in_charge'] as String,
      notes: json['notes'] as String,
      attach_file: json['attach_file'] as String,
      engineer: json['engineer'] as String,
      technician: json['technician'] as String,
      assigned_by: json['assigned_by'] as String,
      status: json['status'] as String,
      category: json['category'] as String,
      date_modified: json['date_modified'] as String,
    );
  }
}