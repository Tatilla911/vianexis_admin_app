class DefaultPackagingItem {
  const DefaultPackagingItem({
    required this.id,
    required this.name,
    this.localizedNameKey,
    this.localizedNames,
    this.active = true,
    this.sortOrder = 0,
    this.requiresReturn = false,
    this.allowQuantity = true,
    this.notes,
  });

  final String id;
  final String name;
  final String? localizedNameKey;
  final Map<String, String>? localizedNames;
  final bool active;
  final int sortOrder;
  final bool requiresReturn;
  final bool allowQuantity;
  final String? notes;

  factory DefaultPackagingItem.fromJson(Map<String, dynamic> json) {
    final rawLocalizedNames = json['localizedNames'];
    return DefaultPackagingItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      localizedNameKey: json['localizedNameKey']?.toString(),
      localizedNames: rawLocalizedNames is Map
          ? rawLocalizedNames.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : null,
      active: json['active'] != false && json['isActive'] != false,
      sortOrder: json['sortOrder'] is int
          ? json['sortOrder'] as int
          : int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,
      requiresReturn: json['requiresReturn'] == true,
      allowQuantity: json['allowQuantity'] != false,
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (localizedNameKey != null) 'localizedNameKey': localizedNameKey,
    if (localizedNames != null) 'localizedNames': localizedNames,
    'active': active,
    'isActive': active,
    'sortOrder': sortOrder,
    'requiresReturn': requiresReturn,
    'allowQuantity': allowQuantity,
    if (notes != null) 'notes': notes,
  };
}

class CompanyExchangeSettings {
  const CompanyExchangeSettings({
    required this.palletExchangeEnabled,
    required this.packagingExchangeEnabled,
    required this.allowDriverCustomPackagingItems,
    required this.defaultPalletTypes,
    required this.defaultPackagingItems,
  });

  final bool palletExchangeEnabled;
  final bool packagingExchangeEnabled;
  final bool allowDriverCustomPackagingItems;
  final List<String> defaultPalletTypes;
  final List<DefaultPackagingItem> defaultPackagingItems;

  factory CompanyExchangeSettings.fromJson(Map<String, dynamic> json) {
    final palletTypes = json['defaultPalletTypes'];
    final packagingItems = json['defaultPackagingItems'];
    return CompanyExchangeSettings(
      palletExchangeEnabled: json['palletExchangeEnabled'] != false,
      packagingExchangeEnabled: json['packagingExchangeEnabled'] != false,
      allowDriverCustomPackagingItems:
          json['allowDriverCustomPackagingItems'] != false,
      defaultPalletTypes: palletTypes is List
          ? palletTypes.map((value) => value.toString()).toList(growable: false)
          : const [],
      defaultPackagingItems: packagingItems is List
          ? packagingItems
                .whereType<Map<String, dynamic>>()
                .map(DefaultPackagingItem.fromJson)
                .toList(growable: false)
          : const [],
    );
  }

  CompanyExchangeSettings copyWith({
    bool? palletExchangeEnabled,
    bool? packagingExchangeEnabled,
    bool? allowDriverCustomPackagingItems,
    List<String>? defaultPalletTypes,
    List<DefaultPackagingItem>? defaultPackagingItems,
  }) {
    return CompanyExchangeSettings(
      palletExchangeEnabled:
          palletExchangeEnabled ?? this.palletExchangeEnabled,
      packagingExchangeEnabled:
          packagingExchangeEnabled ?? this.packagingExchangeEnabled,
      allowDriverCustomPackagingItems:
          allowDriverCustomPackagingItems ??
          this.allowDriverCustomPackagingItems,
      defaultPalletTypes: defaultPalletTypes ?? this.defaultPalletTypes,
      defaultPackagingItems:
          defaultPackagingItems ?? this.defaultPackagingItems,
    );
  }
}

class CompanyExchangeSettingsPatch {
  const CompanyExchangeSettingsPatch({
    this.palletExchangeEnabled,
    this.packagingExchangeEnabled,
    this.allowDriverCustomPackagingItems,
  });

  final bool? palletExchangeEnabled;
  final bool? packagingExchangeEnabled;
  final bool? allowDriverCustomPackagingItems;

  Map<String, dynamic> toJson() {
    return {
      if (palletExchangeEnabled != null)
        'palletExchangeEnabled': palletExchangeEnabled,
      if (packagingExchangeEnabled != null)
        'packagingExchangeEnabled': packagingExchangeEnabled,
      if (allowDriverCustomPackagingItems != null)
        'allowDriverCustomPackagingItems': allowDriverCustomPackagingItems,
    };
  }
}

class PackagingItemPatch {
  const PackagingItemPatch({
    this.name,
    this.localizedNames,
    this.sortOrder,
    this.isActive,
    this.notes,
  });

  final String? name;
  final Map<String, String>? localizedNames;
  final int? sortOrder;
  final bool? isActive;
  final String? notes;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (localizedNames != null) 'localizedNames': localizedNames,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (isActive != null) 'isActive': isActive,
      if (notes != null) 'notes': notes,
    };
  }
}
