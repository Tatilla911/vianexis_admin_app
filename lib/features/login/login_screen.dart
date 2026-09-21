import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_config.dart';
import '../../app/app_theme.dart';
import '../../app/vianexis_brand.dart';
import '../../core/api/api_config.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/localization/localization_keys.dart';
import '../../core/localization/localization_resolver.dart';
import '../../core/widgets/vianexis_admin_background.dart';
import '../../core/widgets/vianexis_admin_card.dart';
import '../../core/widgets/vianexis_loading_view.dart';
import '../../core/widgets/vianexis_logo_mark.dart';
import '../../core/widgets/vianexis_metallic_text.dart';
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
  bool _rememberDevice = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onCredentialsChanged);
    _passwordController.addListener(_onCredentialsChanged);
  }

  void _onCredentialsChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _emailController
      ..removeListener(_onCredentialsChanged)
      ..dispose();
    _passwordController
      ..removeListener(_onCredentialsChanged)
      ..dispose();
    super.dispose();
  }

  bool get _credentialsReady =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(adminAuthProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          rememberDevice: _rememberDevice,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Login chrome is always the branded navy surface. Force dark tokens so
    // system light mode cannot paint dark ink on dark cards.
    return Theme(
      data: AppTheme.dark(),
      child: Builder(builder: (context) => _buildLogin(context)),
    );
  }

  Widget _buildLogin(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(adminAuthProvider);
    final errorKey = auth.errorMessageKey;
    final config = AppConfig.instance;
    final backendConfigured = ApiConfig.isConfigured;
    final theme = Theme.of(context);
    final primaryText = VianexisBrand.textPrimary;
    final secondaryText = VianexisBrand.textSecondary;
    final canSubmit = _credentialsReady && !auth.isLoading;

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
                            VianexisMetallicText(
                              l10n.loginTitle,
                              style: VianexisBrand.displayStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.loginSubtitle,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: secondaryText,
                                fontSize: 15,
                                height: 1.35,
                              ),
                            ),
                            if (config.safeApiHostDisplay != null &&
                                (config.environment.isStaging ||
                                    !config.environment.isProduction)) ...[
                              const SizedBox(height: 8),
                              Text(
                                l10n.loginStagingApiHost(
                                  config.safeApiHostDisplay!,
                                ),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text(
                              l10n.brandSecureAdminSession,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: VianexisBrand.goldAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (!backendConfigured) ...[
                              const SizedBox(height: 16),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: VianexisBrand.danger.withValues(
                                    alpha: 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    VianexisBrand.radiusSm,
                                  ),
                                  border: Border.all(
                                    color: VianexisBrand.danger.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    config.isProductionMisconfigured
                                        ? resolveAppConfigKey(
                                            context,
                                            'appConfigProductionLoginBlocked',
                                          )
                                        : l10n.authBackendNotConfigured,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFFFFC9C9),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
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
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: l10n.authEmail,
                                labelStyle: TextStyle(color: secondaryText),
                              ),
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
                              style: TextStyle(
                                color: primaryText,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                labelText: l10n.authPassword,
                                labelStyle: TextStyle(color: secondaryText),
                                suffixIcon: IconButton(
                                  onPressed: auth.isLoading
                                      ? null
                                      : () => setState(
                                            () => _obscurePassword =
                                                !_obscurePassword,
                                          ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: secondaryText,
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
                              onFieldSubmitted: (_) {
                                if (canSubmit) _submit();
                              },
                            ),
                            if (errorKey != null) ...[
                              const SizedBox(height: 16),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: VianexisBrand.danger.withValues(
                                    alpha: 0.16,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    VianexisBrand.radiusSm,
                                  ),
                                  border: Border.all(
                                    color: VianexisBrand.danger.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        resolveLocalizationKey(
                                          context,
                                          errorKey,
                                        ),
                                        softWrap: true,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: const Color(0xFFFFC9C9),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                      ),
                                      if (auth.canRetrySignIn) ...[
                                        const SizedBox(height: 12),
                                        OutlinedButton.icon(
                                          onPressed: canSubmit ? _submit : null,
                                          icon: const Icon(
                                            Icons.refresh,
                                            size: 18,
                                          ),
                          label: Text(
                            resolveLocalizationKey(
                              context,
                              LocalizationKeys.authRetryConnection,
                            ),
                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (auth.offlineSessionRestorePending) ...[
                              const SizedBox(height: 16),
                              Text(
                                l10n.authOfflineSessionRestorePending,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: secondaryText,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Material(
                              type: MaterialType.transparency,
                              child: SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                activeThumbColor: VianexisBrand.goldAccent,
                                activeTrackColor: VianexisBrand.goldAccent
                                    .withValues(alpha: 0.45),
                                inactiveThumbColor: secondaryText,
                                inactiveTrackColor: VianexisBrand.borderSubtle,
                                value: _rememberDevice,
                                onChanged: auth.isLoading
                                    ? null
                                    : (value) => setState(
                                          () => _rememberDevice = value,
                                        ),
                                title: Text(
                                  l10n.authRememberDevice,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: primaryText,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: canSubmit ? _submit : null,
                              child: auth.isLoading
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: VianexisBrand.brandInkOnGold,
                                          ),
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
                        forceHighContrastOnDark: true,
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
