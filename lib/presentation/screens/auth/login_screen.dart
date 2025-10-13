import 'package:flutter/material.dart';
import 'package:museum_app/core/theme/app_colors.dart';
import 'package:museum_app/core/theme/app_text_styles.dart';
import 'package:museum_app/l10n/app_localizations.dart';
import 'package:museum_app/presentation/navigation/main_navigation.dart';
import 'package:museum_app/presentation/providers/login_provider.dart';
import 'package:museum_app/presentation/providers/auth_provider.dart';
import 'package:museum_app/presentation/widgets/social_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<bool> _showCaptchaSheet(BuildContext context) async {
    final provider = context.read<LoginProvider>();
    final l10n = AppLocalizations.of(context)!;

    provider.resetCaptcha();

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final viewInsets = MediaQuery.of(sheetContext).viewInsets.bottom;
        return ChangeNotifierProvider<LoginProvider>.value(
          value: provider,
          child: Padding(
            padding: EdgeInsets.only(bottom: viewInsets),
            child: _CaptchaBottomSheet(l10n: l10n),
          ),
        );
      },
    );

    provider.resetCaptcha();

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final viewPadding = MediaQuery.paddingOf(context);
    final l10n = AppLocalizations.of(context)!;
    // final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          bottom: false,
          child: GestureDetector(
            onTap: () {
              // Ocultar el teclado cuando se hace tap fuera de los campos de texto
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                _LogoHeader(topPadding: viewPadding.top),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Consumer<LoginProvider>(
                      builder: (context, provider, _) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _EmailField(
                              label: l10n.emailLabel,
                              value: provider.email,
                              hintText: 'Loisbecket@gmail.com',
                              onChanged: provider.updateEmail,
                            ),
                            const SizedBox(height: 16),
                            _PasswordField(
                              label: l10n.passwordLabel,
                              value: provider.password,
                              hintText: '••••••••',
                              obscureText: provider.obscurePassword,
                              onChanged: provider.updatePassword,
                              onToggleVisibility:
                                  provider.togglePasswordVisibility,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Checkbox(
                                  value: provider.rememberMe,
                                  onChanged: (value) {
                                    provider.setRememberMe(value ?? false);
                                  },
                                ),
                                Text(l10n.rememberMe),
                              ],
                            ),
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: authProvider.isLoading
                                          ? null
                                          : () async {
                                              final success = await provider
                                                  .resetPassword(authProvider);
                                              if (!context.mounted) return;

                                              if (success) {
                                                // Mostrar mensaje de éxito
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Se ha enviado un email para restablecer tu contraseña',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'Urbanist'),
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            },
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.secondary,
                                      ),
                                      child: Text(l10n.forgotPassword),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            if (provider.error != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Text(
                                  provider.error!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (provider.error != null)
                              const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<AuthProvider>(
                                builder: (context, authProvider, _) {
                                  return ElevatedButton(
                                    onPressed: provider.canSubmit &&
                                            !authProvider.isLoading
                                        ? () async {
                                            FocusScope.of(context).unfocus();
                                            final solved =
                                                await _showCaptchaSheet(
                                                    context);
                                            if (!context.mounted || !solved) {
                                              return;
                                            }

                                            final success = await provider
                                                .performLoginWithAuthProvider(
                                                    authProvider);
                                            if (!context.mounted) return;

                                            if (success) {
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      const MainNavigation(),
                                                ),
                                                (route) => false,
                                              );
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: authProvider.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          )
                                        : Text(
                                            l10n.logInButton,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Urbanist',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black.withValues(alpha: 0.08),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    l10n.orLoginWith,
                                    style: const TextStyle(
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.black.withValues(alpha: 0.08),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SocialButton(
                                        label: l10n.google,
                                        assetPath: 'assets/google_icon.png',
                                        onPressed: authProvider.isLoading
                                            ? null
                                            : () async {
                                                final success = await provider
                                                    .signInWithGoogle(
                                                        authProvider);
                                                if (!context.mounted) return;

                                                if (success) {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const MainNavigation(),
                                                    ),
                                                    (route) => false,
                                                  );
                                                }
                                              },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: SocialButton(
                                        label: l10n.apple,
                                        assetPath: 'assets/apple_icon.png',
                                        onPressed: authProvider.isLoading
                                            ? null
                                            : () async {
                                                final success = await provider
                                                    .signInWithApple(
                                                        authProvider);
                                                if (!context.mounted) return;

                                                if (success) {
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const MainNavigation(),
                                                    ),
                                                    (route) => false,
                                                  );
                                                }
                                              },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  l10n.createAccount,
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32 + viewPadding.bottom),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                /*_TermsFooter(
                  prefix: l10n.signupAgreementPrefix,
                  conjunction: l10n.signupAgreementConjunction,
                  termsLabel: l10n.termsOfService,
                  dataLabel: l10n.dataProcessingAgreement,
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  final double topPadding;

  const _LogoHeader({required this.topPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D1B),
      ),
      padding: EdgeInsets.only(top: topPadding + 48, bottom: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo.png',
            width: 72,
            height: 72,
          ),
        ],
      ),
    );
  }
}

class _EmailField extends StatefulWidget {
  final String label;
  final String value;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _EmailField({
    required this.label,
    required this.value,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<_EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<_EmailField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value)
      ..addListener(_handleChange);
  }

  @override
  void didUpdateWidget(covariant _EmailField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller
        ..removeListener(_handleChange)
        ..text = widget.value
        ..selection = TextSelection.collapsed(offset: widget.value.length)
        ..addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() {
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              color: Color(0xFF9E9E9E),
            ),
            filled: true,
            fillColor: const Color(0xFFF2F3F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  final String label;
  final String value;
  final String hintText;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final ValueChanged<String> onChanged;

  const _PasswordField({
    required this.label,
    required this.value,
    required this.hintText,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.onChanged,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value)
      ..addListener(_handleChange);
  }

  @override
  void didUpdateWidget(covariant _PasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller
        ..removeListener(_handleChange)
        ..text = widget.value
        ..selection = TextSelection.collapsed(offset: widget.value.length)
        ..addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() {
    widget.onChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 16,
              letterSpacing: 2,
              color: Color(0xFF9E9E9E),
            ),
            filled: true,
            fillColor: const Color(0xFFF2F3F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                widget.obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility,
                color: const Color(0xFF9E9E9E),
              ),
              onPressed: widget.onToggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}

class _CaptchaChallenge extends StatelessWidget {
  final AppLocalizations l10n;

  const _CaptchaChallenge({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    IconData _iconForId(String id) {
      switch (id) {
        case 'museum':
          return Icons.museum_outlined;
        case 'palette':
          return Icons.palette_outlined;
        case 'theater':
          return Icons.theaters_outlined;
        default:
          return Icons.help_outline;
      }
    }

    String _labelForId(String id, bool isSelected) {
      final position = provider.selectedCaptcha.indexOf(id) + 1;
      final baseLabel = switch (id) {
        'museum' => l10n.captchaMuseumLabel,
        'palette' => l10n.captchaPaletteLabel,
        'theater' => l10n.captchaTheaterLabel,
        _ => l10n.captchaInstruction,
      };

      if (position > 0 && !isSelected) {
        return '#$position';
      }
      return baseLabel;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: provider.captchaOptions.map((id) {
            final isSelected = provider.isCaptchaOptionSelected(id);
            final isEnabled = provider.isCaptchaOptionEnabled(id);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: isEnabled
                      ? () {
                          provider.selectCaptchaItem(id);
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondary
                          : const Color(0xFFF2F3F5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: provider.showCaptchaError
                            ? Colors.red.withOpacity(0.4)
                            : Colors.transparent,
                        width: 1.4,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.secondary.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _iconForId(id),
                          size: 32,
                          color:
                              isSelected ? Colors.white : AppColors.secondary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _labelForId(id, isSelected),
                          style: AppTextStyles.body.copyWith(
                            fontSize: 12,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CaptchaBottomSheet extends StatelessWidget {
  final AppLocalizations l10n;

  const _CaptchaBottomSheet({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.logInButton,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'Playfair',
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.captchaInstruction,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _CaptchaChallenge(l10n: l10n),
            const SizedBox(height: 24),
            if (provider.showCaptchaError)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 18, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.captchaReset,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        provider.resetCaptcha();
                      },
                      child: Text(
                        l10n.retry,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!provider.showCaptchaError)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    provider.resetCaptcha();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    l10n.captchaReset,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.captchaSolved
                    ? () {
                        FocusScope.of(context).unfocus();
                        Navigator.of(context).pop(true);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  provider.captchaSolved
                      ? l10n.captchaSolved
                      : l10n.captchaInstruction,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
