
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
