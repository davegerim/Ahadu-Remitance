class RegisterRequest {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String phone;
  final String password;

  const RegisterRequest({
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        if (middleName != null && middleName!.isNotEmpty)
          'middleName': middleName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
      };
}
