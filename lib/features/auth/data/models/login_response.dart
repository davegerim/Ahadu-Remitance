import 'customer_model.dart';

class LoginResponse {
  final String accessToken;
  final CustomerModel customer;

  const LoginResponse({
    required this.accessToken,
    required this.customer,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      customer: CustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
    );
  }
}
