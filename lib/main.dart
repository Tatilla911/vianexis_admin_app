import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/vianexis_admin_app.dart';
import 'services/alerts/admin_local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdminLocalNotificationService.instance.initialize();
  runApp(const ProviderScope(child: VianexisAdminApp()));
}
