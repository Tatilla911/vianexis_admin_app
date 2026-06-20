class NotificationPreferences {
  const NotificationPreferences({
    this.systemHealth = true,
    this.security = true,
    this.support = true,
    this.billing = false,
    this.release = false,
    this.inAppOnly = true,
  });

  final bool systemHealth;
  final bool security;
  final bool support;
  final bool billing;
  final bool release;
  final bool inAppOnly;

  NotificationPreferences copyWith({
    bool? systemHealth,
    bool? security,
    bool? support,
    bool? billing,
    bool? release,
    bool? inAppOnly,
  }) {
    return NotificationPreferences(
      systemHealth: systemHealth ?? this.systemHealth,
      security: security ?? this.security,
      support: support ?? this.support,
      billing: billing ?? this.billing,
      release: release ?? this.release,
      inAppOnly: inAppOnly ?? this.inAppOnly,
    );
  }

  String? validate() {
    if (![systemHealth, security, support, billing, release].contains(true)) {
      return 'notificationsPrefValidationAtLeastOne';
    }
    if (!inAppOnly) {
      return 'notificationsPrefValidationInAppOnly';
    }
    return null;
  }

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      systemHealth: json['systemHealth'] != false,
      security: json['security'] != false,
      support: json['support'] != false,
      billing: json['billing'] == true,
      release: json['release'] == true,
      inAppOnly: json['inAppOnly'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'systemHealth': systemHealth,
      'security': security,
      'support': support,
      'billing': billing,
      'release': release,
      'inAppOnly': inAppOnly,
    };
  }
}
