import 'public_intake.dart';
import 'public_intake_status.dart';
import 'public_intake_type.dart';

class PublicIntakeListQuery {
  const PublicIntakeListQuery({
    this.search = '',
    this.filter = PublicIntakeListFilter.all,
    this.type,
    this.language,
    this.country,
  });

  final String search;
  final PublicIntakeListFilter filter;
  final PublicIntakeType? type;
  final String? language;
  final String? country;

  PublicIntakeListQuery copyWith({
    String? search,
    PublicIntakeListFilter? filter,
    PublicIntakeType? type,
    String? language,
    String? country,
  }) {
    return PublicIntakeListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
      type: type ?? this.type,
      language: language ?? this.language,
      country: country ?? this.country,
    );
  }
}

bool publicIntakeMatchesFilter(PublicIntake intake, PublicIntakeListFilter filter) {
  return switch (filter) {
    PublicIntakeListFilter.all => true,
    PublicIntakeListFilter.newStatus => intake.status == PublicIntakeStatus.newStatus,
    PublicIntakeListFilter.reviewing =>
      intake.status == PublicIntakeStatus.reviewing,
    PublicIntakeListFilter.quoteDemo => intake.type.isHighPriority,
    PublicIntakeListFilter.contacted =>
      intake.status == PublicIntakeStatus.contacted ||
      intake.status == PublicIntakeStatus.quoted,
    PublicIntakeListFilter.closed =>
      intake.status == PublicIntakeStatus.rejected ||
      intake.status == PublicIntakeStatus.closed ||
      intake.status == PublicIntakeStatus.converted,
  };
}
