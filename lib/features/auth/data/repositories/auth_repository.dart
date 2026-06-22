import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ahadu_remittance/core/storage/token_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/customer_model.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final TokenStorage _tokenStorage;

  AuthRepository(this._remoteDatasource, this._tokenStorage);

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDatasource.login(
      LoginRequest(email: email, password: password),
    );
    await _tokenStorage.saveToken(response.accessToken);
    return response;
  }

  Future<CustomerModel> register(RegisterRequest request) {
    return _remoteDatasource.register(request);
  }

  Future<CustomerModel> getCurrentCustomer() {
    return _remoteDatasource.getCurrentCustomer();
  }

  Future<void> logout() => _tokenStorage.deleteToken();

  Future<String?> getStoredToken() => _tokenStorage.getToken();

  String? extractErrorMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      return data['message'] as String;
    }
    return error.message ?? 'Something went wrong. Please try again.';
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(authRemoteDatasourceProvider),
    ref.watch(tokenStorageProvider),
  );
});
