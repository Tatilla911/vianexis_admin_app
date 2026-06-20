enum PlatformAdminUserStatus {
  active('active'),
  invited('invited'),
  suspended('suspended'),
  disabled('disabled'),
  unknown('unknown');

  const PlatformAdminUserStatus(this.backendValue);

  final String backendValue;

  static PlatformAdminUserStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in PlatformAdminUserStatus.values) {
      if (status.backendValue == raw) return status;
    }
    if (raw == 'inactive') return disabled;
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      active => 'adminUserStatusActive',
      invited => 'adminUserStatusInvited',
      suspended => 'adminUserStatusSuspended',
      disabled => 'adminUserStatusDisabled',
      unknown => 'adminUserStatusUnknown',
    };
  }

  bool get requiresReason => this == suspended || this == disabled;
}

enum AdminUserListFilter {
  all,
  active,
  invited,
  suspended,
  disabled,
}

extension PlatformAdminUserStatusFilter on PlatformAdminUserStatus {
  bool matchesFilter(AdminUserListFilter filter) {
    return switch (filter) {
      AdminUserListFilter.all => true,
      AdminUserListFilter.active => this == PlatformAdminUserStatus.active,
      AdminUserListFilter.invited => this == PlatformAdminUserStatus.invited,
      AdminUserListFilter.suspended => this == PlatformAdminUserStatus.suspended,
      AdminUserListFilter.disabled => this == PlatformAdminUserStatus.disabled,
    };
  }
}
