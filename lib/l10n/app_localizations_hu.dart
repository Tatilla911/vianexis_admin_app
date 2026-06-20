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
  String get brandAppName => 'ViaNexis Admin';

  @override
  String get brandControlCenterSubtitle => 'Operatív irányítóközpont';

  @override
  String get brandOperationalControlCenter => 'Operatív irányítóközpont';

  @override
  String get brandPlatformControlCenterBody =>
      'Platform irányítóközpont metaadat-alapú adminisztrációhoz, ellenőrzési sorokhoz és audit láthatósághoz.';

  @override
  String get brandAdminOnlyAccess =>
      'Csak platform admin hozzáférés. Bérlői sofőr és diszpécser fiókok nem léphetnek be.';

  @override
  String get brandMetadataOnlyPlatformView =>
      'Csak metaadat platform nézet — nincs üzemeltetési fuvar-, dokumentum- vagy üzenettartalom.';

  @override
  String get brandEnvironmentLabel => 'Környezet';

  @override
  String get brandSecureAdminSession => 'Biztonságos admin munkamenet';

  @override
  String get brandApiConnected => 'API csatlakoztatva';

  @override
  String get brandApiNotConfigured => 'API nincs beállítva';

  @override
  String get navDashboard => 'Irányítópult';

  @override
  String get navRegistrations => 'Regisztrációk';

  @override
  String get navBulkOnboarding => 'Tömeges onboarding';

  @override
  String get navSupport => 'Támogatás';

  @override
  String get navSystemHealth => 'Rendszerállapot';

  @override
  String get navAuditLogs => 'Audit napló';

  @override
  String get navSettings => 'Beállítások';

  @override
  String get loginTitle => 'Belépés';

  @override
  String get loginSubtitle =>
      'Biztonságos platform admin munkamenet ViaNexis műveleti csapatoknak.';

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
  String get dashboardTitle => 'Irányítóközpont';

  @override
  String get dashboardOperationalOverviewTitle => 'Operatív áttekintés';

  @override
  String get dashboardOperationalOverviewBody =>
      'Metaadat-alapú irányítópult pillanatkép a platform szolgáltatásairól és emberi ellenőrzési sorokról.';

  @override
  String get dashboardSystemStatusHealthy => 'Egészséges';

  @override
  String get dashboardSystemStatusAttention => 'Figyelmet igényel';

  @override
  String get dashboardMetricSystemStatus => 'Rendszerállapot';

  @override
  String get dashboardMetricPendingRegistrations => 'Függő regisztrációk';

  @override
  String get dashboardMetricCompaniesAttention => 'Figyelmet igénylő cégek';

  @override
  String get dashboardMetricBulkOnboardingReview =>
      'Tömeges onboarding ellenőrzésre vár';

  @override
  String get dashboardMetricAiHighRisk => 'Magas kockázatú AI értékelések';

  @override
  String get dashboardMetricSupportIssues => 'Nyitott support ügyek';

  @override
  String get dashboardMetricAuditRisks =>
      'Sikertelen / elutasított audit események';

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
  String get aiReviewLoadError => 'Az AI áttekintések betöltése sikertelen.';

  @override
  String get aiReviewDetailError =>
      'Az AI áttekintés részletei nem tölthetők be.';

  @override
  String get aiReviewListEmpty =>
      'Nincs a szűrőknek megfelelő AI tanácsadó áttekintés.';

  @override
  String get aiReviewSearchHint =>
      'Keresés forrás, cég vagy összefoglaló szerint';

  @override
  String get aiReviewMockDataBadge => 'Mintaadat';

  @override
  String get aiReviewOpenModule => 'AI áttekintések megnyitása';

  @override
  String get aiReviewAdvisoryNotice =>
      'Az AI ajánlások csak tanácsadó jellegűek. Minden döntéshez emberi jóváhagyás szükséges.';

  @override
  String get aiReviewDashboardTitle => 'AI tanácsadó áttekintések';

  @override
  String aiReviewDashboardTotal(String count) {
    return 'Összes áttekintés: $count';
  }

  @override
  String aiReviewDashboardHighRisk(String count) {
    return 'Magas kockázat: $count';
  }

  @override
  String aiReviewDashboardNeedsHumanReview(String count) {
    return 'Emberi felülvizsgálat szükséges: $count';
  }

  @override
  String get aiReviewFilterAll => 'Összes';

  @override
  String get aiReviewFilterHighRisk => 'Magas kockázat';

  @override
  String get aiReviewFilterRegistration => 'Regisztráció';

  @override
  String get aiReviewFilterBulkOnboarding => 'Bulk onboarding';

  @override
  String get aiReviewFilterSystemHealth => 'Rendszerállapot';

  @override
  String get aiReviewFilterNeedsHumanReview => 'Emberi felülvizsgálat';

  @override
  String get aiReviewSourceRegistration => 'Regisztráció';

  @override
  String get aiReviewSourceBulkOnboarding => 'Bulk onboarding';

  @override
  String get aiReviewSourceSystemHealth => 'Rendszerállapot';

  @override
  String get aiReviewSourceSupportTicket => 'Támogatási jegy';

  @override
  String get aiReviewSourceUnknown => 'Ismeretlen forrás';

  @override
  String get aiReviewRiskLow => 'Alacsony kockázat';

  @override
  String get aiReviewRiskMedium => 'Közepes kockázat';

  @override
  String get aiReviewRiskHigh => 'Magas kockázat';

  @override
  String get aiReviewRiskUnknown => 'Ismeretlen kockázat';

  @override
  String get aiReviewRecommendationReview => 'Felülvizsgálat javasolt';

  @override
  String get aiReviewRecommendationRequestInfo => 'Információ kérése';

  @override
  String get aiReviewRecommendationApproveCandidate => 'Jóváhagyási jelölt';

  @override
  String get aiReviewRecommendationRejectCandidate => 'Elutasítási jelölt';

  @override
  String get aiReviewRecommendationEscalate => 'Eszkalálás';

  @override
  String get aiReviewRecommendationCannotApproveYet => 'Még nem hagyható jóvá';

  @override
  String get aiReviewRecommendationUnknown => 'Ismeretlen ajánlás';

  @override
  String get aiReviewSectionSummary => 'Tanácsadó összefoglaló';

  @override
  String get aiReviewSectionChecks => 'Ellenőrzések és figyelmeztetések';

  @override
  String get aiReviewFieldChecksPerformed => 'Elvégzett ellenőrzések';

  @override
  String get aiReviewFieldMissingInformation => 'Hiányzó információ';

  @override
  String get aiReviewFieldDuplicateWarnings => 'Duplikátum figyelmeztetések';

  @override
  String aiReviewFieldConfidenceScore(String score) {
    return 'Megbízhatósági pontszám: $score';
  }

  @override
  String aiReviewUpdatedAt(String date) {
    return 'Frissítve: $date';
  }

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
  String get errorSessionExpiredTitle => 'A munkamenet lejárt';

  @override
  String get authSessionExpired =>
      'A munkamenete lejárt. Jelentkezzen be újra a folytatáshoz.';

  @override
  String get errorPermissionDeniedTitle => 'Hozzáférés megtagadva';

  @override
  String get errorPermissionDeniedBody =>
      'Fiókja nem fér hozzá ehhez a modulhoz.';

  @override
  String get errorActionUnavailableTitle => 'A művelet nem érhető el';

  @override
  String get errorActionUnavailableBody =>
      'Ez a művelet vagy erőforrás jelenleg nem érhető el.';

  @override
  String get errorActionUnavailable =>
      'Ez a művelet vagy erőforrás jelenleg nem érhető el.';

  @override
  String get errorBackendNotConfiguredTitle => 'A backend nincs beállítva';

  @override
  String get errorNetworkTitle => 'Kapcsolati hiba';

  @override
  String get offlineBannerMessage =>
      'Úgy tűnik, offline állapotban van. Egyes műveletek addig sikertelenek lehetnek, amíg vissza nem tér a kapcsolat.';

  @override
  String get backendNotConfiguredBanner =>
      'Az éles backend nincs beállítva. A modulok mintaadatot használhatnak.';

  @override
  String get confirmDialogCancel => 'Mégse';

  @override
  String get confirmDialogProceed => 'Megerősítés';

  @override
  String get logoutConfirmTitle => 'Kijelentkezik?';

  @override
  String get logoutConfirmBody =>
      'Az admin alkalmazás eléréséhez újra be kell jelentkeznie.';

  @override
  String get accessDeniedBackToDashboard => 'Vissza az irányítópulthoz';

  @override
  String get navAiReviews => 'AI áttekintések';

  @override
  String get settingsAccountSection => 'Bejelentkezett fiók';

  @override
  String get settingsEmailLabel => 'E-mail';

  @override
  String get settingsRoleLabel => 'Szerepkör';

  @override
  String get settingsApiBaseUrlLabel => 'API alap URL';

  @override
  String get settingsEnvironmentLabel => 'Környezet';

  @override
  String get settingsBackendNotConfiguredValue => 'Nincs beállítva';

  @override
  String get settingsSignOutSection => 'Munkamenet';

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
  String get settingsVersionLabel => 'Verzió';

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

  @override
  String get auditLogLoadError => 'Az audit naplók betöltése sikertelen.';

  @override
  String get auditLogMockDataBadge => 'Mintaadat';

  @override
  String get auditLogOpenModule => 'Audit naplók megnyitása';

  @override
  String get auditLogSearchHint =>
      'Keresés színész e-mail, cég, cél azonosító vagy korreláció alapján';

  @override
  String get auditLogListEmpty =>
      'Nincs a szűrőnek megfelelő audit napló bejegyzés.';

  @override
  String get auditLogDateRangeLabel => 'Szűrés dátumtartományra';

  @override
  String auditLogDateRangeSelected(String from, String to) {
    return '$from – $to';
  }

  @override
  String get auditLogDateRangeClear => 'Dátumok törlése';

  @override
  String get auditLogDateRangeComingSoon => 'Dátumtartomány szűrő (hamarosan)';

  @override
  String get auditLogExportCsv => 'Metaadat CSV export';

  @override
  String get auditLogExportCopied =>
      'Az audit napló export a vágólapra másolva.';

  @override
  String get auditLogExportFailed => 'Az audit napló exportja nem sikerült.';

  @override
  String get auditLogExportUnavailable =>
      'Az audit napló export nem érhető el.';

  @override
  String get auditLogExportSafetyNotice =>
      'Az export csak metaadatot tartalmaz. Nem szerepel benne fuvar, dokumentum vagy üzenet tartalom.';

  @override
  String auditLogTimestampLabel(String date) {
    return '$date';
  }

  @override
  String get auditLogDetailTitle => 'Audit napló bejegyzés';

  @override
  String get auditLogPrivacyNotice =>
      'Csak metaadat — bérlői fuvar-, dokumentum- vagy üzenettartalom nem jelenik meg.';

  @override
  String get auditLogExportDisabled => 'Audit napló exportálása (hamarosan)';

  @override
  String get auditLogSummaryTitle => 'Legutóbbi audit tevékenység';

  @override
  String get auditLogSummaryLastCritical => 'Utolsó kritikus esemény';

  @override
  String get auditLogSummaryNoCritical => 'Nincs kritikus esemény';

  @override
  String get auditLogSummaryFailedDenied => 'Sikertelen / megtagadott';

  @override
  String get auditLogSummaryRecentActions => 'Legutóbbi platform műveletek';

  @override
  String auditLogSummaryLastUpdated(String date) {
    return 'Utolsó frissítés: $date';
  }

  @override
  String get auditLogFilterAll => 'Összes';

  @override
  String get auditLogFilterCritical => 'Kritikus';

  @override
  String get auditLogFilterWarning => 'Figyelmeztetés';

  @override
  String get auditLogFilterFailures => 'Sikertelen';

  @override
  String get auditLogFilterDenied => 'Megtagadott';

  @override
  String get auditLogFilterRegistration => 'Regisztráció';

  @override
  String get auditLogFilterSupportAccess => 'Támogatási hozzáférés';

  @override
  String get auditLogFilterSystemHealth => 'Rendszerállapot';

  @override
  String get auditLogFilterSecurity => 'Biztonság';

  @override
  String get auditLogResultSuccess => 'Sikeres';

  @override
  String get auditLogResultFailure => 'Sikertelen';

  @override
  String get auditLogResultDenied => 'Megtagadva';

  @override
  String get auditLogResultPartial => 'Részleges';

  @override
  String get auditLogResultUnknown => 'Ismeretlen';

  @override
  String get auditLogSeverityInfo => 'Információ';

  @override
  String get auditLogSeverityWarning => 'Figyelmeztetés';

  @override
  String get auditLogSeverityCritical => 'Kritikus';

  @override
  String get auditLogSeverityUnknown => 'Ismeretlen';

  @override
  String get auditLogActionLogin => 'Bejelentkezés';

  @override
  String get auditLogActionLogout => 'Kijelentkezés';

  @override
  String get auditLogActionLoginFailed => 'Sikertelen bejelentkezés';

  @override
  String get auditLogActionRegistrationApproved => 'Regisztráció jóváhagyva';

  @override
  String get auditLogActionRegistrationRejected => 'Regisztráció elutasítva';

  @override
  String get auditLogActionRegistrationInfoRequested =>
      'Regisztrációs info kérve';

  @override
  String get auditLogActionSupportTicketAcknowledged =>
      'Támogatási jegy nyugtázva';

  @override
  String get auditLogActionSupportTicketClosed => 'Támogatási jegy lezárva';

  @override
  String get auditLogActionSupportAccessGranted =>
      'Támogatási hozzáférés engedélyezve';

  @override
  String get auditLogActionSupportAccessRevoked =>
      'Támogatási hozzáférés visszavonva';

  @override
  String get auditLogActionSystemHealthAcknowledged =>
      'Rendszerállapot nyugtázva';

  @override
  String get auditLogActionSystemHealthEscalated =>
      'Rendszerállapot eszkalálva';

  @override
  String get auditLogActionBillingUpdated => 'Számlázás frissítve';

  @override
  String get auditLogActionRoleChanged => 'Szerepkör módosítva';

  @override
  String get auditLogActionPermissionDenied => 'Engedély megtagadva';

  @override
  String get auditLogActionExportRequested => 'Export kérve';

  @override
  String get auditLogActionApiKeyCreated => 'API kulcs létrehozva';

  @override
  String get auditLogActionApiKeyRevoked => 'API kulcs visszavonva';

  @override
  String get auditLogActionUnknown => 'Ismeretlen művelet';

  @override
  String get auditLogFieldTimestamp => 'Időbélyeg';

  @override
  String get auditLogFieldActor => 'Színész';

  @override
  String get auditLogFieldActorRole => 'Színész szerepkör';

  @override
  String get auditLogFieldTargetType => 'Cél típusa';

  @override
  String get auditLogFieldTargetId => 'Cél azonosító';

  @override
  String get auditLogFieldCompany => 'Cég';

  @override
  String get auditLogFieldTenantId => 'Bérlő azonosító';

  @override
  String get auditLogFieldReason => 'Indoklás';

  @override
  String get auditLogFieldNote => 'Megjegyzés';

  @override
  String get auditLogFieldIpAddress => 'IP cím';

  @override
  String get auditLogFieldDeviceLabel => 'Eszköz';

  @override
  String get auditLogFieldCorrelationId => 'Korrelációs azonosító';

  @override
  String get auditLogFieldRegistrationApplicationId =>
      'Regisztrációs kérelem azonosító';

  @override
  String get auditLogFieldSupportAccessGrantId =>
      'Támogatási hozzáférési engedély azonosító';

  @override
  String get auditLogFieldSystemHealthEventId =>
      'Rendszerállapot esemény azonosító';

  @override
  String get auditLogDetailLoaded => 'Audit napló részlete betöltve.';

  @override
  String get supportTicketAcknowledgedSuccess => 'Jegy nyugtázva.';

  @override
  String get supportTicketClosedSuccess => 'Jegy lezárva.';

  @override
  String get supportGrantRevokedSuccess => 'Jogosultság visszavonva.';

  @override
  String get systemHealthEventAcknowledgedSuccess =>
      'Rendszerállapot esemény nyugtázva.';

  @override
  String get systemHealthEventEscalatedSuccess =>
      'Rendszerállapot esemény eszkalálva.';

  @override
  String get backendActionUnavailable =>
      'Ez a művelet még nem érhető el ezen a backenden.';

  @override
  String get bulkOnboardingTitle => 'Tömeges onboarding';

  @override
  String get bulkOnboardingDetailTitle => 'Tömeges onboarding feladat';

  @override
  String get bulkOnboardingRowsTitle => 'Import sorok';

  @override
  String get bulkOnboardingMockDataBadge => 'Mintaadat';

  @override
  String get bulkOnboardingSearchHint =>
      'Keresés cég, fájl vagy feladat azonosító alapján';

  @override
  String get bulkOnboardingListEmpty =>
      'Nincs a szűrőknek megfelelő tömeges onboarding feladat.';

  @override
  String get bulkOnboardingListError =>
      'Nem sikerült betölteni a tömeges onboarding feladatokat.';

  @override
  String get bulkOnboardingDetailError => 'Nem sikerült betölteni a feladatot.';

  @override
  String get bulkOnboardingRowsError =>
      'Nem sikerült betölteni az import sorokat.';

  @override
  String get bulkOnboardingRowsEmpty => 'Nincs sor ezzel a szűrővel.';

  @override
  String get bulkOnboardingPrivacyNotice =>
      'Csak metaadat. Bérlői üzemeltetési út, dokumentum és üzenet tartalom soha nem jelenik meg itt.';

  @override
  String get bulkOnboardingOpenModule => 'Tömeges onboarding megnyitása';

  @override
  String get bulkOnboardingOpenRows => 'Sorok megtekintése';

  @override
  String get bulkOnboardingNoSourceFile => 'Nincs forrásfájl név';

  @override
  String get bulkOnboardingFieldSourceFile => 'Forrásfájl';

  @override
  String get bulkOnboardingDashboardTitle => 'Tömeges onboarding';

  @override
  String get bulkOnboardingDashboardWaitingReview => 'Felülvizsgálatra vár';

  @override
  String get bulkOnboardingDashboardHighRisk => 'Magas kockázatú feladatok';

  @override
  String get bulkOnboardingDashboardInvalidRows => 'Érvénytelen sorok';

  @override
  String get bulkOnboardingDashboardProcessing => 'Feldolgozás alatt';

  @override
  String get bulkOnboardingFilterAll => 'Összes';

  @override
  String get bulkOnboardingFilterReadyForReview => 'Felülvizsgálatra kész';

  @override
  String get bulkOnboardingFilterValidationFailed => 'Validáció sikertelen';

  @override
  String get bulkOnboardingFilterProcessing => 'Feldolgozás alatt';

  @override
  String get bulkOnboardingFilterCompleted => 'Befejezett';

  @override
  String get bulkOnboardingFilterRejected => 'Elutasított';

  @override
  String get bulkOnboardingFilterHighRisk => 'Magas kockázat';

  @override
  String get bulkOnboardingStatusDraft => 'Piszkozat';

  @override
  String get bulkOnboardingStatusUploaded => 'Feltöltve';

  @override
  String get bulkOnboardingStatusValidating => 'Validálás';

  @override
  String get bulkOnboardingStatusValidationFailed => 'Validáció sikertelen';

  @override
  String get bulkOnboardingStatusReadyForReview => 'Felülvizsgálatra kész';

  @override
  String get bulkOnboardingStatusApprovedForProcessing =>
      'Feldolgozásra jóváhagyva';

  @override
  String get bulkOnboardingStatusProcessing => 'Feldolgozás alatt';

  @override
  String get bulkOnboardingStatusPartiallyCompleted => 'Részben kész';

  @override
  String get bulkOnboardingStatusCompleted => 'Befejezve';

  @override
  String get bulkOnboardingStatusRejected => 'Elutasítva';

  @override
  String get bulkOnboardingStatusCancelled => 'Törölve';

  @override
  String get bulkOnboardingStatusUnknown => 'Ismeretlen';

  @override
  String get bulkOnboardingRowStatusPending => 'Függőben';

  @override
  String get bulkOnboardingRowStatusValid => 'Érvényes';

  @override
  String get bulkOnboardingRowStatusWarning => 'Figyelmeztetés';

  @override
  String get bulkOnboardingRowStatusInvalid => 'Érvénytelen';

  @override
  String get bulkOnboardingRowStatusDuplicate => 'Duplikált';

  @override
  String get bulkOnboardingRowStatusApproved => 'Jóváhagyva';

  @override
  String get bulkOnboardingRowStatusSkipped => 'Kihagyva';

  @override
  String get bulkOnboardingRowStatusProcessed => 'Feldolgozva';

  @override
  String get bulkOnboardingRowStatusFailed => 'Sikertelen';

  @override
  String get bulkOnboardingRowStatusUnknown => 'Ismeretlen';

  @override
  String get bulkOnboardingTypeCompanyUsers => 'Céges felhasználók';

  @override
  String get bulkOnboardingTypeDrivers => 'Sofőrök';

  @override
  String get bulkOnboardingTypeVehicles => 'Járművek';

  @override
  String get bulkOnboardingTypeTrailers => 'Pótkocsik';

  @override
  String get bulkOnboardingTypeMixedCompanyImport => 'Vegyes cég import';

  @override
  String get bulkOnboardingTypeUnknown => 'Ismeretlen típus';

  @override
  String get bulkOnboardingRiskLow => 'Alacsony kockázat';

  @override
  String get bulkOnboardingRiskMedium => 'Közepes kockázat';

  @override
  String get bulkOnboardingRiskHigh => 'Magas kockázat';

  @override
  String get bulkOnboardingRiskUnknown => 'Ismeretlen kockázat';

  @override
  String bulkOnboardingMetricTotalRows(String count) {
    return 'Összes sor: $count';
  }

  @override
  String bulkOnboardingMetricValidRows(String count) {
    return 'Érvényes: $count';
  }

  @override
  String bulkOnboardingMetricWarningRows(String count) {
    return 'Figyelmeztetés: $count';
  }

  @override
  String bulkOnboardingMetricInvalidRows(String count) {
    return 'Érvénytelen: $count';
  }

  @override
  String bulkOnboardingMetricDuplicateRows(String count) {
    return 'Duplikált: $count';
  }

  @override
  String get bulkOnboardingValidationSummaryTitle => 'Validációs összegzés';

  @override
  String get bulkOnboardingValidationErrors => 'Validációs hibák';

  @override
  String bulkOnboardingDuplicateReason(String reason) {
    return 'Duplikált: $reason';
  }

  @override
  String get bulkOnboardingAiReviewTitle => 'AI értékelés (tanácsadó)';

  @override
  String get bulkOnboardingAiAdvisoryNotice =>
      'Az ajánlások csak tanácsadó jellegűek. Emberi jóváhagyás szükséges.';

  @override
  String bulkOnboardingRecommendedAction(String action) {
    return 'Ajánlott művelet: $action';
  }

  @override
  String get bulkOnboardingRowFilterAll => 'Összes sor';

  @override
  String get bulkOnboardingRowFilterInvalid => 'Érvénytelen';

  @override
  String get bulkOnboardingRowFilterWarning => 'Figyelmeztetések';

  @override
  String get bulkOnboardingRowFilterDuplicate => 'Duplikált';

  @override
  String get bulkOnboardingActionValidate => 'Validálás';

  @override
  String get bulkOnboardingActionApprove => 'Jóváhagyás';

  @override
  String get bulkOnboardingActionReject => 'Elutasítás';

  @override
  String get bulkOnboardingActionCancel => 'Mégse';

  @override
  String get bulkOnboardingActionProcess => 'Feldolgozás';

  @override
  String get bulkOnboardingProcessDisabled => 'Feldolgozás nem elérhető';

  @override
  String get bulkOnboardingProcessUnavailable =>
      'A feldolgozás nem elérhető ehhez a feladathoz.';

  @override
  String get bulkOnboardingActionUnavailable =>
      'Ez a művelet jelenleg nem elérhető.';

  @override
  String get bulkOnboardingActionSuccess =>
      'Művelet rögzítve és audit naplózva.';

  @override
  String get bulkOnboardingActionAuditNotice =>
      'Ez a művelet audit naplózásra kerül és befolyásolhatja a bérlő onboarding folyamatot.';

  @override
  String get bulkOnboardingActionNoteLabel => 'Indoklás / megjegyzés';

  @override
  String get bulkOnboardingActionOptionalNoteLabel => 'Opcionális megjegyzés';

  @override
  String get bulkOnboardingActionNoteRequired => 'Indoklás megadása kötelező.';

  @override
  String get bulkOnboardingActionConfirmRequired =>
      'Kifejezett megerősítés szükséges.';

  @override
  String get bulkOnboardingActionExplicitConfirm =>
      'Megerősítem ezt az érzékeny feldolgozási műveletet.';

  @override
  String get bulkOnboardingActionDismiss => 'Mégse';

  @override
  String get bulkOnboardingActionValidateTitle => 'Import validálása';

  @override
  String get bulkOnboardingActionApproveTitle => 'Jóváhagyás feldolgozásra';

  @override
  String get bulkOnboardingActionRejectTitle => 'Import feladat elutasítása';

  @override
  String get bulkOnboardingActionCancelTitle => 'Import feladat törlése';

  @override
  String get bulkOnboardingActionProcessTitle =>
      'Jóváhagyott import feldolgozása';

  @override
  String get bulkOnboardingActionValidateConfirm => 'Validálás futtatása';

  @override
  String get bulkOnboardingActionApproveConfirm => 'Jóváhagyás';

  @override
  String get bulkOnboardingActionRejectConfirm => 'Elutasítás';

  @override
  String get bulkOnboardingActionCancelConfirm => 'Feladat törlése';

  @override
  String get bulkOnboardingActionProcessConfirm => 'Feldolgozás indítása';

  @override
  String get bulkOnboardingUploadCsv => 'CSV feltöltés';

  @override
  String get bulkOnboardingChooseFile => 'Fájl kiválasztása';

  @override
  String bulkOnboardingSelectedFile(String name) {
    return 'Kiválasztott fájl: $name';
  }

  @override
  String bulkOnboardingFileSize(String size) {
    return 'Fájlméret: $size';
  }

  @override
  String get bulkOnboardingUploadPreviewTitle => 'Feltöltési előnézet';

  @override
  String get bulkOnboardingImportTemplate => 'Import sablon';

  @override
  String get bulkOnboardingDownloadTemplate => 'Sablon letöltése';

  @override
  String get bulkOnboardingTemplateCopied => 'Sablon a vágólapra másolva.';

  @override
  String get bulkOnboardingDownloadValidationReport =>
      'Validációs jelentés CSV letöltése';

  @override
  String get bulkOnboardingValidationReportCopied =>
      'Validációs jelentés a vágólapra másolva.';

  @override
  String get bulkOnboardingValidationReportFailed =>
      'A validációs jelentés letöltése nem sikerült.';

  @override
  String get bulkOnboardingCsvOnlyNotice =>
      'Ebben a fázisban csak CSV. Excel import később érkezik.';

  @override
  String get bulkOnboardingExcelComingLater =>
      'Excel import később érkezik. Most CSV-t töltsön fel.';

  @override
  String get bulkOnboardingNoRealProvisioningNotice =>
      'A feltöltés nem hoz létre felhasználót, járművet, pótkocsit vagy meghívót.';

  @override
  String get bulkOnboardingHumanApprovalNotice =>
      'Emberi jóváhagyás szükséges a jövőbeli feldolgozáshoz.';

  @override
  String get bulkOnboardingValidationCompleted => 'Validálás kész.';

  @override
  String get bulkOnboardingRowsParsed => 'Sorok feldolgozva.';

  @override
  String get bulkOnboardingUploadSuccessful => 'Feltöltés sikeres.';

  @override
  String get bulkOnboardingUploadFailed => 'Feltöltés sikertelen.';

  @override
  String get bulkOnboardingUnsupportedFileType => 'Nem támogatott fájltípus.';

  @override
  String get bulkOnboardingTooManyRows => 'Túl sok sor a fájlban.';

  @override
  String get bulkOnboardingEmptyFile => 'A kiválasztott fájl üres.';

  @override
  String get bulkOnboardingFileRequired => 'CSV fájl szükséges.';

  @override
  String get bulkOnboardingUploadTypeRequired =>
      'Import típus megadása kötelező.';

  @override
  String get bulkOnboardingUploadTypeLabel => 'Import típus';

  @override
  String get bulkOnboardingUploadCompanyIdLabel =>
      'Cég azonosító (opcionális jóváhagyásig)';

  @override
  String get bulkOnboardingUploadCompanyNameLabel => 'Cégnév';

  @override
  String get bulkOnboardingUploadNoteLabel => 'Admin megjegyzés (opcionális)';

  @override
  String get bulkOnboardingUploadProgress => 'Feltöltés…';

  @override
  String get bulkOnboardingUploadForbidden =>
      'Nincs jogosultsága import feltöltéshez.';

  @override
  String get bulkOnboardingMockUploadBadge => 'Mock feltöltési előnézet';

  @override
  String get bulkOnboardingRowsSearchHint => 'Sorok keresése';

  @override
  String get bulkOnboardingRowFilterValid => 'Érvényes';

  @override
  String get bulkOnboardingRowFilterProcessed => 'Feldolgozott';

  @override
  String get bulkOnboardingRowFilterFailed => 'Sikertelen';

  @override
  String get bulkOnboardingRowFilterSkipped => 'Kihagyott';

  @override
  String get bulkOnboardingRowDetailTitle => 'Import sor';

  @override
  String get bulkOnboardingRowDetailError =>
      'Az import sor részletei nem tölthetők be.';

  @override
  String get bulkOnboardingRowOriginalValuesTitle =>
      'Eredeti importált értékek';

  @override
  String get bulkOnboardingRowCorrectedValuesTitle => 'Javított értékek';

  @override
  String bulkOnboardingRowLastValidatedAt(String date) {
    return 'Utolsó ellenőrzés: $date';
  }

  @override
  String bulkOnboardingJobLastValidatedAt(String date) {
    return 'Munka utolsó ellenőrzése: $date';
  }

  @override
  String get bulkOnboardingRowCorrectionTitle => 'Import sor javítása';

  @override
  String get bulkOnboardingRowCorrectionNotice =>
      'Érvénytelen mezők frissítése. Az eredeti importált értékek audit céljából megmaradnak.';

  @override
  String get bulkOnboardingRowCorrectionNoteLabel =>
      'Javítási megjegyzés (opcionális)';

  @override
  String get bulkOnboardingRowCorrectionConfirm => 'Javítás mentése';

  @override
  String get bulkOnboardingRowCorrectionAction => 'Sor javítása';

  @override
  String get bulkOnboardingRowCorrectionFieldRequired =>
      'Legalább egy javítandó mező megadása kötelező.';

  @override
  String get bulkOnboardingRowFieldName => 'Név';

  @override
  String get bulkOnboardingRowFieldEmail => 'E-mail';

  @override
  String get bulkOnboardingRowFieldPhone => 'Telefon';

  @override
  String get bulkOnboardingRowFieldCountry => 'Ország';

  @override
  String get bulkOnboardingRowFieldRole => 'Szerep';

  @override
  String get bulkOnboardingRowFieldVehiclePlate => 'Jármű rendszám';

  @override
  String get bulkOnboardingRowFieldTrailerPlate => 'Pótkocsi rendszám';

  @override
  String get bulkOnboardingRowSkipTitle => 'Import sor kihagyása';

  @override
  String get bulkOnboardingRowSkipNotice =>
      'A kihagyott sorok kimaradnak az ellenőrzési számításokból és feldolgozásból.';

  @override
  String get bulkOnboardingRowSkipReasonLabel => 'Kihagyás oka';

  @override
  String get bulkOnboardingRowSkipReasonRequired => 'A kihagyás oka kötelező.';

  @override
  String get bulkOnboardingRowSkipConfirm => 'Sor kihagyása';

  @override
  String get bulkOnboardingRowSkipAction => 'Sor kihagyása';

  @override
  String get bulkOnboardingRowRevalidateAction => 'Sor újraellenőrzése';

  @override
  String get bulkOnboardingJobRevalidateAction => 'Munka újraellenőrzése';

  @override
  String get bulkOnboardingJobRevalidateSuccess =>
      'A munka újraellenőrzése kész.';

  @override
  String get bulkOnboardingRowActionAuditNotice =>
      'A művelet audit naplózásra kerül. Nem jön létre fiók vagy eszköz.';

  @override
  String get bulkOnboardingRowActionSuccess => 'A sor sikeresen frissült.';

  @override
  String get bulkOnboardingRowActionUnavailable =>
      'A sor művelet nem érhető el.';

  @override
  String bulkOnboardingMetricSkippedRows(String count) {
    return 'Kihagyott: $count';
  }

  @override
  String get bulkOnboardingValidationWarnings => 'Ellenőrzési figyelmeztetések';

  @override
  String get navCompanies => 'Cégek';

  @override
  String get platformCompaniesTitle => 'Cégek';

  @override
  String get platformCompanyDetailTitle => 'Cég részletei';

  @override
  String get platformCompanySearchHint =>
      'Keresés név, adószám vagy ország szerint';

  @override
  String get platformCompanyListEmpty => 'Nincs a szűrőknek megfelelő cég.';

  @override
  String get platformCompanyListError => 'A cégek betöltése sikertelen.';

  @override
  String get platformCompanyDetailError => 'A cég részletei nem tölthetők be.';

  @override
  String get platformCompanySummaryError =>
      'Az összegző adatok betöltése sikertelen.';

  @override
  String get platformCompanyMockDataBadge => 'Mock cégadatok';

  @override
  String get platformCompanyMetadataBadge => 'Csak metaadat';

  @override
  String get platformCompanyOpenModule => 'Cégek megnyitása';

  @override
  String get platformCompanyPrivacyNotice =>
      'Csak metaadatok. Utazások, dokumentumok és üzenetek nem jelennek meg.';

  @override
  String get platformCompanyDashboardTitle => 'Cég áttekintés';

  @override
  String platformCompanyDashboardActive(String count) {
    return 'Aktív: $count';
  }

  @override
  String platformCompanyDashboardPendingReview(String count) {
    return 'Ellenőrzésre vár: $count';
  }

  @override
  String platformCompanyDashboardSuspended(String count) {
    return 'Felfüggesztett: $count';
  }

  @override
  String platformCompanyDashboardOpenSupport(String count) {
    return 'Nyitott support: $count';
  }

  @override
  String platformCompanyDashboardPendingOnboarding(String count) {
    return 'Függő onboarding: $count';
  }

  @override
  String get platformCompanyFilterAll => 'Összes';

  @override
  String get platformCompanyFilterActive => 'Aktív';

  @override
  String get platformCompanyFilterPendingReview => 'Ellenőrzésre vár';

  @override
  String get platformCompanyFilterSuspended => 'Felfüggesztett';

  @override
  String get platformCompanyFilterDisabled => 'Letiltott';

  @override
  String get platformCompanyStatusActive => 'Aktív';

  @override
  String get platformCompanyStatusPendingReview => 'Ellenőrzésre vár';

  @override
  String get platformCompanyStatusSuspended => 'Felfüggesztett';

  @override
  String get platformCompanyStatusDisabled => 'Letiltott';

  @override
  String get platformCompanyStatusArchived => 'Archivált';

  @override
  String get platformCompanyStatusUnknown => 'Ismeretlen';

  @override
  String platformCompanyMetricActiveUsers(String count) {
    return 'Aktív felhasználók: $count';
  }

  @override
  String platformCompanyMetricDrivers(String count) {
    return 'Sofőrök: $count';
  }

  @override
  String platformCompanyMetricVehicles(String count) {
    return 'Járművek: $count';
  }

  @override
  String platformCompanyMetricTrailers(String count) {
    return 'Pótkocsik: $count';
  }

  @override
  String platformCompanyMetricOpenSupport(String count) {
    return 'Nyitott support: $count';
  }

  @override
  String platformCompanyMetricActiveGrants(String count) {
    return 'Aktív grantek: $count';
  }

  @override
  String platformCompanyMetricTotalUsers(String count) {
    return 'Összes felhasználó: $count';
  }

  @override
  String platformCompanyMetricPendingRegistrations(String count) {
    return 'Függő regisztrációk: $count';
  }

  @override
  String platformCompanyMetricPendingBulkJobs(String count) {
    return 'Függő bulk munkák: $count';
  }

  @override
  String get platformCompanySectionMetadata => 'Cég metaadatok';

  @override
  String get platformCompanySectionUsers => 'Felhasználó összegzés';

  @override
  String get platformCompanySectionSupport => 'Support és flotta összegzés';

  @override
  String get platformCompanySectionOnboarding => 'Onboarding összegzés';

  @override
  String get platformCompanyFieldCountry => 'Ország';

  @override
  String get platformCompanyFieldVat => 'Adószám';

  @override
  String get platformCompanyFieldRegistrationNumber => 'Cégjegyzékszám';

  @override
  String get platformCompanyFieldPlan => 'Csomag';

  @override
  String get platformCompanyFieldSubscriptionStatus => 'Előfizetés státusza';

  @override
  String get platformCompanyFieldLastAdminActivity => 'Utolsó admin aktivitás';

  @override
  String get platformCompanyChangeStatusAction => 'Státusz módosítása';

  @override
  String get platformCompanyStatusDialogTitle => 'Cég státusz módosítása';

  @override
  String get platformCompanyStatusDialogNotice =>
      'Korlátozó státuszokhoz indoklás szükséges. A művelet audit naplózásra kerül.';

  @override
  String get platformCompanyStatusFieldLabel => 'Új státusz';

  @override
  String get platformCompanyStatusReasonLabel => 'Indoklás';

  @override
  String get platformCompanyStatusReasonRequired =>
      'Ehhez a státuszhoz indoklás kötelező.';

  @override
  String get platformCompanyStatusAuditNotice =>
      'A státuszváltozások audit naplózásra kerülnek. Itt nem történik számlázás vagy provisioning.';

  @override
  String get platformCompanyStatusDismiss => 'Mégse';

  @override
  String get platformCompanyStatusConfirm => 'Státusz frissítése';

  @override
  String get platformCompanyStatusSuccess => 'A cég státusza frissült.';

  @override
  String get platformCompanyStatusUnavailable =>
      'A státuszváltoztatás nem érhető el.';
}
