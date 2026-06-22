import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ahadu_remittance/core/network/api_logger.dart';
import 'package:ahadu_remittance/core/network/dio_factory.dart';
import 'package:ahadu_remittance/core/network/endpoints.dart';
import '../models/customer_model.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';

class AuthRemoteDatasource {
  final Dio _dio;

  AuthRemoteDatasource(this._dio);

  Future<LoginResponse> login(LoginRequest request) async {
    const apiName = 'POST /api/v1/auth/login';
    final url = '${Endpoints.baseUrl}${Endpoints.login}';

    ApiLogger.logRequest(
      apiName: apiName,
      method: 'POST',
      url: url,
      payload: request.toJson(),
    );

    try {
      final response = await _dio.post(
        Endpoints.login,
        data: request.toJson(),
      );

      ApiLogger.logResponse(
        apiName: apiName,
        statusCode: response.statusCode ?? 0,
        data: response.data,
      );

      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      ApiLogger.logError(
        apiName: apiName,
        message: e.message ?? 'Login failed',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      rethrow;
    }
  }

  Future<CustomerModel> register(RegisterRequest request) async {
    const apiName = 'POST /api/v1/customers/register';
    final url = '${Endpoints.baseUrl}${Endpoints.register}';

    ApiLogger.logRequest(
      apiName: apiName,
      method: 'POST',
      url: url,
      payload: request.toJson(),
    );

    try {
      final response = await _dio.post(
        Endpoints.register,
        data: request.toJson(),
      );

      ApiLogger.logResponse(
        apiName: apiName,
        statusCode: response.statusCode ?? 0,
        data: response.data,
      );

      return CustomerModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      ApiLogger.logError(
        apiName: apiName,
        message: e.message ?? 'Registration failed',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      rethrow;
    }
  }

  Future<CustomerModel> getCurrentCustomer() async {
    const apiName = 'GET /api/v1/customers/me';
    final url = '${Endpoints.baseUrl}${Endpoints.customerMe}';

    ApiLogger.logRequest(
      apiName: apiName,
      method: 'GET',
      url: url,
    );

    try {
      final response = await _dio.get(Endpoints.customerMe);

      ApiLogger.logResponse(
        apiName: apiName,
        statusCode: response.statusCode ?? 0,
        data: response.data,
      );

      return CustomerModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      ApiLogger.logError(
        apiName: apiName,
        message: e.message ?? 'Failed to fetch profile',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
      rethrow;
    }
  }
}

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.watch(dioProvider));
});
