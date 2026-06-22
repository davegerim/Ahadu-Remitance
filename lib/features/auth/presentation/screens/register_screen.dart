import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ahadu_remittance/core/theme/colors.dart';
import 'package:ahadu_remittance/features/auth/data/models/register_request.dart';
import 'package:ahadu_remittance/features/auth/data/repositories/auth_repository.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  int _currentStep = 0;

  // Step 1: Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  // Step 2: Verification Code
  final List<TextEditingController> _otpControllers = List.generate(5, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(5, (_) => FocusNode());

  // Step 3: Account Details
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedCountry = 'Ethiopia';
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_currentStep == 0 && !_validatePersonalInfo()) return;
      setState(() {
        _currentStep++;
      });
    } else {
      _submitRegistration();
    }
  }

  bool _validatePersonalInfo() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      _showMessage('Please fill in all personal information fields.');
      return false;
    }
    return true;
  }

  Future<void> _submitRegistration() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      _showMessage('Please enter your phone number and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(authRepositoryProvider);
      final request = RegisterRequest(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: '+251$phone',
        password: password,
      );

      await repository.register(request);

      if (mounted) {
        _showMessage('Account created successfully. Please sign in.');
        context.go('/login');
      }
    } on DioException catch (e) {
      final message = ref.read(authRepositoryProvider).extractErrorMessage(e);
      _showMessage(message ?? 'Registration failed. Please try again.');
    } catch (e) {
      _showMessage('Registration failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.background,
      appBar: AppBar(
        backgroundColor: AppPalette.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppPalette.textPrimary),
          onPressed: _prevStep,
        ),
      ),
      body: Stack(
        children: [
          // Subtle Ahadu Pattern Background
          Positioned(
            top: -100,
            right: -100,
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/pattern_2.png',
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppPalette.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getStepIcon(),
                          color: AppPalette.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _getStepTitle(),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppPalette.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_currentStep == 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Enter the verification code sent to your email',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppPalette.textSecondary,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
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
        ],
      ),
    );
  }

  IconData _getStepIcon() {
    switch (_currentStep) {
      case 0:
        return LucideIcons.user;
      case 1:
        return LucideIcons.shieldCheck;
      case 2:
        return LucideIcons.settings;
      default:
        return LucideIcons.user;
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Personal Information';
      case 1:
        return 'Verification Code';
      case 2:
        return 'Account Details';
      default:
        return '';
    }
  }

  Widget _buildStepper(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: List.generate(3, (index) {
          final isCompleted = index <= _currentStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 6,
              margin: EdgeInsets.only(right: index < 2 ? 8.0 : 0),
              decoration: BoxDecoration(
                color: isCompleted ? AppPalette.primary : AppPalette.borderLight,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep(theme);
      case 1:
        return _buildVerificationStep(theme);
      case 2:
        return _buildAccountDetailsStep(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppPalette.surfaceDarker,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/login_logo.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                theme,
                'First Name',
                _firstNameController,
                icon: LucideIcons.user,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInputField(
                theme,
                'Last Name',
                _lastNameController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInputField(
          theme,
          'Email Address',
          _emailController,
          icon: LucideIcons.mail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 48),
        _buildContinueButton('Continue'),
        const SizedBox(height: 24),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppPalette.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/login'),
                child: Text(
                  'Sign In',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppPalette.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppPalette.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.mailOpen,
            color: AppPalette.primary,
            size: 48,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            return Container(
              width: 56,
              height: 64,
              decoration: BoxDecoration(
                color: AppPalette.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _otpFocusNodes[index].hasFocus ? AppPalette.primary : AppPalette.borderLight,
                  width: _otpFocusNodes[index].hasFocus ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: _otpControllers[index],
                  focusNode: _otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppPalette.primary,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 4) {
                      _otpFocusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _otpFocusNodes[index - 1].requestFocus();
                    }
                    setState(() {}); // To update border color based on focus
                  },
                  onTap: () {
                    setState(() {}); // To update border color based on focus
                  },
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 40),
        Text(
          'Resend code in 01:17',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppPalette.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 48),
        _buildContinueButton('Verify'),
      ],
    );
  }

  Widget _buildAccountDetailsStep(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppPalette.surfaceDark,
              shape: BoxShape.circle,
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
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              LucideIcons.globe,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 32),
        // Country Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCountry,
              isExpanded: true,
              icon: const Icon(LucideIcons.chevronDown, color: AppPalette.textSecondary),
              items: ['Ethiopia', 'United States', 'United Kingdom', 'Canada']
                  .map((country) => DropdownMenuItem(
                        value: country,
                        child: Row(
                          children: [
                            const Icon(LucideIcons.globe, size: 20, color: AppPalette.primary),
                            const SizedBox(width: 12),
                            Text(
                              country,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCountry = value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        
        // Phone Field
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: AppPalette.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                ),
                child: Text(
                  '+251',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppPalette.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: theme.textTheme.titleMedium?.copyWith(color: AppPalette.textHint),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Password Field
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
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Create Password',
              hintStyle: theme.textTheme.titleMedium?.copyWith(color: AppPalette.textHint),
              prefixIcon: const Icon(LucideIcons.lock, color: AppPalette.textSecondary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                  color: AppPalette.textSecondary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ),
        ),
        const SizedBox(height: 48),
        _buildContinueButton('Create Account'),
      ],
    );
  }

  Widget _buildInputField(ThemeData theme, String hint, TextEditingController controller, {IconData? icon, TextInputType? keyboardType}) {
    return Container(
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
        controller: controller,
        keyboardType: keyboardType,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.titleMedium?.copyWith(color: AppPalette.textHint),
          prefixIcon: icon != null ? Icon(icon, color: AppPalette.textSecondary) : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: icon != null ? 0 : 24, vertical: 20),
        ),
      ),
    );
  }

  Widget _buildContinueButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPalette.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
