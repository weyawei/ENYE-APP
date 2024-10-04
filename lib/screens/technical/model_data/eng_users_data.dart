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