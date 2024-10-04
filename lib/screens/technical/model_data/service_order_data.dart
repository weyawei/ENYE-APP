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
      service_by: json['serviced_by'] as String? ?? '',
      conforme: json['conforme'] as String? ?? '',
      conforme_signature: json['conforme_signature'] as String? ?? '',
      coc: json['coc'] as String? ?? '',
      stat: json['stat'] as String? ?? '',
      date_completed: json['date_completed'] as String? ?? '',
      date_modified: json['date_modified'] as String? ?? '',
    );
  }
}