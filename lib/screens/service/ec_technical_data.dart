

class EcUsers {
  String id;
  String emp_id_no;
  String firstname;
  String lastname;
  String username;
  String email;
  String mobile;
  String role_type;
  String landline;
  String picture;
  String signature;

  EcUsers({
    required this.id,
    required this.emp_id_no,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.email,
    required this.mobile,
    required this.role_type,
    required this.landline,
    required this.picture,
    required this.signature,
  });

  factory EcUsers.fromJson(Map<String, dynamic> json) {
    return EcUsers(
      id: json['id'] as String,
      emp_id_no: json['emp_id_no'] as String? ?? '',
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      role_type: json['role_type'] as String? ?? '',
      landline: json['landline'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
    );
  }
}




class EcSO {
  String so_id;
  String so_no;
  String tsis_id;
  String event_id;
  String project;
  String address;
  String Client_person;
  String tsis_no;
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
  String service_by;
  String conforme;
  String conforme_signature;
  String coc;
  String stat;
  String date_completed;
  String date_modified;

  EcSO({
    required this.so_id,
    required this.so_no,
    required this.tsis_id,
    required this.event_id,
    required this.project,
    required this.address,
    required this.Client_person,
    required this.tsis_no,
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
    required this.service_by,
    required this.conforme,
    required this.conforme_signature,
    required this.coc,
    required this.stat,
    required this.date_completed,
    required this.date_modified,
  });

  factory EcSO.fromJson(Map<String, dynamic> json) {
    return EcSO(
      so_id: json['so_id'] as String? ?? '',
      so_no: json['so_no'] as String? ?? '',
      tsis_id: json['tsis_id'] as String? ?? '',
      event_id: json['event_id'] as String? ?? '',
      project: json['project'] as String? ?? '',
      address: json['address'] as String? ?? '',
      Client_person: json['Client_person'] as String? ?? '',
      tsis_no: json['tsis_no'] as String? ?? '',
      time_in: json['time_in'] as String? ?? '',
      time_out: json['time_out'] as String? ?? '',
      day: json['day'] as String? ?? '',
      date_so: json['date_so'] as String? ?? '',
      system_product: json['system_product'] as String? ?? '',
      location: json['location'] as String? ?? '',
      complaint: json['complaint'] as String? ?? '',
      status: json['status'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      service: json['service'] as String? ?? '',
      service_by: json['service_by'] as String? ?? '',
      conforme: json['conforme'] as String? ?? '',
      conforme_signature: json['conforme_signature'] as String? ?? '',
      coc: json['coc'] as String? ?? '',
      stat: json['stat'] as String? ?? '',
      date_completed: json['date_completed'] as String? ?? '',
      date_modified: json['date_modified'] as String? ?? '',
    );
  }
}



class EcEvent {
  String id;
  String tsis_id;
  String title;
  String engineer;
  String technician;
  String start;
  String end;
  String so_no;
  String status;
  String date_completed;
  String remarks;

  EcEvent({
    required this.id,
    required this.tsis_id,
    required this.title,
    required this.engineer,
    required this.technician,
    required this.start,
    required this.end,
    required this.so_no,
    required this.status,
    required this.date_completed,
    required this.remarks,
  });

  factory EcEvent.fromJson(Map<String, dynamic> json) {
    return EcEvent(
      id: json['id'] as String? ?? '',
      tsis_id: json['tsis_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      engineer: json['engineer'] as String? ?? '',
      technician: json['technician'] as String? ?? '',
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      so_no: json['so_no'] as String? ?? '',
      status: json['status'] as String? ?? '',
      date_completed: json['date_completed'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
    );
  }
}



class EcTSIS {
  String tsis_id;
  String tsis_no;
  String form_no;
  String proj_id;
  String project;
  String location;
  String client_name;
  String contact_person;
  String contact_number;
  String email;
  String problem;
  String subject;
  String other;
  String subject_child;
  String remarks;
  String cost_analysis;
  String po_forms;
  String quote_no;
  String project_info;
  String status;
  String prepared_by;
  String person_charge;
  String technician;
  String attachment;
  String date_completed;
  String date_modified;
  String date_created;



  EcTSIS({
    required this.tsis_id,
    required this.tsis_no,
    required this.form_no,
    required this.proj_id,
    required this.project,
    required this.location,
    required this.client_name,
    required this.contact_person,
    required this.contact_number,
    required this.email,
    required this.problem,
    required this.subject,
    required this.other,
    required this.subject_child,
    required this.remarks,
    required this.cost_analysis,
    required this.po_forms,
    required this.quote_no,
    required this.project_info,
    required this.status,
    required this.prepared_by,
    required this.person_charge,
    required this.technician,
    required this.attachment,
    required this.date_completed,
    required this.date_modified,
    required this.date_created,
  });

  factory EcTSIS.fromJson(Map<String, dynamic> json) {
    return EcTSIS(
      tsis_id: json['tsis_id'] as String? ?? '',
      tsis_no: json['tsis_no'] as String? ?? '',
      form_no: json['form_no'] as String? ?? '',
      proj_id: json['proj_id'] as String? ?? '',
      project: json['project'] as String? ?? '',
      location: json['location'] as String? ?? '',
      client_name: json['client_name'] as String? ?? '',
      contact_person: json['contact_person'] as String? ?? '',
      contact_number: json['contact_number'] as String? ?? '',
      email: json['email'] as String? ?? '',
      problem: json['problem'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      other: json['other'] as String? ?? '',
      subject_child: json['subject_child'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      cost_analysis: json['cost_analysis'] as String? ?? '',
      po_forms: json['po_forms'] as String? ?? '',
      quote_no: json['quote_no'] as String? ?? '',
      project_info: json['project_info'] as String? ?? '',
      status: json['status'] as String? ?? '',
      prepared_by: json['prepared_by'] as String? ?? '',
      person_charge: json['person_charge'] as String? ?? '',
      technician: json['technician'] as String? ?? '',
      attachment: json['attachment'] as String? ?? '',
      date_completed: json['date_completed'] as String? ?? '',
      date_created: json['date_created'] as String? ?? '',
      date_modified: json['modified'] as String? ?? '',

    );
  }
}
