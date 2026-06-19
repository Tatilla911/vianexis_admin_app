// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get appTitle => 'ViaNexis Admin';

  @override
  String get navDashboard => 'Irányítópult';

  @override
  String get navRegistrations => 'Regisztrációk';

  @override
  String get navSupport => 'Támogatás';

  @override
  String get navSystemHealth => 'Rendszerállapot';

  @override
  String get navAuditLogs => 'Audit napló';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get loginTitle => 'Platform belépés';

  @override
  String get loginSubtitle => 'Jelentkezzen be ViaNexis platform fiókjával.';

  @override
  String get authEmail => 'E-mail';

  @override
  String get authPassword => 'Jelszó';

  @override
  String get authSignIn => 'Belépés';

  @override
  String get authSigningIn => 'Belépés…';

  @override
  String get authLogout => 'Kijelentkezés';

  @override
  String get authInvalidCredentials => 'Érvénytelen e-mail vagy jelszó.';

  @override
  String get authNetworkError =>
      'Hálózati hiba. Ellenőrizze a kapcsolatot, majd próbálja újra.';

  @override
  String get authServerError => 'Szerverhiba. Próbálja újra később.';

  @override
  String get authForbiddenRole =>
      'Ez a fiók nem jogosult a platform admin alkalmazás használatára.';

  @override
  String get authBackendNotConfigured =>
      'A backend kapcsolat még nincs beállítva.';

  @override
  String get authRequiredField => 'A mező kitöltése kötelező.';

  @override
  String get authShowPassword => 'Jelszó megjelenítése';

  @override
  String get authHidePassword => 'Jelszó elrejtése';

  @override
  String get loginEmailLabel => 'E-mail';

  @override
  String get loginPasswordLabel => 'Jelszó';

  @override
  String get loginSignInButton => 'Belépés';

  @override
  String get loginBackendNotConfigured =>
      'A backend kapcsolat még nincs beállítva.';

  @override
  String get dashboardTitle => 'Platform irányítópult';

  @override
  String get dashboardPlaceholderBody =>
      'Az operatív összesítések és platform mutatók itt jelennek meg.';

  @override
  String get registrationsTitle => 'Regisztrációs kérelmek';

  @override
  String get registrationsPlaceholderBody =>
      'A függőben lévő cég onboarding kérelmek itt jelennek meg.';

  @override
  String get registrationDetailTitle => 'Regisztrációs kérelem';

  @override
  String get registrationDetailPlaceholderBody =>
      'A kérelem metaadatai és felülvizsgálati műveletek itt jelennek meg.';

  @override
  String get aiReviewsTitle => 'AI felülvizsgálati összesítők';

  @override
  String get aiReviewsPlaceholderBody =>
      'Az AI által javasolt felülvizsgálati ajánlások itt jelennek meg.';

  @override
  String get supportTicketsTitle => 'Támogatási jegyek';

  @override
  String get supportTicketsPlaceholderBody =>
      'A támogatási jegyek metaadatai itt jelennek meg.';

  @override
  String get supportGrantsTitle => 'Támogatási hozzáférési engedélyek';

  @override
  String get supportGrantsPlaceholderBody =>
      'A korlátozott támogatási engedélyek metaadatai itt jelennek meg.';

  @override
  String get systemHealthTitle => 'Rendszerállapot';

  @override
  String get systemHealthPlaceholderBody =>
      'A platform állapotdiagnosztika itt jelenik meg.';

  @override
  String get auditLogsTitle => 'Audit napló';

  @override
  String get auditLogsPlaceholderBody =>
      'A szűrt platform audit metaadatok itt jelennek meg.';

  @override
  String get settingsTitle => 'Beállítások';

  @override
  String get settingsPlaceholderBody =>
      'A fiók- és alkalmazásbeállítások itt jelennek meg.';

  @override
  String get privacyMetadataOnlyBadge => 'Csak metaadat';

  @override
  String get privacyNoOperationalContent =>
      'Az operatív fuvar-, dokumentum- és üzenettartalom nem jelenik meg ebben az alkalmazásban.';

  @override
  String get roleSuperAdmin => 'Szuper admin';

  @override
  String get roleSupportAdmin => 'Támogatás admin';

  @override
  String get roleOnboardingReviewer => 'Onboarding felülvizsgáló';

  @override
  String get roleBillingAdmin => 'Számlázás admin';

  @override
  String get errorGenericTitle => 'Hiba történt';

  @override
  String get errorGenericBody => 'Váratlan hiba történt. Próbálja újra.';

  @override
  String get errorRetryButton => 'Újra';

  @override
  String get loadingLabel => 'Betöltés';

  @override
  String get statusHealthy => 'Egészséges';

  @override
  String get statusDegraded => 'Romlott';

  @override
  String get statusUnknown => 'Ismeretlen';

  @override
  String get settingsSignOut => 'Kijelentkezés';

  @override
  String settingsAppVersion(String version) {
    return 'Verzió: $version';
  }

  @override
  String get validationEmailRequired => 'Az e-mail megadása kötelező.';

  @override
  String get validationPasswordRequired => 'A jelszó megadása kötelező.';

  @override
  String get registrationFilterAll => 'Összes';

  @override
  String get registrationFilterPending => 'Függőben';

  @override
  String get registrationFilterNeedsInfo => 'További adat kell';

  @override
  String get registrationFilterAiReviewed => 'AI felülvizsgált';

  @override
  String get registrationFilterApproved => 'Jóváhagyva';

  @override
  String get registrationFilterRejected => 'Elutasítva';

  @override
  String get registrationFilterHighRisk => 'Magas kockázat';

  @override
  String get registrationStatusPending => 'Függőben';

  @override
  String get registrationStatusNeedsInfo => 'További adat kell';

  @override
  String get registrationStatusApproved => 'Jóváhagyva';

  @override
  String get registrationStatusRejected => 'Elutasítva';

  @override
  String get registrationStatusCancelled => 'Visszavonva';

  @override
  String get registrationStatusUnknown => 'Ismeretlen';

  @override
  String get registrationRiskLow => 'Alacsony kockázat';

  @override
  String get registrationRiskMedium => 'Közepes kockázat';

  @override
  String get registrationRiskHigh => 'Magas kockázat';

  @override
  String get registrationRiskUnknown => 'Ismeretlen kockázat';

  @override
  String get registrationTypeCompany => 'Cég';

  @override
  String get registrationTypeUser => 'Felhasználó';

  @override
  String get registrationTypeBulkOnboarding => 'Tömeges onboarding';

  @override
  String get registrationSearchHint =>
      'Keresés cég, adószám, ország vagy e-mail alapján';

  @override
  String get registrationListEmpty =>
      'Nincs a szűrőknek megfelelő regisztrációs kérelem.';

  @override
  String get registrationListError =>
      'A regisztrációs kérelmek betöltése sikertelen.';

  @override
  String get registrationDetailError =>
      'A regisztrációs kérelem részleteinek betöltése sikertelen.';

  @override
  String get registrationMockDataBadge => 'Minta adat';

  @override
  String registrationSubmittedAt(String date) {
    return 'Beküldve: $date';
  }

  @override
  String get registrationSectionCompany => 'Cég';

  @override
  String get registrationSectionContact => 'Kapcsolat';

  @override
  String get registrationSectionStatus => 'Státusz';

  @override
  String get registrationSectionAiReview => 'AI felülvizsgálat';

  @override
  String get registrationSectionDocuments => 'Dokumentumok';

  @override
  String get registrationFieldCompanyName => 'Cégnév';

  @override
  String get registrationFieldCountry => 'Ország';

  @override
  String get registrationFieldVatNumber => 'Adószám';

  @override
  String get registrationFieldRegistrationNumber => 'Cégjegyzékszám';

  @override
  String get registrationFieldContactName => 'Kapcsolattartó neve';

  @override
  String get registrationFieldContactEmail => 'Kapcsolattartó e-mail';

  @override
  String get registrationFieldSubmittedAt => 'Beküldve';

  @override
  String get registrationFieldReviewedAt => 'Felülvizsgálva';

  @override
  String get registrationFieldReviewedBy => 'Felülvizsgáló';

  @override
  String get registrationFieldAiRecommendation => 'AI ajánlás';

  @override
  String get registrationFieldAiSummary => 'AI összefoglaló';

  @override
  String get registrationFieldMissingInformation => 'Hiányzó információk';

  @override
  String get registrationFieldDuplicateWarnings =>
      'Duplikációs figyelmeztetések';

  @override
  String get registrationFieldRiskFlags => 'Kockázati jelzők';

  @override
  String get registrationNoneReported => 'Nincs jelentve';

  @override
  String get registrationDocumentsMetadataOnly =>
      'Csak dokumentum metaadat — a fájltartalom nem jelenik meg.';

  @override
  String get registrationDocumentsEmpty =>
      'Nincs feltöltött dokumentum metaadat.';

  @override
  String get registrationActionApprove => 'Jóváhagyás';

  @override
  String get registrationActionReject => 'Elutasítás';

  @override
  String get registrationActionRequestInfo => 'További információ kérése';

  @override
  String get registrationDecisionApproveTitle => 'Regisztráció jóváhagyása';

  @override
  String get registrationDecisionRejectTitle => 'Regisztráció elutasítása';

  @override
  String get registrationDecisionRequestInfoTitle =>
      'További információ kérése';

  @override
  String get registrationDecisionApproveBody =>
      'Erősítse meg az onboarding kérelem jóváhagyását.';

  @override
  String get registrationDecisionAuditNotice =>
      'A művelet a platform audit naplóban rögzítésre kerül.';

  @override
  String get registrationDecisionNotesLabel => 'Felülvizsgálati megjegyzés';

  @override
  String get registrationDecisionNotesRequired =>
      'Legalább 3 karakter szükséges.';

  @override
  String get registrationDecisionCancel => 'Mégse';

  @override
  String get registrationDecisionApproveConfirm => 'Jóváhagyás';

  @override
  String get registrationDecisionRejectConfirm => 'Elutasítás';

  @override
  String get registrationDecisionRequestInfoConfirm => 'Kérelem küldése';

  @override
  String get registrationDecisionSuccess => 'A regisztrációs döntés mentve.';

  @override
  String get registrationDecisionError =>
      'A regisztrációs döntés mentése sikertelen.';

  @override
  String get systemHealthLoadError =>
      'A rendszerállapot adatok betöltése sikertelen.';

  @override
  String get systemHealthActionUnavailable =>
      'Ez a művelet még nem érhető el a csatlakoztatott backenden.';

  @override
  String get systemHealthMockDataBadge => 'Mintaadat';

  @override
  String get systemHealthServicesTitle => 'Szolgáltatás állapota';

  @override
  String get systemHealthEventsTitle => 'Állapot események';

  @override
  String get systemHealthEventsEmpty =>
      'Nincs a szűrőnek megfelelő állapot esemény.';

  @override
  String get systemHealthEventDetailTitle => 'Állapot esemény';

  @override
  String systemHealthEventStartedAt(String date) {
    return 'Kezdés: $date';
  }

  @override
  String get systemHealthOpenModule => 'Rendszerállapot megnyitása';

  @override
  String systemHealthOverallStatusLabel(String status) {
    return 'Összesített állapot: $status';
  }

  @override
  String systemHealthLastUpdated(String date) {
    return 'Utolsó frissítés: $date';
  }

  @override
  String get systemHealthMetricHealthyServices => 'Egészséges szolgáltatások';

  @override
  String get systemHealthMetricWarningServices =>
      'Figyelmeztető szolgáltatások';

  @override
  String get systemHealthMetricCriticalServices => 'Kritikus szolgáltatások';

  @override
  String get systemHealthMetricCriticalEvents => 'Kritikus események';

  @override
  String get systemHealthMetricWarningEvents => 'Figyelmeztető események';

  @override
  String get systemHealthMetricFailedJobs => 'Sikertelen feladatok';

  @override
  String get systemHealthSeverityInfo => 'Információ';

  @override
  String get systemHealthSeverityWarning => 'Figyelmeztetés';

  @override
  String get systemHealthSeverityCritical => 'Kritikus';

  @override
  String get systemHealthSeverityUnknown => 'Ismeretlen';

  @override
  String get systemHealthOverallHealthy => 'Egészséges';

  @override
  String get systemHealthOverallDegraded => 'Romlott';

  @override
  String get systemHealthOverallCritical => 'Kritikus';

  @override
  String get systemHealthOverallUnknown => 'Ismeretlen';

  @override
  String get systemHealthFilterAll => 'Összes';

  @override
  String get systemHealthFilterCritical => 'Kritikus';

  @override
  String get systemHealthFilterWarning => 'Figyelmeztetés';

  @override
  String get systemHealthFilterOpen => 'Nyitott';

  @override
  String get systemHealthFilterAcknowledged => 'Nyugtázott';

  @override
  String get systemHealthFilterResolved => 'Megoldott';

  @override
  String get systemHealthFilterTenantImpacting => 'Bérlőt érintő';

  @override
  String get systemHealthEventStatusOpen => 'Nyitott';

  @override
  String get systemHealthEventStatusAcknowledged => 'Nyugtázott';

  @override
  String get systemHealthEventStatusInvestigating => 'Vizsgálat alatt';

  @override
  String get systemHealthEventStatusResolved => 'Megoldott';

  @override
  String get systemHealthEventStatusUnknown => 'Ismeretlen';

  @override
  String get systemHealthImpactNone => 'Nincs bérlőhatás';

  @override
  String get systemHealthImpactSingleTenant => 'Egy bérlő';

  @override
  String get systemHealthImpactMultipleTenants => 'Több bérlő';

  @override
  String get systemHealthImpactPlatformWide => 'Platform szintű';

  @override
  String get systemHealthImpactUnknown => 'Ismeretlen hatás';

  @override
  String get systemHealthServiceBackendApi => 'Backend API';

  @override
  String get systemHealthServiceDatabase => 'Adatbázis';

  @override
  String get systemHealthServiceDocumentStorage => 'Dokumentumtár';

  @override
  String get systemHealthServiceBackgroundWorkers => 'Háttérfolyamatok';

  @override
  String get systemHealthServiceAiOcrWorkers => 'AI / OCR feldolgozók';

  @override
  String get systemHealthServiceTranslationService => 'Fordítási szolgáltatás';

  @override
  String get systemHealthServiceEmailService => 'E-mail szolgáltatás';

  @override
  String get systemHealthServicePushNotificationService =>
      'Push értesítési szolgáltatás';

  @override
  String get systemHealthServiceQueueSystem => 'Várólista rendszer';

  @override
  String get systemHealthServiceAuthService => 'Hitelesítési szolgáltatás';

  @override
  String get systemHealthAiDiagnosticTitle => 'AI diagnosztikai összefoglaló';

  @override
  String get systemHealthAiAdvisoryOnly =>
      'Csak tanácsadó jellegű — nem automatikus javítási utasítás.';

  @override
  String get systemHealthRecommendedAction => 'Ajánlott teendő';

  @override
  String get systemHealthActionAcknowledgeTitle => 'Esemény nyugtázása';

  @override
  String get systemHealthActionEscalateTitle => 'Esemény eszkalálása';

  @override
  String get systemHealthActionAuditNotice =>
      'A művelet a platform audit naplóban rögzítésre kerül.';

  @override
  String get systemHealthActionNoAutoRepair =>
      'Nem történik automatikus éles környezeti javítás.';

  @override
  String get systemHealthActionNoteLabel => 'Eszkalációs megjegyzés';

  @override
  String get systemHealthActionNoteRequired => 'Legalább 3 karakter szükséges.';

  @override
  String get systemHealthActionAcknowledgeBody =>
      'Erősítse meg az állapot esemény nyugtázását.';

  @override
  String get systemHealthActionCancel => 'Mégse';

  @override
  String get systemHealthActionAcknowledgeConfirm => 'Nyugtázás';

  @override
  String get systemHealthActionEscalateConfirm => 'Eszkalálás';

  @override
  String get systemHealthActionAcknowledge => 'Nyugtázás';

  @override
  String get systemHealthActionEscalate => 'Eszkalálás támogatásnak';

  @override
  String get systemHealthActionSuccess => 'Az állapot művelet mentve.';

  @override
  String get systemHealthActionError =>
      'Az állapot művelet mentése sikertelen.';

  @override
  String get systemHealthCreateTicketDisabled =>
      'Támogatási jegy létrehozása (hamarosan)';

  @override
  String get systemHealthPrivacyNotice =>
      'Csak metaadat — bérlői fuvar-, dokumentum- vagy üzenettartalom nem jelenik meg.';

  @override
  String get systemHealthFieldServiceName => 'Szolgáltatás';

  @override
  String get systemHealthFieldTenantImpact => 'Bérlőhatás';

  @override
  String get systemHealthFieldAffectedCompany => 'Érintett cég';

  @override
  String get systemHealthFieldStartedAt => 'Kezdés';

  @override
  String get systemHealthFieldLastSeenAt => 'Utoljára látva';

  @override
  String get systemHealthFieldResolvedAt => 'Megoldva';

  @override
  String get systemHealthFieldFailedJobs => 'Sikertelen feladatok';

  @override
  String get systemHealthFieldCorrelationId => 'Korrelációs azonosító';

  @override
  String get systemHealthCreateTicket => 'Támogatási jegy létrehozása';

  @override
  String get supportLoadError => 'A támogatási adatok betöltése sikertelen.';

  @override
  String get supportActionUnavailable =>
      'Ez a támogatási művelet még nem érhető el a csatlakoztatott backenden.';

  @override
  String get supportActionError => 'A támogatási művelet mentése sikertelen.';

  @override
  String get supportActionSuccess => 'A támogatási művelet mentve.';

  @override
  String get supportMockDataBadge => 'Mintaadat';

  @override
  String get supportOpenModule => 'Támogatás modul megnyitása';

  @override
  String get supportPrivacyNotice =>
      'Csak metaadat — bérlői fuvar-, dokumentum- vagy üzenettartalom alapértelmezetten nem jelenik meg.';

  @override
  String get supportActionAuditNotice =>
      'A művelet a platform audit naplóban rögzítésre kerül.';

  @override
  String get supportActionNoteLabel => 'Megjegyzés';

  @override
  String get supportActionNoteRequired => 'Legalább 3 karakter szükséges.';

  @override
  String get supportActionCancel => 'Mégse';

  @override
  String get supportTicketSearchHint =>
      'Keresés cég, cím vagy kérelmező e-mail alapján';

  @override
  String get supportTicketListEmpty =>
      'Nincs a szűrőnek megfelelő támogatási jegy.';

  @override
  String supportTicketLastActivity(String date) {
    return 'Utolsó aktivitás: $date';
  }

  @override
  String get supportTicketDetailTitle => 'Támogatási jegy';

  @override
  String get supportGrantDetailTitle => 'Támogatási hozzáférési engedély';

  @override
  String get supportGrantSearchHint =>
      'Keresés cég, hatókör azonosító vagy kérelmező alapján';

  @override
  String get supportGrantListEmpty =>
      'Nincs a szűrőnek megfelelő támogatási hozzáférési engedély.';

  @override
  String supportGrantScopeIdLabel(String id) {
    return 'Hatókör azonosító: $id';
  }

  @override
  String supportGrantExpiresAt(String date) {
    return 'Lejár: $date';
  }

  @override
  String get supportSummaryTitle => 'Támogatás áttekintés';

  @override
  String get supportSummaryOpenTickets => 'Nyitott jegyek';

  @override
  String get supportSummaryUrgentCritical => 'Sürgős / kritikus';

  @override
  String get supportSummaryActiveGrants => 'Aktív engedélyek';

  @override
  String supportSummaryLastUpdated(String date) {
    return 'Utolsó frissítés: $date';
  }

  @override
  String get supportTicketCreateSuccess => 'Támogatási jegy létrehozva.';

  @override
  String get supportTicketFilterAll => 'Összes';

  @override
  String get supportTicketFilterOpen => 'Nyitott';

  @override
  String get supportTicketFilterUrgent => 'Sürgős';

  @override
  String get supportTicketFilterCritical => 'Kritikus';

  @override
  String get supportTicketFilterSystemHealth => 'Rendszerállapot';

  @override
  String get supportTicketFilterWaitingForCustomer => 'Ügyfélre vár';

  @override
  String get supportTicketFilterResolved => 'Megoldott';

  @override
  String get supportGrantFilterAll => 'Összes';

  @override
  String get supportGrantFilterPending => 'Függőben';

  @override
  String get supportGrantFilterActive => 'Aktív';

  @override
  String get supportGrantFilterExpired => 'Lejárt';

  @override
  String get supportGrantFilterRevoked => 'Visszavonva';

  @override
  String get supportTicketStatusOpen => 'Nyitott';

  @override
  String get supportTicketStatusAcknowledged => 'Nyugtázott';

  @override
  String get supportTicketStatusInvestigating => 'Vizsgálat alatt';

  @override
  String get supportTicketStatusWaitingForCustomer => 'Ügyfélre vár';

  @override
  String get supportTicketStatusResolved => 'Megoldott';

  @override
  String get supportTicketStatusClosed => 'Lezárva';

  @override
  String get supportTicketStatusUnknown => 'Ismeretlen';

  @override
  String get supportTicketPriorityLow => 'Alacsony';

  @override
  String get supportTicketPriorityNormal => 'Normál';

  @override
  String get supportTicketPriorityHigh => 'Magas';

  @override
  String get supportTicketPriorityUrgent => 'Sürgős';

  @override
  String get supportTicketPriorityCritical => 'Kritikus';

  @override
  String get supportTicketPriorityUnknown => 'Ismeretlen';

  @override
  String get supportTicketCategoryRegistration => 'Regisztráció';

  @override
  String get supportTicketCategorySystemHealth => 'Rendszerállapot';

  @override
  String get supportTicketCategoryUploadIssue => 'Feltöltési probléma';

  @override
  String get supportTicketCategoryBilling => 'Számlázás';

  @override
  String get supportTicketCategoryAccess => 'Hozzáférés';

  @override
  String get supportTicketCategoryIntegration => 'Integráció';

  @override
  String get supportTicketCategoryOther => 'Egyéb';

  @override
  String get supportTicketCategoryUnknown => 'Ismeretlen';

  @override
  String get supportGrantStatusPending => 'Függőben';

  @override
  String get supportGrantStatusActive => 'Aktív';

  @override
  String get supportGrantStatusExpired => 'Lejárt';

  @override
  String get supportGrantStatusRevoked => 'Visszavonva';

  @override
  String get supportGrantStatusDenied => 'Elutasítva';

  @override
  String get supportGrantStatusUnknown => 'Ismeretlen';

  @override
  String get supportScopeCompanyMetadata => 'Cég metaadat';

  @override
  String get supportScopeSpecificTrip => 'Konkrét fuvar';

  @override
  String get supportScopeSpecificDocumentIssue => 'Konkrét dokumentum probléma';

  @override
  String get supportScopeUploadQueueIssue => 'Feltöltési várólista probléma';

  @override
  String get supportScopeSystemHealthIssue => 'Rendszerállapot probléma';

  @override
  String get supportScopeIntegrationIssue => 'Integrációs probléma';

  @override
  String get supportScopeBillingIssue => 'Számlázási probléma';

  @override
  String get supportScopeUnknown => 'Ismeretlen hatókör';

  @override
  String get supportGrantWarningTitle =>
      'Hatókör szerinti támogatási hozzáférés';

  @override
  String get supportGrantWarningBody =>
      'Az engedélyek ideiglenesek, hatókör szerintiek és auditáltak. Nincs széles körű korlátlan bérlői hozzáférés.';

  @override
  String get supportGrantAuditNotice =>
      'Ez ideiglenes, hatókör szerinti támogatási hozzáférést ad és audit naplózásra kerül.';

  @override
  String get supportGrantCreateTitle =>
      'Támogatási hozzáférési engedély létrehozása';

  @override
  String get supportGrantCreateWarning =>
      'Ez ideiglenes, hatókör szerinti támogatási hozzáférést ad és audit naplózásra kerül.';

  @override
  String get supportGrantCreateConfirm => 'Engedély létrehozása';

  @override
  String get supportGrantCreateSuccess =>
      'Támogatási hozzáférési engedély létrehozva.';

  @override
  String supportGrantCompanyLabel(String name) {
    return 'Cég: $name';
  }

  @override
  String get supportGrantScopeTypeLabel => 'Hatókör típusa';

  @override
  String get supportGrantScopeIdFieldLabel => 'Hatókör azonosító';

  @override
  String get supportGrantScopeIdRequired =>
      'Ehhez a hatókör típushoz azonosító szükséges.';

  @override
  String get supportGrantReasonLabel => 'Indoklás';

  @override
  String get supportGrantReasonRequired => 'Legalább 3 karakter szükséges.';

  @override
  String get supportGrantExpiryRequired =>
      'Válasszon érvényes lejáratot legfeljebb 24 órán belül.';

  @override
  String get supportGrantBroadAccessRejected =>
      'Széles körű vagy dokumentum hozzáférés nem engedélyezett.';

  @override
  String get supportGrantExpiryLabel => 'Lejárat';

  @override
  String get supportGrantExpiryTwoHours => '2 óra';

  @override
  String get supportGrantExpiryTwentyFourHours => '24 óra';

  @override
  String get supportGrantRevokeTitle =>
      'Támogatási hozzáférési engedély visszavonása';

  @override
  String get supportGrantRevokeNoteLabel => 'Visszavonás indoklása';

  @override
  String get supportGrantRevokeConfirm => 'Engedély visszavonása';

  @override
  String get supportGrantRevokeSuccess =>
      'Támogatási hozzáférési engedély visszavonva.';

  @override
  String get supportGrantActionRevoke => 'Engedély visszavonása';

  @override
  String get supportGrantFieldCompany => 'Cég';

  @override
  String get supportGrantFieldScopeId => 'Hatókör azonosító';

  @override
  String get supportGrantFieldReason => 'Indoklás';

  @override
  String get supportGrantFieldAllowedCategories =>
      'Engedélyezett adatkategóriák';

  @override
  String get supportGrantFieldExcludesDocuments =>
      'Kizár érzékeny dokumentumokat';

  @override
  String get supportGrantFieldCreatedAt => 'Létrehozva';

  @override
  String get supportGrantFieldExpiresAt => 'Lejár';

  @override
  String get supportGrantFieldRevokedAt => 'Visszavonva';

  @override
  String get supportGrantFieldApprovedBy => 'Jóváhagyó';

  @override
  String get supportGrantFieldAuditLogId => 'Audit napló azonosító';

  @override
  String get supportGrantYes => 'Igen';

  @override
  String get supportGrantNo => 'Nem';

  @override
  String get supportTicketFieldCompany => 'Cég';

  @override
  String get supportTicketFieldRequester => 'Kérelmező';

  @override
  String get supportTicketFieldCategory => 'Kategória';

  @override
  String get supportTicketFieldSummary => 'Összefoglaló';

  @override
  String get supportTicketFieldCreatedAt => 'Létrehozva';

  @override
  String get supportTicketFieldUpdatedAt => 'Frissítve';

  @override
  String get supportTicketFieldLastActivity => 'Utolsó aktivitás';

  @override
  String get supportTicketFieldLinkedHealthEvent => 'Kapcsolt állapot esemény';

  @override
  String get supportTicketFieldSupportGrant =>
      'Támogatási hozzáférési engedély';

  @override
  String get supportTicketActionAcknowledge => 'Nyugtázás';

  @override
  String get supportTicketActionClose => 'Jegy lezárása';

  @override
  String get supportTicketActionCreateGrant =>
      'Támogatási hozzáférési engedély létrehozása';

  @override
  String get supportTicketActionAcknowledgeTitle => 'Jegy nyugtázása';

  @override
  String get supportTicketActionCloseTitle => 'Jegy lezárása';

  @override
  String get supportTicketActionAcknowledgeBody =>
      'Erősítse meg a támogatási jegy nyugtázását.';

  @override
  String get supportTicketActionAcknowledgeConfirm => 'Nyugtázás';

  @override
  String get supportTicketActionCloseConfirm => 'Lezárás';
}
