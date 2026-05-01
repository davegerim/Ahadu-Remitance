class Endpoints {
  static const String baseUrl = 'https://api.ahaduremittance.com/v1';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  
  // Remittance
  static const String exchangeRates = '/rates';
  static const String calculateFee = '/remittance/fee';
  static const String sendMoney = '/remittance/send';
  
  // Transactions
  static const String transactions = '/transactions';
  
  // Beneficiaries
  static const String beneficiaries = '/beneficiaries';
}
