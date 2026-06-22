import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_model.dart';
import '../../data/repositories/auth_repository.dart';

final currentCustomerProvider =
    AsyncNotifierProvider<CurrentCustomerNotifier, CustomerModel?>(
  CurrentCustomerNotifier.new,
);

class CurrentCustomerNotifier extends AsyncNotifier<CustomerModel?> {
  @override
  Future<CustomerModel?> build() async => null;

  void setCustomer(CustomerModel customer) {
    state = AsyncData(customer);
  }

  void clearCustomer() {
    state = const AsyncData(null);
  }

  Future<CustomerModel> fetchProfile() async {
    state = const AsyncLoading();
    try {
      final customer =
          await ref.read(authRepositoryProvider).getCurrentCustomer();
      state = AsyncData(customer);
      return customer;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final authLoadingProvider = NotifierProvider<AuthLoadingNotifier, bool>(
  AuthLoadingNotifier.new,
);

class AuthLoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setLoading(bool value) => state = value;
}

String? extractAuthError(Object error, AuthRepository repository) {
  if (error is DioException) {
    return repository.extractErrorMessage(error);
  }
  return error.toString();
}
