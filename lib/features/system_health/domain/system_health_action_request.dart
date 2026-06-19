enum SystemHealthActionType {
  acknowledge,
  escalate,
}

class SystemHealthActionRequest {
  const SystemHealthActionRequest({
    required this.type,
    this.note,
  });

  final SystemHealthActionType type;
  final String? note;

  Map<String, dynamic> toJson() {
    return switch (type) {
      SystemHealthActionType.acknowledge => {
        if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      },
      SystemHealthActionType.escalate => {
        'note': note!.trim(),
      },
    };
  }

  String endpointSuffix() {
    return switch (type) {
      SystemHealthActionType.acknowledge => 'acknowledge',
      SystemHealthActionType.escalate => 'escalate',
    };
  }

  String httpMethod() {
    return switch (type) {
      SystemHealthActionType.acknowledge => 'PATCH',
      SystemHealthActionType.escalate => 'POST',
    };
  }
}
