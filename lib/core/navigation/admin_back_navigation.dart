import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';

/// Locations where Android back may leave the app.
bool isAdminExitLocation(String location) {
  final path = _normalizePath(location);
  return path == AdminRoutes.dashboard ||
      path == AdminRoutes.login ||
      path == AdminRoutes.pinLock ||
      path == '/';
}

/// Parent path for nested admin routes (`/a/b/c` → `/a/b`).
String? parentAdminLocation(String location) {
  final normalized = _normalizePath(location);
  final segments = normalized.split('/').where((s) => s.isNotEmpty).toList();
  if (segments.length <= 1) {
    return null;
  }
  segments.removeLast();
  return '/${segments.join('/')}';
}

String _normalizePath(String location) {
  if (location.length > 1 && location.endsWith('/')) {
    return location.substring(0, location.length - 1);
  }
  return location.isEmpty ? '/' : location;
}

/// Shared back behavior for AppBar and the Android system back button.
///
/// Returns `true` when navigation stayed inside the app.
bool handleAdminBack(
  BuildContext context, {
  String fallbackRoute = AdminRoutes.dashboard,
}) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
    return true;
  }

  final location = router.state.uri.path;
  if (isAdminExitLocation(location)) {
    return false;
  }

  final parent = parentAdminLocation(location);
  if (parent != null && parent != location) {
    router.go(parent);
    return true;
  }

  if (location != fallbackRoute) {
    router.go(fallbackRoute);
    return true;
  }

  return false;
}

Future<void> invokeAdminSystemBack(BuildContext context) async {
  final handled = handleAdminBack(context);
  if (!handled) {
    await SystemNavigator.pop();
  }
}
