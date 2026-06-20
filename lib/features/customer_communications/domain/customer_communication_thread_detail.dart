import 'customer_agreement_snapshot.dart';
import 'customer_communication_message.dart';
import 'customer_communication_thread.dart';
import 'customer_evidence_package.dart';

class CustomerCommunicationThreadDetail {
  const CustomerCommunicationThreadDetail({
    required this.thread,
    required this.messages,
    required this.agreementSnapshots,
    required this.evidencePackages,
    this.metadataOnly = false,
  });

  final CustomerCommunicationThread thread;
  final List<CustomerCommunicationMessage> messages;
  final List<CustomerAgreementSnapshot> agreementSnapshots;
  final List<CustomerEvidencePackage> evidencePackages;
  final bool metadataOnly;
}
