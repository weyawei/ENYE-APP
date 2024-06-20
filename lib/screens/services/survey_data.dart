

class Survey {
  String sq_id;
  String question;
  String choices;


  Survey({
    required this.sq_id,
    required this.question,
    required this.choices,

  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      sq_id: json['sq_id'] as String,
      question: json['question'] as String? ?? '',
      choices: json['choices'] as String? ?? '',

    );
  }
}




class SurveyChoices {
  String sc_id;
  String sq_id;
  String choices;
  bool isSelected; // Add this property


  SurveyChoices({
    required this.sc_id,
    required this.sq_id,
    required this.choices,
    this.isSelected = false, // Initialize it to false

  });

  factory SurveyChoices.fromJson(Map<String, dynamic> json) {
    return SurveyChoices(
      sc_id: json['sc_id'] as String,
      sq_id: json['sq_id'] as String? ?? '',
      choices: json['choices'] as String? ?? '',

    );
  }
}




