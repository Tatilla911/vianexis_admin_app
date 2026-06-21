import 'action_center_item.dart';
import 'action_center_item_type.dart';

enum ActionCenterFilter {
  all,
  registration,
  bulkOnboarding,
  support,
  systemHealth,
  security,
  billing,
  aiReview,
  customerCommunication,
  publicIntake,
  critical,
}

extension ActionCenterFilterX on ActionCenterFilter {
  String localizationKey() {
    return switch (this) {
      ActionCenterFilter.all => 'actionCenterFilterAll',
      ActionCenterFilter.registration => 'actionCenterFilterRegistration',
      ActionCenterFilter.bulkOnboarding => 'actionCenterFilterBulkOnboarding',
      ActionCenterFilter.support => 'actionCenterFilterSupport',
      ActionCenterFilter.systemHealth => 'actionCenterFilterSystemHealth',
      ActionCenterFilter.security => 'actionCenterFilterSecurity',
      ActionCenterFilter.billing => 'actionCenterFilterBilling',
      ActionCenterFilter.aiReview => 'actionCenterFilterAiReview',
      ActionCenterFilter.customerCommunication =>
        'actionCenterFilterCustomerCommunication',
      ActionCenterFilter.publicIntake => 'actionCenterFilterPublicIntake',
      ActionCenterFilter.critical => 'actionCenterFilterCritical',
    };
  }
}

class ActionCenterListQuery {
  const ActionCenterListQuery({
    this.search = '',
    this.filter = ActionCenterFilter.all,
  });

  final String search;
  final ActionCenterFilter filter;

  ActionCenterListQuery copyWith({
    String? search,
    ActionCenterFilter? filter,
  }) {
    return ActionCenterListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

bool actionCenterItemMatchesFilter(ActionCenterItem item, ActionCenterFilter filter) {
  return switch (filter) {
    ActionCenterFilter.all => true,
    ActionCenterFilter.registration => item.type == ActionCenterItemType.registration,
    ActionCenterFilter.bulkOnboarding =>
      item.type == ActionCenterItemType.bulkOnboarding,
    ActionCenterFilter.support => item.type == ActionCenterItemType.support,
    ActionCenterFilter.systemHealth => item.type == ActionCenterItemType.systemHealth,
    ActionCenterFilter.security => item.type == ActionCenterItemType.security,
    ActionCenterFilter.billing => item.type == ActionCenterItemType.billing ||
      (item.type == ActionCenterItemType.customerCommunication &&
          (item.sourceType.contains('subscription') ||
              item.summary.toLowerCase().contains('subscription') ||
              item.summary.toLowerCase().contains('billing') ||
              item.summary.toLowerCase().contains('package'))),
    ActionCenterFilter.aiReview => item.type == ActionCenterItemType.aiReview,
    ActionCenterFilter.customerCommunication =>
      item.type == ActionCenterItemType.customerCommunication,
    ActionCenterFilter.publicIntake =>
      item.type == ActionCenterItemType.publicIntake,
    ActionCenterFilter.critical =>
      item.priority == ActionCenterPriority.critical ||
      item.priority == ActionCenterPriority.urgent,
  };
}
