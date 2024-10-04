import '../../screens.dart';

class EngTSIS {
  String tsis_id;
  String tsis_no;
  String project;
  String location;
  String client_name;
  String contact_person;
  String contact_number;
  String email;
  String problem;
  String subject;
  String remarks;
  String status;
  String prepared_by;
  String person_charge;
  String technician;
  String attachment;
  String date_completed;
  List<EngEvents> events; // Add a list of Event objects

  EngTSIS({
    required this.tsis_id,
    required this.tsis_no,
    required this.project,
    required this.location,
    required this.client_name,
    required this.contact_person,
    required this.contact_number,
    required this.email,
    required this.problem,
    required this.subject,
    required this.remarks,
    required this.status,
    required this.prepared_by,
    required this.person_charge,
    required this.technician,
    required this.attachment,
    required this.date_completed,
    required this.events, // Include the events list in the constructor
  });

  factory EngTSIS.fromJson(Map<String, dynamic> json) {
    // Check if 'event_data' is a list or a single map
    var eventsJson = json['event_data'];

    // If it's a Map, convert it into a single-element List
    List<EngEvents> eventsList = [];
    if (eventsJson is List) {
      eventsList = eventsJson.isNotEmpty
          ? eventsJson.map((eventJson) => EngEvents.fromJson(eventJson as Map<String, dynamic>)).toList()
          : [];
    } else if (eventsJson is Map) {
      eventsList = [EngEvents.fromJson(eventsJson as Map<String, dynamic>)];
    }

    return EngTSIS(
      tsis_id: json['tsis_id'] as String? ?? '',
      tsis_no: json['tsis_no'] as String? ?? '',
      project: json['project'] as String? ?? '',
      location: json['location'] as String? ?? '',
      client_name: json['client_name'] as String? ?? '',
      contact_person: json['contact_person'] as String? ?? '',
      contact_number: json['contact_number'] as String? ?? '',
      email: json['email'] as String? ?? '',
      problem: json['problem'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      status: json['status'] as String? ?? '',
      prepared_by: json['prepared_by'] as String? ?? '',
      person_charge: json['person_charge'] as String? ?? '',
      technician: json['technician'] as String? ?? '',
      attachment: json['attachment'] as String? ?? '',
      date_completed: json['date_completed'] as String? ?? '',
      events: eventsList,
    );
  }
}
