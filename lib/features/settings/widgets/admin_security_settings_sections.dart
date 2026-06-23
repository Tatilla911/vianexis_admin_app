import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/locale/app_locale_provider.dart';
import '../../../core/security/admin_device_pin_service.dart';
import '../../../core/widgets/vianexis_admin_card.dart';
import '../../../core/widgets/vianexis_section_header.dart';
import '../../../l10n/app_localizations.dart';

class AdminAccountPasswordSection extends ConsumerWidget {
  const AdminAccountPasswordSection({super.key});

  static const int minPasswordLength = 16;

  Future<void> _showChangePasswordDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var obscureCurrent = true;
    var obscureNew = true;
    var obscureConfirm = true;
    var submitting = false;

    final success = await showDialog<bool>(
      context: context,
      barrierDismissible: !submitting,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.settingsChangePasswordTitle),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.settingsChangePasswordBody),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: currentController,
                        obscureText: obscureCurrent,
                        enabled: !submitting,
                        decoration: InputDecoration(
                          labelText: l10n.settingsCurrentPasswordLabel,
                          suffixIcon: IconButton(
                            onPressed: submitting
                                ? null
                                : () => setState(() => obscureCurrent = !obscureCurrent),
                            icon: Icon(
                              obscureCurrent
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            (value == null || value.isEmpty) ? l10n.authRequiredField : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: newController,
                        obscureText: obscureNew,
                        enabled: !submitting,
                        decoration: InputDecoration(
                          labelText: l10n.settingsNewPasswordLabel,
                          suffixIcon: IconButton(
                            onPressed: submitting
                                ? null
                                : () => setState(() => obscureNew = !obscureNew),
                            icon: Icon(
                              obscureNew
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.authRequiredField;
                          }
                          if (value.length < minPasswordLength) {
                            return l10n.settingsPasswordMinLengthValidation;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: confirmController,
                        obscureText: obscureConfirm,
                        enabled: !submitting,
                        decoration: InputDecoration(
                          labelText: l10n.settingsConfirmPasswordLabel,
                          suffixIcon: IconButton(
                            onPressed: submitting
                                ? null
                                : () => setState(() => obscureConfirm = !obscureConfirm),
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.authRequiredField;
                          }
                          if (value != newController.text) {
                            return l10n.settingsPasswordMismatchValidation;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(false),
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                ),
                FilledButton(
                  onPressed: submitting
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setState(() => submitting = true);
                          final changed = await ref
                              .read(adminAuthProvider.notifier)
                              .changePassword(
                                currentPassword: currentController.text,
                                newPassword: newController.text,
                              );
                          if (!dialogContext.mounted) return;
                          if (changed) {
                            Navigator.of(dialogContext).pop(true);
                          } else {
                            setState(() => submitting = false);
                            final errorKey =
                                ref.read(adminAuthProvider).errorMessageKey;
                            if (errorKey != null) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    resolveLocalizationKey(dialogContext, errorKey),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.settingsChangePasswordAction),
                ),
              ],
            );
          },
        );
      },
    );

    currentController.dispose();
    newController.dispose();
    confirmController.dispose();

    if (success == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsPasswordChangeSuccess)),
      );
      context.go(AdminRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VianexisSectionHeader(title: l10n.settingsAccountSecuritySection),
        const SizedBox(height: 12),
        VianexisAdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.settingsChangePasswordBody),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => _showChangePasswordDialog(context, ref),
                child: Text(l10n.settingsChangePasswordAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminPinSettingsSection extends ConsumerStatefulWidget {
  const AdminPinSettingsSection({super.key});

  @override
  ConsumerState<AdminPinSettingsSection> createState() =>
      _AdminPinSettingsSectionState();
}

class _AdminPinSettingsSectionState extends ConsumerState<AdminPinSettingsSection> {
  bool _hasPin = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final hasPin = await ref.read(adminDevicePinServiceProvider).hasPin();
    if (!mounted) return;
    setState(() {
      _hasPin = hasPin;
      _loading = false;
    });
  }

  Future<void> _showPinDialog({
    required String title,
    required bool requireCurrent,
    required bool requireNew,
    required bool requireConfirm,
    required Future<void> Function(String current, String next) onSubmit,
  }) async {
    final l10n = AppLocalizations.of(context);
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (requireCurrent)
                  TextFormField(
                    controller: currentController,
                    decoration: InputDecoration(
                      labelText: l10n.devicePinCurrentLabel,
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? ' ' : null,
                  ),
                if (requireNew)
                  TextFormField(
                    controller: newController,
                    decoration: InputDecoration(
                      labelText: l10n.devicePinNewLabel,
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return ' ';
                      if (value.length < AdminDevicePinService.minPinLength ||
                          value.length > AdminDevicePinService.maxPinLength) {
                        return l10n.devicePinInvalidLength;
                      }
                      if (!RegExp(r'^\d+$').hasMatch(value)) {
                        return l10n.devicePinNonNumeric;
                      }
                      return null;
                    },
                  ),
                if (requireConfirm)
                  TextFormField(
                    controller: confirmController,
                    decoration: InputDecoration(
                      labelText: l10n.devicePinConfirmLabel,
                    ),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validator: (value) {
                      if (value != newController.text) {
                        return l10n.devicePinMismatch;
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.publicIntakeCancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                Navigator.of(context).pop(true);
              },
              child: Text(title),
            ),
          ],
        );
      },
    );

    if (ok != true || !mounted) return;

    try {
      await onSubmit(currentController.text, newController.text);
      if (!mounted) return;
      await _refresh();
    } on AdminDevicePinException catch (error) {
      if (!mounted) return;
      final message = switch (error) {
        AdminDevicePinException.invalidCurrentPin => l10n.devicePinInvalidCurrent,
        AdminDevicePinException.invalidLength => l10n.devicePinInvalidLength,
        AdminDevicePinException.nonNumeric => l10n.devicePinNonNumeric,
        AdminDevicePinException.mismatch => l10n.devicePinMismatch,
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VianexisSectionHeader(title: l10n.devicePinSectionTitle),
        const SizedBox(height: 12),
        VianexisAdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.devicePinSectionBody),
              const SizedBox(height: 16),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (!_hasPin)
                FilledButton.tonal(
                  onPressed: () => _showPinDialog(
                    title: l10n.devicePinSetAction,
                    requireCurrent: false,
                    requireNew: true,
                    requireConfirm: true,
                    onSubmit: (_, next) async {
                      await ref
                          .read(adminDevicePinServiceProvider)
                          .setPin(next);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.devicePinSetSuccess)),
                      );
                    },
                  ),
                  child: Text(l10n.devicePinSetAction),
                )
              else ...[
                OutlinedButton(
                  onPressed: () => _showPinDialog(
                    title: l10n.devicePinChangeAction,
                    requireCurrent: true,
                    requireNew: true,
                    requireConfirm: true,
                    onSubmit: (current, next) async {
                      final service = ref.read(adminDevicePinServiceProvider);
                      final ok = await service.changePin(
                        currentPin: current,
                        newPin: next,
                      );
                      if (!ok) {
                        throw AdminDevicePinException.invalidCurrentPin;
                      }
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.devicePinChangeSuccess)),
                      );
                    },
                  ),
                  child: Text(l10n.devicePinChangeAction),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => _showPinDialog(
                    title: l10n.devicePinRemoveAction,
                    requireCurrent: true,
                    requireNew: false,
                    requireConfirm: false,
                    onSubmit: (current, _) async {
                      await ref
                          .read(adminDevicePinServiceProvider)
                          .removePin(currentPin: current);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.devicePinRemoveSuccess)),
                      );
                    },
                  ),
                  child: Text(l10n.devicePinRemoveAction),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class AdminLanguageSettingsSection extends ConsumerWidget {
  const AdminLanguageSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(appLocaleProvider);
    final selected = locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VianexisSectionHeader(title: l10n.settingsLanguageSection),
        const SizedBox(height: 12),
        VianexisAdminCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.settingsLanguageBody),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: [
                  ButtonSegment(
                    value: 'hu',
                    label: Text(l10n.settingsLanguageHu),
                  ),
                  ButtonSegment(
                    value: 'en',
                    label: Text(l10n.settingsLanguageEn),
                  ),
                ],
                selected: {selected},
                onSelectionChanged: (values) {
                  final code = values.first;
                  ref
                      .read(appLocaleProvider.notifier)
                      .setLocale(Locale(code));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
