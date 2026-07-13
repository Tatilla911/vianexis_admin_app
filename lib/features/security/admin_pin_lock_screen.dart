import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/admin_auth_state.dart';
import '../../core/security/admin_device_pin_service.dart';
import '../../core/widgets/vianexis_admin_background.dart';
import '../../core/widgets/vianexis_admin_card.dart';
import '../../core/widgets/vianexis_logo_mark.dart';
import '../../l10n/app_localizations.dart';

class AdminPinLockScreen extends ConsumerStatefulWidget {
  const AdminPinLockScreen({super.key});

  @override
  ConsumerState<AdminPinLockScreen> createState() => _AdminPinLockScreenState();
}

class _AdminPinLockScreenState extends ConsumerState<AdminPinLockScreen> {
  final _pinController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _pinController.text;
    final service = ref.read(adminDevicePinServiceProvider);
    final valid = await service.verifyPin(pin);
    if (!mounted) return;
    if (valid) {
      await ref.read(adminAuthProvider.notifier).unlockPin();
      return;
    }
    setState(() {
      _errorText = AppLocalizations.of(context).devicePinInvalidCurrent;
      _pinController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(adminAuthProvider);

    return Scaffold(
      body: VianexisAdminBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: VianexisAdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: VianexisLogoMark(size: 64)),
                      const SizedBox(height: 20),
                      Text(
                        l10n.devicePinSectionTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.devicePinSectionBody),
                      if (auth.offlineSessionRestorePending) ...[
                        const SizedBox(height: 12),
                        Text(
                          l10n.authOfflineSessionRestorePending,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _pinController,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: l10n.devicePinCurrentLabel,
                        ),
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _submit,
                        child: Text(l10n.authSignIn),
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
