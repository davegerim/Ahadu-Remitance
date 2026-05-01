import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  int _currentStep = 0;

  // Recipient State
  String? _selectedBank;
  final TextEditingController _accountController = TextEditingController();
  bool _isAccountVerified = false;
  final String _mockRecipientName = 'DAWIT GERIM SAHILU';

  // Amount State
  final TextEditingController _usdController = TextEditingController();
  final TextEditingController _etbController = TextEditingController();
  final double _exchangeRate = 153.8162;
  final double _bonusRate = 0.12;

  // Pay State
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  final List<Map<String, dynamic>> _banks = [
    {'name': 'Bank of Abyssinia', 'icon': LucideIcons.building, 'color': AppPalette.warning},
    {'name': 'telebirr', 'icon': LucideIcons.smartphone, 'color': Colors.blue},
    {'name': 'Commercial Bank of Ethiopia', 'icon': LucideIcons.landmark, 'color': Colors.purple},
    {'name': 'Awash Bank', 'icon': LucideIcons.waves, 'color': Colors.blue[800]},
    {'name': 'Dashen Bank', 'icon': LucideIcons.building2, 'color': Colors.blue[900]},
    {'name': 'Zemen Bank', 'icon': LucideIcons.zap, 'color': AppPalette.error},
    {'name': 'Wegagen Bank', 'icon': LucideIcons.circle, 'color': AppPalette.warning},
  ];

  @override
  void dispose() {
    _accountController.dispose();
    _usdController.dispose();
    _etbController.dispose();
    _cardNameController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _postalController.dispose();
    _cardNumberController.dispose();
    _securityCodeController.dispose();
    _expiryController.dispose();
    super.dispose();
  }

  void _calculateEtb(String usdValue) {
    if (usdValue.isEmpty) {
      _etbController.text = '';
      setState(() {});
      return;
    }
    final usd = double.tryParse(usdValue) ?? 0.0;
    final etb = usd * _exchangeRate;
    _etbController.text = etb.toStringAsFixed(2);
    setState(() {});
  }

  double get _currentEtb => double.tryParse(_etbController.text) ?? 0.0;
  double get _bonusAmount => _currentEtb * _bonusRate;
  double get _totalEtb => _currentEtb + _bonusAmount;

  String _getFormattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return '$day/$month/$year, $hour:$minute:$second';
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    } else {
      context.go('/home');
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/home');
      }
    }
  }

  void _showBankSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppPalette.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppPalette.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppPalette.borderLight),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search banks...',
                        hintStyle: const TextStyle(color: AppPalette.textHint),
                        prefixIcon: const Icon(LucideIcons.search, color: AppPalette.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _banks.length,
                    itemBuilder: (context, index) {
                      final bank = _banks[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bank['color'].withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(bank['icon'], color: bank['color'], size: 24),
                        ),
                        title: Text(
                          bank['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedBank = bank['name'];
                            _isAccountVerified = false;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        backgroundColor: AppPalette.background,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton.icon(
          onPressed: _prevStep,
          icon: const Icon(LucideIcons.chevronLeft, size: 20, color: AppPalette.textPrimary),
          label: Text(
            'Back',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppPalette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go('/home'),
            child: Text(
              'Cancel',
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppPalette.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'Send Money',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppPalette.textPrimary,
                ),
              ),
            ),
            _buildStepper(theme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _buildCurrentStep(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(ThemeData theme) {
    final steps = ['Recipient', 'Amount', 'Review', 'Pay'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppPalette.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: _currentStep,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppPalette.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: steps.length - 1 - _currentStep,
                    child: Container(
                      height: 4,
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(steps.length, (index) {
                  final isCompleted = index <= _currentStep;
                  final isCurrent = index == _currentStep;
                  return Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? AppPalette.primary : AppPalette.surface,
                      border: Border.all(
                        color: isCompleted ? AppPalette.primary : AppPalette.border,
                        width: 2,
                      ),
                      boxShadow: isCurrent ? [
                        BoxShadow(
                          color: AppPalette.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ] : null,
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final isCurrent = index == _currentStep;
              final isCompleted = index < _currentStep;
              return Text(
                steps[index],
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: isCurrent || isCompleted ? AppPalette.textPrimary : AppPalette.textHint,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return _buildRecipientStep(theme);
      case 1:
        return _buildAmountStep(theme);
      case 2:
        return _buildReviewStep(theme);
      case 3:
        return _buildPayStep(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRecipientStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showBankSelection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppPalette.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppPalette.borderLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (_selectedBank != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _banks.firstWhere((b) => b['name'] == _selectedBank)['color'].withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _banks.firstWhere((b) => b['name'] == _selectedBank)['icon'],
                          color: _banks.firstWhere((b) => b['name'] == _selectedBank)['color'],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Text(
                      _selectedBank ?? 'Select Bank or Wallet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: _selectedBank != null ? AppPalette.textPrimary : AppPalette.textHint,
                        fontWeight: _selectedBank != null ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(LucideIcons.chevronDown, color: AppPalette.textSecondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppPalette.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _accountController,
            keyboardType: TextInputType.number,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            onChanged: (val) {
              if (_isAccountVerified) {
                setState(() => _isAccountVerified = false);
              }
            },
            decoration: InputDecoration(
              hintText: 'Account Number',
              hintStyle: theme.textTheme.titleMedium?.copyWith(color: AppPalette.textHint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
          ),
        ),
        if (_isAccountVerified) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: AppPalette.primaryLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppPalette.primary.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppPalette.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.checkCircle2, color: AppPalette.primary, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  'Verified Recipient',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppPalette.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _mockRecipientName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppPalette.primaryDark,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (_selectedBank == null || _accountController.text.isEmpty) return;
              if (!_isAccountVerified) {
                setState(() {
                  _isAccountVerified = true;
                });
              } else {
                _nextStep();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              _isAccountVerified ? 'Continue' : 'Verify Account',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // You Send Card (Using Ahadu Pattern)
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppPalette.borderLight, width: 1),
            image: DecorationImage(
              image: const AssetImage('assets/images/pattern_1.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.95),
                BlendMode.lighten,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'You Send',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '\$',
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: AppPalette.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  IntrinsicWidth(
                    child: TextField(
                      controller: _usdController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      onChanged: _calculateEtb,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 56,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -2.0,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        hintText: '0',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppPalette.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('https://flagcdn.com/w40/us.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'USD',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Exchange Rate Info
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppPalette.borderLight, width: 1),
                ),
                child: const Icon(LucideIcons.arrowDownUp, color: AppPalette.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exchange Rate',
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 USD = $_exchangeRate ETB',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Total Receive Card (Ahadu Tilet Pattern)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppPalette.surfaceDark,
            borderRadius: BorderRadius.circular(32),
            image: DecorationImage(
              image: const AssetImage('assets/images/ahadu_tilet.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppPalette.surfaceDark.withValues(alpha: 0.85),
                BlendMode.darken,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.surfaceDark.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            children: [
              // Bonus Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppPalette.primary.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.gift, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '12% BONUS APPLIED',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Base Amount',
                          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
                        ),
                        Text(
                          '${_currentEtb.toStringAsFixed(2)} ETB',
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bonus (+12%)',
                          style: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.successLight),
                        ),
                        Text(
                          '+${_bonusAmount.toStringAsFixed(2)} ETB',
                          style: theme.textTheme.titleMedium?.copyWith(color: AppPalette.successLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recipient Gets',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _totalEtb.toStringAsFixed(2),
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage('https://flagcdn.com/w40/et.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'ETB',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (_usdController.text.isNotEmpty && _etbController.text.isNotEmpty) {
                _nextStep();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppPalette.primaryLight,
            shape: BoxShape.circle,
            border: Border.all(color: AppPalette.primary.withValues(alpha: 0.2), width: 2),
          ),
          child: const Icon(LucideIcons.send, color: AppPalette.primary, size: 32),
        ),
        const SizedBox(height: 24),
        Text(
          'You are sending to',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppPalette.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _mockRecipientName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppPalette.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppPalette.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildReviewRow(theme, 'Send Via', _selectedBank ?? ''),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              _buildReviewRow(theme, 'Receiver Account', _accountController.text),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              _buildReviewRow(theme, 'Amount (USD)', '\$${_usdController.text}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              _buildReviewRow(theme, 'Amount (ETB)', '${_totalEtb.toStringAsFixed(2)} ETB', isHighlight: true),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(height: 1),
              ),
              _buildReviewRow(theme, 'Date', _getFormattedDate()),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Confirm and Send',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(ThemeData theme, String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppPalette.textSecondary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isHighlight ? AppPalette.primary : AppPalette.textPrimary,
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPayStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppPalette.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            image: DecorationImage(
              image: const AssetImage('assets/images/ahadu_tilet.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppPalette.surfaceDark.withValues(alpha: 0.9),
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total to Pay',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const Icon(LucideIcons.creditCard, color: Colors.white, size: 24),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '\$${_usdController.text}',
                style: theme.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Payment Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        _buildPayField(theme, 'Cardholder Name', _cardNameController, 'Dawit Gerim'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPayField(theme, 'Country', _countryController, 'Country')),
            const SizedBox(width: 16),
            Expanded(child: _buildPayField(theme, 'State', _stateController, 'State')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPayField(theme, 'City', _cityController, 'City')),
            const SizedBox(width: 16),
            Expanded(child: _buildPayField(theme, 'Postal Code', _postalController, 'Zip Code')),
          ],
        ),
        const SizedBox(height: 16),
        _buildPayField(theme, 'Address', _addressController, 'Street Address'),
        const SizedBox(height: 32),
        _buildPayField(theme, 'Card Number', _cardNumberController, '0000 0000 0000 0000', isNumber: true),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPayField(theme, 'Expiry Date', _expiryController, 'MM/YY')),
            const SizedBox(width: 16),
            Expanded(child: _buildPayField(theme, 'CVV', _securityCodeController, '123', isNumber: true, isObscure: true)),
          ],
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              context.go('/success');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayField(ThemeData theme, String label, TextEditingController controller, String hint, {bool isNumber = false, bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppPalette.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppPalette.borderLight),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            obscureText: isObscure,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(color: AppPalette.textHint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
