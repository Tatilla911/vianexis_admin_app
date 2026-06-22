import '../auth/admin_user.dart';
import '../../app/app_router.dart';

/// Primary bottom-nav destinations on phones (max four before "More").
const mobilePrimaryDestinations = <AdminDestination>[
  AdminDestination.dashboard,
  AdminDestination.actionCenter,
  AdminDestination.registrations,
  AdminDestination.customerCommunications,
];

const mobileBottomNavMaxItems = 5;

bool isMobilePrimaryDestination(AdminDestination destination) {
  return mobilePrimaryDestinations.contains(destination);
}

bool isMoreHubRoute(String location) {
  return location == AdminRoutes.modulesHub ||
      location.startsWith('${AdminRoutes.modulesHub}/');
}

bool shouldHighlightMoreTab(String location, AdminDestination? destination) {
  if (isMoreHubRoute(location)) return true;
  if (destination == null) return false;
  return !isMobilePrimaryDestination(destination);
}
