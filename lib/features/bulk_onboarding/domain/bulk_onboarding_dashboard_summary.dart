import 'bulk_onboarding_job.dart';
import 'bulk_onboarding_risk_level.dart';
import 'bulk_onboarding_status.dart';

class BulkOnboardingDashboardSummary {
  const BulkOnboardingDashboardSummary({
    required this.jobsWaitingForReview,
    required this.highRiskJobs,
    required this.invalidRows,
    required this.processingJobs,
  });

  final int jobsWaitingForReview;
  final int highRiskJobs;
  final int invalidRows;
  final int processingJobs;

  factory BulkOnboardingDashboardSummary.fromJobs(List<BulkOnboardingJob> jobs) {
    var waiting = 0;
    var highRisk = 0;
    var invalidRows = 0;
    var processing = 0;

    for (final job in jobs) {
      if (job.status == BulkOnboardingJobStatus.readyForReview) {
        waiting++;
      }
      if (job.riskLevel == BulkOnboardingRiskLevel.high) {
        highRisk++;
      }
      invalidRows += job.invalidRows;
      if (job.status == BulkOnboardingJobStatus.processing ||
          job.status == BulkOnboardingJobStatus.approvedForProcessing) {
        processing++;
      }
    }

    return BulkOnboardingDashboardSummary(
      jobsWaitingForReview: waiting,
      highRiskJobs: highRisk,
      invalidRows: invalidRows,
      processingJobs: processing,
    );
  }
}
