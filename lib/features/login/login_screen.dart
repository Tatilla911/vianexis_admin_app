import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_config.dart';
import '../../core/api/api_config.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/localization/localization_resolver.dart';
import '../../core/widgets/vianexis_admin_background.dart';
import '../../core/widgets/vianexis_admin_card.dart';
import '../../core/widgets/vianexis_loading_view.dart';
import '../../core/widgets/vianexis_logo_mark.dart';
import '../../core/widgets/vianexis_metadata_notice.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(adminAuthProvider.notifier).signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(adminAuthProvider);
    final errorKey = auth.errorMessageKey;
    final config = AppConfig.instance;
    final backendConfigured = ApiConfig.isConfigured;

    if (auth.isRestoringSession) {
      return const Scaffold(
        body: VianexisAdminBackground(child: VianexisLoadingView()),
      );
    }

    return Scaffold(
      body: VianexisAdminBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: VianexisLogoMark(size: 80)),
                      const SizedBox(height: 28),
                      VianexisAdminCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l10n.loginTitle,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(l10n.loginSubtitle),
                            if (config.environment.isStaging &&
                                config.safeApiHostDisplay != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.loginStagingApiHost(config.safeApiHostDisplay!),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              l10n.brandSecureAdminSession,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            if (!backendConfigured) ...[
                              const SizedBox(height: 16),
                              Text(
                                config.isProductionMisconfigured
                                    ? resolveAppConfigKey(
                                        context,
                                        'appConfigProductionLoginBlocked',
                                      )
                                    : l10n.authBackendNotConfigured,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _emailController,
                              enabled: !auth.isLoading,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(labelText: l10n.authEmail),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return l10n.authRequiredField;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !auth.isLoading,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: l10n.authPassword,
                                suffixIcon: IconButton(
                                  onPressed: auth.isLoading
                                      ? null
                                      : () => setState(
                                          () => _obscurePassword = !_obscurePassword,
                                        ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                  tooltip: _obscurePassword
                                      ? l10n.authShowPassword
                                      : l10n.authHidePassword,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.authRequiredField;
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) => _submit(),
                            ),
                            if (errorKey != null) ...[
                              const SizedBox(height: 16),
                              Text(
                                resolveLocalizationKey(context, errorKey),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed:
                                  auth.isLoading || !backendConfigured ? null : _submit,
                              child: auth.isLoading
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(l10n.authSigningIn),
                                      ],
                                    )
                                  : Text(l10n.authSignIn),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      VianexisMetadataNotice(
                        message: l10n.brandAdminOnlyAccess,
                        badgeLabel: l10n.brandMetadataOnlyPlatformView,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
