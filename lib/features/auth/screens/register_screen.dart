import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/l10n/app_locale.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';

/// Registration screen — collects email, password, and confirm password.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.signUp(
      fullName: _nameController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      email: _emailController.text,
    );

    if (!mounted) return;

    if (success) {
      // If email confirmation is disabled, user is logged in automatically and auth state resets.
      // Pop to return to previous screen instantly.
      if (auth.isLoggedIn) {
        Navigator.of(context).pop();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      } else {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: Icon(
          Icons.mark_email_read_outlined,
          color: AppColors.primary,
          size: 44,
        ),
        title: Text(AppLocale.format(AppLocale.authCreateAccount)),
        content: const Text(
          'Please check your inbox and confirm your email address before logging in.',
          textAlign: TextAlign.center,
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // go back to login
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text(AppLocale.format(AppLocale.authLoginButton)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            context.read<AuthProvider>().clearError();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),

              // ── Header ──────────────────────────────────────────────────
              _Header(),

              const SizedBox(height: 40),

              // ── Form ────────────────────────────────────────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name
                    AuthFormField(
                      controller: _nameController,
                      label: AppLocale.format(AppLocale.authFullNameLabel),
                      hint: AppLocale.format(AppLocale.authFullNameHint),
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_phoneFocus),
                      validator: _validateName,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    AuthFormField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hint: '01XXXXXXXXX',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      focusNode: _phoneFocus,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_emailFocus),
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 16),

                    // Email (Optional)
                    AuthFormField(
                      controller: _emailController,
                      label: '${AppLocale.format(AppLocale.authEmailLabel)} (Optional)',
                      hint: AppLocale.format(AppLocale.authEmailHint),
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AuthFormField(
                      controller: _passwordController,
                      label: AppLocale.format(AppLocale.authPasswordLabel),
                      hint: AppLocale.format(AppLocale.authPasswordTooShort),
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      textInputAction: TextInputAction.next,
                      focusNode: _passwordFocus,
                      onFieldSubmitted: () =>
                          FocusScope.of(context).requestFocus(_confirmFocus),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 16),

                    // Confirm password
                    AuthFormField(
                      controller: _confirmController,
                      label: AppLocale.format(AppLocale.authPasswordLabel),
                      hint: '••••••••',
                      prefixIcon: Icons.lock_outline_rounded,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      focusNode: _confirmFocus,
                      onFieldSubmitted: _submit,
                      validator: _validateConfirmPassword,
                    ),
                  ],
                ),
              ),

              // ── Password strength hint ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _PasswordHint(),
              ),

              // ── Error banner ─────────────────────────────────────────────
              Consumer<AuthProvider>(
                builder: (_, auth, _) {
                  if (auth.errorMessage == null) return const SizedBox.shrink();
                  return _ErrorBanner(message: auth.errorMessage!);
                },
              ),

              const SizedBox(height: 24),

              // ── Submit button ─────────────────────────────────────────────
              Consumer<AuthProvider>(
                builder: (_, auth, _) => FilledButton(
                  onPressed: auth.isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: auth.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AppLocale.format(AppLocale.authRegisterButton),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Back to login ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocale.format(AppLocale.authHaveAccount),
                    style: const TextStyle(color: AppColors.slate500),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthProvider>().clearError();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocale.format(AppLocale.authLoginButton),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Validators ─────────────────────────────────────────────────────────────

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required.';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone Number is required.';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocale.format(AppLocale.authEmailInvalid);
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocale.format(AppLocale.authPasswordRequired);
    }
    if (value.length < 8) {
      return AppLocale.format(AppLocale.authPasswordTooShort);
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least one uppercase letter.';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least one number.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocale.format(AppLocale.authPasswordRequired);
    }
    if (value != _passwordController.text) return 'Passwords do not match.';
    return null;
  }
}

// ── Local sub-widgets ─────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_add_outlined,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppLocale.format(AppLocale.authCreateAccount),
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocale.format(AppLocale.authRegisterSubtitle),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _PasswordHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate50,
        border: Border.all(color: AppColors.slate300.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.slate600,
            ),
          ),
          const SizedBox(height: 6),
          ...[
            '• At least 8 characters',
            '• At least one uppercase letter',
            '• At least one number',
          ].map(
            (req) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                req,
                style: TextStyle(fontSize: 12, color: AppColors.slate500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
