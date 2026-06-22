class Endpoints {
  static const String baseUrl = 'http://10.20.0.45:7034/api/v1';

  // Auth
  static const String login = '/auth/login';

  // Customers
  static const String register = '/customers/register';
  static const String customerMe = '/customers/me';

  // Remittance
  static const String exchangeRates = '/rates';
  static const String calculateFee = '/remittance/fee';
  static const String sendMoney = '/remittance/send';

  // Transactions
  static const String transactions = '/transactions';

  // Beneficiaries
  static const String beneficiaries = '/beneficiaries';
}
