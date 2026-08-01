enum SystemMonitoringActionType { acknowledge, updateStatus, addNote }

class SystemMonitoringStatusUpdateRequest {
  const SystemMonitoringStatusUpdateRequest({
    required this.status,
    this.resolutionSummary,
  });

  final String status;
  final String? resolutionSummary;

  Map<String, dynamic> toJson() => {
    'status': status,
    if (resolutionSummary != null && resolutionSummary!.trim().isNotEmpty)
      'resolutionSummary': resolutionSummary!.trim(),
  };
}

class SystemMonitoringAcknowledgeRequest {
  const SystemMonitoringAcknowledgeRequest({this.note});

  final String? note;

  Map<String, dynamic> toJson() => {
    if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
  };
}

class SystemMonitoringNoteRequest {
  const SystemMonitoringNoteRequest({required this.note});

  final String note;

  Map<String, dynamic> toJson() => {'note': note.trim()};
}
