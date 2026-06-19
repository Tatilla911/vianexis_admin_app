enum SupportTicketActionType {
  acknowledge,
  close,
}

class SupportTicketActionRequest {
  const SupportTicketActionRequest({
    required this.type,
    this.note,
  });

  final SupportTicketActionType type;
  final String? note;

  Map<String, dynamic> toJson() {
    return switch (type) {
      SupportTicketActionType.acknowledge => {
        if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      },
      SupportTicketActionType.close => {
        'note': note!.trim(),
      },
    };
  }

  String endpointSuffix() {
    return switch (type) {
      SupportTicketActionType.acknowledge => 'acknowledge',
      SupportTicketActionType.close => 'close',
    };
  }
}
