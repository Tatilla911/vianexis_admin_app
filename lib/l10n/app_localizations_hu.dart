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
  String get navPublicIntakes => 'Publikus megkeresések';

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
  String get authInvalidCredentials => 'Hibás e-mail cím vagy jelszó.';

  @override
  String get authNetworkError =>
      'Hálózati hiba. Ellenőrizd az internetkapcsolatot vagy a staging API elérhetőségét.';

  @override
  String get authServerError => 'Szerverhiba. Próbálja újra később.';

  @override
  String get authForbiddenRole =>
      'Ehhez a felülethez nincs megfelelő jogosultságod.';

  @override
  String get authLoginServiceUnavailable =>
      'A bejelentkezési szolgáltatás nem érhető el ebben a környezetben.';

  @override
  String get authPasswordChangeInvalidCurrent =>
      'A jelenlegi jelszó helytelen.';

  @override
  String get authPasswordChangeWeakPassword =>
      'Az új jelszónak legalább 16 karakter hosszúnak kell lennie.';

  @override
  String get authPasswordChangeUnchanged =>
      'Az új jelszó nem egyezhet a jelenlegivel.';

  @override
  String get settingsAccountSecuritySection => 'Fiók biztonsága';

  @override
  String get settingsChangePasswordAction => 'Jelszó módosítása';

  @override
  String get settingsChangePasswordTitle => 'Fiókjelszó módosítása';

  @override
  String get settingsChangePasswordBody =>
      'Frissítse a platform fiók jelszavát. Ez különáll a helyi eszköz PIN-től.';

  @override
  String get settingsCurrentPasswordLabel => 'Jelenlegi jelszó';

  @override
  String get settingsNewPasswordLabel => 'Új jelszó';

  @override
  String get settingsConfirmPasswordLabel => 'Új jelszó megerősítése';

  @override
  String get settingsPasswordChangeSuccess =>
      'A jelszó frissült. Jelentkezzen be újra az új jelszóval.';

  @override
  String get settingsPasswordMinLengthValidation =>
      'A jelszónak legalább 16 karakter hosszúnak kell lennie.';

  @override
  String get settingsPasswordMismatchValidation => 'A jelszavak nem egyeznek.';

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
  String get bulkOnboardingDryRunAction => 'Próbafuttatás';

  @override
  String get bulkOnboardingExecuteAction => 'Végrehajtás';

  @override
  String get bulkOnboardingExecuteDisabled => 'Végrehajtás nem elérhető';

  @override
  String get bulkOnboardingDryRunSuccess => 'A próbafuttatás befejeződött.';

  @override
  String get bulkOnboardingExecuteSuccess =>
      'A végrehajtás elindult és audit naplózva lett.';

  @override
  String get bulkOnboardingProvisioningTitle => 'Provisioning';

  @override
  String bulkOnboardingProvisioningStatus(Object status) {
    return 'Provisioning állapot: $status';
  }

  @override
  String bulkOnboardingExecutePolicyDisabled(Object reason) {
    return 'A végrehajtást szabályzat blokkolta: $reason';
  }

  @override
  String get bulkOnboardingExecuteDialogTitle => 'Provisioning végrehajtása';

  @override
  String get bulkOnboardingExecuteMetadataNotice =>
      'Itt csak metaadatok láthatók. Tenant működési tartalom nem jelenik meg.';

  @override
  String get bulkOnboardingExecuteIrreversibleWarning =>
      'Ez a művelet visszafordíthatatlan, és valós entitásokat hozhat létre.';

  @override
  String bulkOnboardingExecuteRowWindow(Object count, Object maxRows) {
    return 'Végrehajtandó sorok: $count / max $maxRows';
  }

  @override
  String get bulkOnboardingExecuteReasonLabel => 'Végrehajtás indoka';

  @override
  String get bulkOnboardingExecuteReasonRequired =>
      'A végrehajtás indoka kötelező.';

  @override
  String get bulkOnboardingExecuteConfirmRequired =>
      'A végrehajtás megerősítése kötelező.';

  @override
  String get bulkOnboardingExecuteConfirmCheckbox =>
      'Tudomásul veszem, hogy ez nem vonható vissza.';

  @override
  String get bulkOnboardingExecuteConfirmAction => 'Végrehajtás most';

  @override
  String get bulkOnboardingSummaryDryRunOk => 'Próbafuttatás ok';

  @override
  String get bulkOnboardingSummaryBlocked => 'Blokkolt';

  @override
  String get bulkOnboardingSummaryDuplicates => 'Duplikált';

  @override
  String get bulkOnboardingSummaryFailed => 'Hibás';

  @override
  String get bulkOnboardingSummaryProvisioned => 'Létrehozott';

  @override
  String get bulkOnboardingRowExecutionStatusesTitle =>
      'Sor szintű végrehajtási állapotok';

  @override
  String get bulkOnboardingExecuteRejectedPolicy =>
      'A végrehajtást szabályzat elutasította. Ellenőrizd a sorlimitet és az állapotot.';

  @override
  String get bulkOnboardingExecuteRejectedValidation =>
      'A végrehajtást a backend validáció elutasította.';

  @override
  String get bulkOnboardingExecuteForbidden =>
      'Nincs jogosultságod a feladat végrehajtásához.';

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

  @override
  String get platformCompanyExchangeSettingsAction =>
      'Raklap / göngyöleg beállítások';

  @override
  String get companyExchangeSettingsTitle => 'Céges exchange beállítások';

  @override
  String get companyExchangeMockDataBadge => 'Tesztadat';

  @override
  String get companyExchangeSaved => 'A beállítások mentve.';

  @override
  String get companyExchangeSaveFailed => 'A mentés sikertelen.';

  @override
  String get companyExchangeLoadFailed => 'A beállítások betöltése sikertelen.';

  @override
  String get companyExchangeBackendDependency =>
      'A backend exchange beállítások endpointja nem érhető el. Ellenőrizze az API hozzáférést és a szerepkört.';

  @override
  String get companyExchangePrivacyNotice =>
      'Csak céges feature flag és lista metaadat. Fuvar-, dokumentum- és üzenettartalom nem jelenik meg.';

  @override
  String get companyExchangeMockNotice =>
      'Teszt mód: a mentés csak helyi mock adatot frissít. Éles környezetben a backend API szükséges.';

  @override
  String get companyExchangePalletEnabled => 'Raklapcsere engedélyezve';

  @override
  String get companyExchangePalletEnabledHint =>
      'Sofőr app raklapcsere kártya megjelenítése.';

  @override
  String get companyExchangePackagingEnabled => 'Göngyölegcsere engedélyezve';

  @override
  String get companyExchangePackagingEnabledHint =>
      'Sofőr app göngyöleg kártya megjelenítése.';

  @override
  String get companyExchangeCustomItemsEnabled =>
      'Sofőr egyedi göngyöleg tételek';

  @override
  String get companyExchangeCustomItemsEnabledHint =>
      'Engedélyezi az egyedi tétel hozzáadást a sofőr appban.';

  @override
  String get companyExchangeDefaultPalletTypes =>
      'Alapértelmezett raklap típusok';

  @override
  String get companyExchangeDefaultPackagingItems =>
      'Alapértelmezett göngyöleg lista';

  @override
  String get companyExchangeDefaultPackagingPlaceholder =>
      'A lista szerkesztése későbbi admin verzióban érkezik. Jelenleg csak olvasható előnézet.';

  @override
  String get companyExchangeItemInactive => 'Inaktív';

  @override
  String get companyExchangeSave => 'Mentés';

  @override
  String get navBilling => 'Számlázás';

  @override
  String get billingTitle => 'Számlázás';

  @override
  String get billingTabSubscriptions => 'Előfizetések';

  @override
  String get billingTabPricingIntakes => 'Árazási igények';

  @override
  String get billingTabQuoteRequests => 'Ajánlatkérések';

  @override
  String get billingMockDataBadge => 'Tesztadat';

  @override
  String get billingMetadataBadge => 'Csak metaadat';

  @override
  String get billingLoadError => 'A számlázási adatok betöltése sikertelen.';

  @override
  String get billingDetailError =>
      'A számlázási részletek betöltése sikertelen.';

  @override
  String get billingOpenModule => 'Számlázás modul megnyitása';

  @override
  String get billingPrivacyNotice =>
      'A számlázási nézetek csak metaadatot és számokat mutatnak. Itt nem történik fizetés-feldolgozás vagy dokumentum-hozzáférés.';

  @override
  String get billingOverviewTitle => 'Számlázási áttekintés';

  @override
  String billingOverviewActive(String count) {
    return 'Aktív: $count';
  }

  @override
  String billingOverviewTrial(String count) {
    return 'Próba: $count';
  }

  @override
  String billingOverviewPastDue(String count) {
    return 'Lejárt: $count';
  }

  @override
  String billingOverviewSuspended(String count) {
    return 'Felfüggesztett: $count';
  }

  @override
  String billingOverviewPricingNew(String count) {
    return 'Új igények: $count';
  }

  @override
  String billingOverviewQuotesPending(String count) {
    return 'Függő ajánlatok: $count';
  }

  @override
  String billingOverviewLastUpdated(String date) {
    return 'Utolsó frissítés: $date';
  }

  @override
  String get dashboardMetricBillingAttention => 'Számlázási figyelmet igényel';

  @override
  String get billingSubscriptionSearchHint => 'Előfizetések keresése';

  @override
  String get billingSubscriptionListEmpty =>
      'Nincs a szűrőknek megfelelő előfizetés.';

  @override
  String get billingSubscriptionDetailTitle => 'Előfizetés részletei';

  @override
  String get billingSubscriptionFilterAll => 'Összes';

  @override
  String get billingSubscriptionFilterActive => 'Aktív';

  @override
  String get billingSubscriptionFilterTrial => 'Próba';

  @override
  String get billingSubscriptionFilterPastDue => 'Lejárt';

  @override
  String get billingSubscriptionFilterSuspended => 'Felfüggesztett';

  @override
  String get billingSubscriptionFilterCancelled => 'Lemondott';

  @override
  String get billingSubscriptionStatusTrial => 'Próba';

  @override
  String get billingSubscriptionStatusActive => 'Aktív';

  @override
  String get billingSubscriptionStatusPastDue => 'Lejárt';

  @override
  String get billingSubscriptionStatusSuspended => 'Felfüggesztett';

  @override
  String get billingSubscriptionStatusCancelled => 'Lemondott';

  @override
  String get billingSubscriptionStatusCustomQuotePending =>
      'Egyedi ajánlat függőben';

  @override
  String get billingSubscriptionStatusUnknown => 'Ismeretlen';

  @override
  String get billingPricingIntakeSearchHint => 'Árazási igények keresése';

  @override
  String get billingPricingIntakeListEmpty =>
      'Nincs a szűrőknek megfelelő árazási igény.';

  @override
  String get billingPricingIntakeDetailTitle => 'Árazási igény részletei';

  @override
  String get billingPricingIntakeNeedsReview =>
      'Emberi felülvizsgálat szükséges';

  @override
  String get billingPricingIntakeFilterAll => 'Összes';

  @override
  String get billingPricingIntakeFilterNew => 'Új';

  @override
  String get billingPricingIntakeFilterReviewing => 'Felülvizsgálat alatt';

  @override
  String get billingPricingIntakeFilterQuoted => 'Ajánlatolt';

  @override
  String get billingPricingIntakeFilterAccepted => 'Elfogadott';

  @override
  String get billingPricingIntakeFilterRejected => 'Elutasított';

  @override
  String get billingPricingIntakeStatusNew => 'Új';

  @override
  String get billingPricingIntakeStatusReviewing => 'Felülvizsgálat alatt';

  @override
  String get billingPricingIntakeStatusQuoted => 'Ajánlatolt';

  @override
  String get billingPricingIntakeStatusAccepted => 'Elfogadott';

  @override
  String get billingPricingIntakeStatusRejected => 'Elutasított';

  @override
  String get billingPricingIntakeStatusUnknown => 'Ismeretlen';

  @override
  String get billingQuoteRequestSearchHint => 'Ajánlatkérések keresése';

  @override
  String get billingQuoteRequestListEmpty =>
      'Nincs a szűrőknek megfelelő ajánlatkérés.';

  @override
  String get billingQuoteRequestDetailTitle => 'Ajánlatkérés részletei';

  @override
  String get billingQuoteRequestFilterAll => 'Összes';

  @override
  String get billingQuoteRequestFilterSubmitted => 'Beküldött';

  @override
  String get billingQuoteRequestFilterUnderReview => 'Felülvizsgálat alatt';

  @override
  String get billingQuoteRequestFilterQuoted => 'Ajánlatolt';

  @override
  String get billingQuoteRequestFilterAccepted => 'Elfogadott';

  @override
  String get billingQuoteRequestFilterRejected => 'Elutasított';

  @override
  String get billingQuoteRequestStatusDraft => 'Piszkozat';

  @override
  String get billingQuoteRequestStatusSubmitted => 'Beküldött';

  @override
  String get billingQuoteRequestStatusUnderReview => 'Felülvizsgálat alatt';

  @override
  String get billingQuoteRequestStatusQuoted => 'Ajánlatolt';

  @override
  String get billingQuoteRequestStatusAccepted => 'Elfogadott';

  @override
  String get billingQuoteRequestStatusRejected => 'Elutasított';

  @override
  String get billingQuoteRequestStatusUnknown => 'Ismeretlen';

  @override
  String billingMetricSeats(String used, String included) {
    return 'Ülőhelyek: $used/$included';
  }

  @override
  String billingMetricDriverApps(String used, String included) {
    return 'Sofőr appok: $used/$included';
  }

  @override
  String billingMetricFleetSize(String count) {
    return 'Flotta méret: $count';
  }

  @override
  String billingMetricOfficeUsers(String count) {
    return 'Irodai felhasználók: $count';
  }

  @override
  String billingMetricDriverAppsRequested(String count) {
    return 'Igényelt sofőr appok: $count';
  }

  @override
  String billingFieldCompanyId(String id) {
    return 'Cég #$id';
  }

  @override
  String get billingFieldPlan => 'Csomag';

  @override
  String get billingFieldBillingCycle => 'Számlázási ciklus';

  @override
  String get billingFieldCurrency => 'Pénznem';

  @override
  String get billingFieldPricingSource => 'Árazás forrása';

  @override
  String get billingFieldOperatingModel => 'Üzemeltetési modell';

  @override
  String get billingFieldAiAddOn => 'AI kiegészítő';

  @override
  String get billingFieldStartedAt => 'Kezdés';

  @override
  String get billingFieldRenewsAt => 'Megújul';

  @override
  String get billingFieldCancelledAt => 'Lemondva';

  @override
  String get billingFieldLastPaymentStatus => 'Utolsó fizetési státusz';

  @override
  String get billingFieldContactEmail => 'Kapcsolattartó e-mail';

  @override
  String get billingFieldCountry => 'Ország';

  @override
  String get billingFieldCreatedAt => 'Létrehozva';

  @override
  String get billingSectionPlan => 'Csomag és számlázás';

  @override
  String get billingSectionUsage => 'Használat';

  @override
  String get billingSectionDates => 'Dátumok';

  @override
  String get billingSectionContact => 'Kapcsolat';

  @override
  String get billingSectionFleet => 'Flotta méretezés';

  @override
  String get billingSectionModules => 'Igényelt modulok';

  @override
  String get billingSectionAiFeatures => 'Igényelt AI funkciók';

  @override
  String get billingYes => 'Igen';

  @override
  String get billingNo => 'Nem';

  @override
  String get billingNoneReported => 'Nincs megadva';

  @override
  String get billingChangeStatusAction => 'Státusz módosítása';

  @override
  String get billingActionDialogTitle => 'Számlázási státusz frissítése';

  @override
  String get billingActionAuditNotice =>
      'A státuszváltozások audit naplózásra kerülnek. Itt nem történik fizetés-feldolgozás.';

  @override
  String billingActionCurrentStatus(String status) {
    return 'Jelenlegi státusz: $status';
  }

  @override
  String get billingActionStatusLabel => 'Új státusz';

  @override
  String get billingActionStatusRequired => 'Válasszon státuszt.';

  @override
  String get billingActionReasonLabel => 'Indok';

  @override
  String get billingActionReasonRequired =>
      'Ehhez a státuszhoz indok szükséges.';

  @override
  String get billingActionNoteLabel => 'Belső megjegyzés (opcionális)';

  @override
  String get billingActionConfirm => 'Státusz frissítése';

  @override
  String get billingActionSuccess => 'A számlázási státusz frissítve.';

  @override
  String get billingActionError =>
      'A számlázási státusz frissítése sikertelen.';

  @override
  String get billingActionUnavailable => 'A státuszváltoztatás nem érhető el.';

  @override
  String get navActionCenter => 'Teendők';

  @override
  String get navSecurityCenter => 'Biztonsági központ';

  @override
  String get navAdminUsers => 'Admin felhasználók';

  @override
  String get navReleaseCenter => 'Kihelyezési központ';

  @override
  String get adminUsersTitle => 'Admin felhasználók';

  @override
  String get adminUserDetailTitle => 'Admin felhasználó részletei';

  @override
  String get adminUserLoadError =>
      'Az admin felhasználók betöltése sikertelen.';

  @override
  String get adminUserDetailError =>
      'Az admin felhasználó betöltése sikertelen.';

  @override
  String get adminUserMockDataBadge => 'Mintaadat';

  @override
  String get adminUserMetadataBadge => 'Csak metaadat';

  @override
  String get adminUserOpenModule => 'Admin felhasználók megnyitása';

  @override
  String get adminUserPrivacyNotice =>
      'Az admin nézetek csak metaadatot mutatnak. Jelszavak és hitelesítő adatok nem jelennek meg.';

  @override
  String get adminUserSearchHint => 'Admin felhasználók keresése';

  @override
  String get adminUserListEmpty =>
      'Nincs a szűrőnek megfelelő admin felhasználó.';

  @override
  String get adminUserInviteAction => 'Admin meghívása';

  @override
  String get adminUserInviteTitle => 'Platform admin meghívása';

  @override
  String get adminUserInviteNotice =>
      'A meghívás metaadat-only platform admin rekordot hoz létre. Az e-mail kézbesítés függőben lehet.';

  @override
  String get adminUserInviteNoteLabel => 'Belső megjegyzés (opcionális)';

  @override
  String get adminUserInviteConfirm => 'Meghívás küldése';

  @override
  String get adminUserInviteSuccess => 'Admin felhasználó meghívva.';

  @override
  String get adminUserFilterAll => 'Összes';

  @override
  String get adminUserFilterActive => 'Aktív';

  @override
  String get adminUserFilterInvited => 'Meghívott';

  @override
  String get adminUserFilterSuspended => 'Felfüggesztett';

  @override
  String get adminUserFilterDisabled => 'Letiltott';

  @override
  String get adminUserStatusActive => 'Aktív';

  @override
  String get adminUserStatusInvited => 'Meghívott';

  @override
  String get adminUserStatusSuspended => 'Felfüggesztett';

  @override
  String get adminUserStatusDisabled => 'Letiltott';

  @override
  String get adminUserStatusUnknown => 'Ismeretlen';

  @override
  String get adminUserRoleUnknown => 'Ismeretlen szerepkör';

  @override
  String adminUserLastLogin(String date) {
    return 'Utolsó bejelentkezés: $date';
  }

  @override
  String adminUserFailedLogins(String count) {
    return 'Sikertelen bejelentkezések: $count';
  }

  @override
  String get adminUserFieldName => 'Név';

  @override
  String get adminUserFieldEmail => 'E-mail';

  @override
  String get adminUserFieldRole => 'Szerepkör';

  @override
  String get adminUserFieldStatus => 'Státusz';

  @override
  String get adminUserFieldCreatedAt => 'Létrehozva';

  @override
  String get adminUserFieldLastLoginAt => 'Utolsó bejelentkezés';

  @override
  String get adminUserFieldFailedLoginCount =>
      'Sikertelen bejelentkezések száma';

  @override
  String get adminUserChangeRoleAction => 'Szerepkör módosítása';

  @override
  String get adminUserChangeStatusAction => 'Státusz módosítása';

  @override
  String get adminUserRoleDialogTitle => 'Admin szerepkör módosítása';

  @override
  String get adminUserStatusDialogTitle => 'Admin státusz módosítása';

  @override
  String adminUserActionCurrentRole(String role) {
    return 'Jelenlegi szerepkör: $role';
  }

  @override
  String adminUserActionCurrentStatus(String status) {
    return 'Jelenlegi státusz: $status';
  }

  @override
  String get adminUserReasonLabel => 'Indok';

  @override
  String get adminUserReasonRequired => 'Indok megadása kötelező.';

  @override
  String get adminUserNameRequired => 'A név legalább 2 karakter legyen.';

  @override
  String get adminUserActionAuditNotice =>
      'Az admin módosítások audit naplózásra kerülnek.';

  @override
  String get adminUserActionCancel => 'Mégse';

  @override
  String get adminUserRoleConfirm => 'Szerepkör frissítése';

  @override
  String get adminUserStatusConfirm => 'Státusz frissítése';

  @override
  String get adminUserRoleSuccess => 'Admin szerepkör frissítve.';

  @override
  String get adminUserStatusSuccess => 'Admin státusz frissítve.';

  @override
  String get adminUserActionError =>
      'Az admin felhasználó frissítése sikertelen.';

  @override
  String get adminUserActionUnavailable =>
      'Az admin kezelés super_admin jogosultságot igényel.';

  @override
  String get securityCenterTitle => 'Biztonsági központ';

  @override
  String get securityEventDetailTitle => 'Biztonsági esemény részletei';

  @override
  String get securityLoadError => 'A biztonsági adatok betöltése sikertelen.';

  @override
  String get securityMockDataBadge => 'Mintaadat';

  @override
  String get securityOpenModule => 'Biztonsági központ megnyitása';

  @override
  String get securityPrivacyNotice =>
      'A biztonsági nézetek csak metaadatot mutatnak. Üzenettörzs és dokumentumtartalom nem jelenik meg.';

  @override
  String get securityOverviewTitle => 'Biztonsági áttekintés';

  @override
  String securityOverviewFailedLogins(String count) {
    return 'Sikertelen bejelentkezések: $count';
  }

  @override
  String securityOverviewDeniedActions(String count) {
    return 'Elutasított műveletek: $count';
  }

  @override
  String securityOverviewActiveGrants(String count) {
    return 'Aktív támogatási jogosultságok: $count';
  }

  @override
  String securityOverviewCriticalEvents(String count) {
    return 'Kritikus biztonsági események: $count';
  }

  @override
  String securityOverviewExpiringGrants(String count) {
    return 'Lejáró jogosultságok: $count';
  }

  @override
  String securityOverviewHighRiskAi(String count) {
    return 'Magas kockázatú AI felülvizsgálatok: $count';
  }

  @override
  String securityOverviewSuspiciousBulk(String count) {
    return 'Gyanús tömeges importok: $count';
  }

  @override
  String get securityOverviewNoCritical => 'Nincs rögzített kritikus esemény';

  @override
  String securityOverviewLastCritical(String date) {
    return 'Utolsó kritikus esemény: $date';
  }

  @override
  String get securityEventSearchHint => 'Biztonsági események keresése';

  @override
  String get securityEventListEmpty =>
      'Nincs a szűrőnek megfelelő biztonsági esemény.';

  @override
  String get securityEventDetailError => 'A biztonsági esemény nem található.';

  @override
  String securityEventCompanyLabel(String name) {
    return 'Cég: $name';
  }

  @override
  String securityEventCreatedAt(String date) {
    return 'Létrehozva: $date';
  }

  @override
  String get securityEventFieldSourceType => 'Forrás típusa';

  @override
  String get securityEventFieldSourceId => 'Forrás azonosító';

  @override
  String get securityEventFieldActorEmail => 'Szereplő e-mail';

  @override
  String get securityEventFieldActorRole => 'Szereplő szerepkör';

  @override
  String get securityEventFieldCompany => 'Cég';

  @override
  String get securityEventFieldCorrelationId => 'Korrelációs azonosító';

  @override
  String get securityEventFieldCreatedAt => 'Létrehozva';

  @override
  String get securityEventFilterAll => 'Összes';

  @override
  String get securityEventFilterFailedLogin => 'Sikertelen bejelentkezések';

  @override
  String get securityEventFilterPermissionDenied => 'Elutasított műveletek';

  @override
  String get securityEventFilterSupportAccess => 'Támogatási hozzáférés';

  @override
  String get securityEventFilterHighRiskAi => 'Magas kockázatú AI';

  @override
  String get securityEventFilterCriticalSystem => 'Kritikus rendszer';

  @override
  String get securityEventFilterAdminRoleChange => 'Admin változások';

  @override
  String get securityEventFilterSuspiciousBulkOnboarding =>
      'Gyanús tömeges import';

  @override
  String get securityEventFilterCritical => 'Kritikus';

  @override
  String get securityEventFilterWarning => 'Figyelmeztetés';

  @override
  String get securityEventTypeFailedLogin => 'Sikertelen bejelentkezés';

  @override
  String get securityEventTypePermissionDenied => 'Jogosultság megtagadva';

  @override
  String get securityEventTypeSupportAccess => 'Támogatási hozzáférés';

  @override
  String get securityEventTypeHighRiskAi => 'Magas kockázatú AI';

  @override
  String get securityEventTypeCriticalSystem => 'Kritikus rendszer';

  @override
  String get securityEventTypeAdminRoleChange => 'Admin változás';

  @override
  String get securityEventTypeSuspiciousBulkOnboarding =>
      'Gyanús tömeges import';

  @override
  String get securityEventTypeUnknown => 'Ismeretlen';

  @override
  String get securityEventSeverityInfo => 'Információ';

  @override
  String get securityEventSeverityWarning => 'Figyelmeztetés';

  @override
  String get securityEventSeverityCritical => 'Kritikus';

  @override
  String get securityEventSeverityUnknown => 'Ismeretlen';

  @override
  String get actionCenterTitle => 'Teendők';

  @override
  String get actionCenterLoadError => 'A teendők betöltése sikertelen.';

  @override
  String get actionCenterMockDataBadge => 'Mintaadat';

  @override
  String get actionCenterOpenModule => 'Teendők megnyitása';

  @override
  String get actionCenterPrivacyNotice =>
      'A teendők metaadat-only összefoglalók. A részletekért nyissa meg a kapcsolt modulokat.';

  @override
  String get actionCenterReadOnlyNotice =>
      'A tételek a rendszer aktuális állapotát tükrözik. A mögöttes ügy megoldásakor eltűnnek. Szerver oldali elvetés ebben a kiadásban nem érhető el.';

  @override
  String get actionCenterSearchHint => 'Teendők keresése';

  @override
  String get actionCenterListEmpty => 'Nincs a szűrőnek megfelelő teendő.';

  @override
  String get actionCenterListEmptyDetail =>
      'Ha regisztrációk, support jegyek, publikus megkeresések vagy állapot események figyelmet igényelnek, itt jelennek meg automatikusan.';

  @override
  String get actionCenterNeedsAttentionTitle => 'Figyelmet igényel';

  @override
  String actionCenterNeedsAttentionOpen(String count) {
    return 'Nyitott elemek: $count';
  }

  @override
  String actionCenterNeedsAttentionCritical(String count) {
    return 'Kritikus/sürgős: $count';
  }

  @override
  String actionCenterNeedsAttentionTotal(String count) {
    return 'Összes elem: $count';
  }

  @override
  String actionCenterCompanyLabel(String name) {
    return 'Cég: $name';
  }

  @override
  String actionCenterCreatedAt(String date) {
    return 'Létrehozva: $date';
  }

  @override
  String get actionCenterFilterAll => 'Összes';

  @override
  String get actionCenterFilterRegistration => 'Regisztrációk';

  @override
  String get actionCenterFilterBulkOnboarding => 'Tömeges onboarding';

  @override
  String get actionCenterFilterSupport => 'Támogatás';

  @override
  String get actionCenterFilterSystemHealth => 'Rendszerállapot';

  @override
  String get actionCenterFilterSecurity => 'Biztonság';

  @override
  String get actionCenterFilterBilling => 'Számlázás';

  @override
  String get actionCenterFilterAiReview => 'AI felülvizsgálatok';

  @override
  String get actionCenterFilterCritical => 'Kritikus/sürgős';

  @override
  String get actionCenterFilterCustomerCommunication => 'Ügyfél kommunikáció';

  @override
  String get actionCenterTypeRegistration => 'Regisztráció';

  @override
  String get actionCenterTypeBulkOnboarding => 'Tömeges onboarding';

  @override
  String get actionCenterTypeSupport => 'Támogatás';

  @override
  String get actionCenterTypeSystemHealth => 'Rendszerállapot';

  @override
  String get actionCenterTypeSecurity => 'Biztonság';

  @override
  String get actionCenterTypeBilling => 'Számlázás';

  @override
  String get actionCenterTypeAiReview => 'AI felülvizsgálat';

  @override
  String get actionCenterTypeCompany => 'Cég';

  @override
  String get actionCenterTypeCustomerCommunication => 'Ügyfél kommunikáció';

  @override
  String get actionCenterTypeUnknown => 'Ismeretlen';

  @override
  String get actionCenterPriorityLow => 'Alacsony';

  @override
  String get actionCenterPriorityNormal => 'Normál';

  @override
  String get actionCenterPriorityHigh => 'Magas';

  @override
  String get actionCenterPriorityUrgent => 'Sürgős';

  @override
  String get actionCenterPriorityCritical => 'Kritikus';

  @override
  String get actionCenterPriorityUnknown => 'Ismeretlen';

  @override
  String get actionCenterStatusOpen => 'Nyitott';

  @override
  String get actionCenterStatusAcknowledged => 'Nyugtázott';

  @override
  String get actionCenterStatusDismissed => 'Elutasított';

  @override
  String get actionCenterStatusResolved => 'Megoldott';

  @override
  String get actionCenterStatusUnknown => 'Ismeretlen';

  @override
  String get releaseCenterTitle => 'Kihelyezési központ';

  @override
  String get releaseLoadError =>
      'A kihelyezési metaadatok betöltése sikertelen.';

  @override
  String get releaseMockDataBadge => 'Mintaadat';

  @override
  String get releaseReadOnlyBadge => 'Csak olvasható';

  @override
  String get releasePrivacyNotice =>
      'A kihelyezési nézetek csak metaadatot mutatnak. Titkok és tárolókulcsok nem jelennek meg.';

  @override
  String get releaseTabOverview => 'Áttekintés';

  @override
  String get releaseTabAppVersions => 'App verziók';

  @override
  String get releaseTabEnvironment => 'Környezet';

  @override
  String get releaseOverviewTitle => 'Kihelyezés áttekintése';

  @override
  String get releaseAppVersionsTitle => 'App verziók';

  @override
  String get releaseEnvironmentTitle => 'Környezet';

  @override
  String get releaseFieldBackendVersion => 'Backend verzió';

  @override
  String get releaseFieldEnvironment => 'Környezet';

  @override
  String get releaseFieldNodeEnv => 'Node környezet';

  @override
  String get releaseFieldMaintenanceMode => 'Karbantartási mód';

  @override
  String get releaseFieldLatestAdminApp => 'Legújabb admin app';

  @override
  String get releaseFieldLatestDriverApp => 'Legújabb sofőr app';

  @override
  String get releaseFieldMinAdminApp => 'Minimális admin app';

  @override
  String get releaseFieldMinDriverApp => 'Minimális sofőr app';

  @override
  String releaseFieldLastDeployment(String date) {
    return 'Utolsó kihelyezés: $date';
  }

  @override
  String get releaseFieldMigrationStatus => 'Adatbázis migrációk';

  @override
  String get releaseFieldDeploymentReady => 'Kihelyezés kész';

  @override
  String get releaseFieldApiPublicName => 'Nyilvános API név';

  @override
  String get releaseActiveAdminVersions => 'Aktív admin app verziók';

  @override
  String get releaseActiveDriverVersions => 'Aktív sofőr app verziók';

  @override
  String get releaseDeploymentWarnings => 'Kihelyezési figyelmeztetések';

  @override
  String get releaseYes => 'Igen';

  @override
  String get releaseNo => 'Nem';

  @override
  String get releaseEmailDeliveryTitle => 'E-mail kézbesítés';

  @override
  String get releaseEmailDeliveryProvider => 'Szolgáltató';

  @override
  String get releaseEmailDeliveryEnabled => 'Kézbesítés engedélyezve';

  @override
  String get releaseEmailDeliveryLastStatus => 'Utolsó kézbesítési státusz';

  @override
  String get releaseEmailDeliveryNotice =>
      'Az e-mail kézbesítési státusz csak szolgáltatót és metaadatot mutat. SMTP jelszavak és üzenettörzs nem jelenik meg.';

  @override
  String get releaseEmailDeliveryAllowlistEnabled =>
      'Staging allowlist engedelyezve';

  @override
  String get releaseEmailDeliveryAllowlistDomains =>
      'Engedelyezett domainek (szam)';

  @override
  String get releaseEmailDeliveryAllowlistRecipients =>
      'Engedelyezett címzettek (szam)';

  @override
  String get releaseEmailDeliveryLastFailureCode => 'Utolso hibakod';

  @override
  String get releaseEmailDeliveryStagingAllowlistMissing =>
      'Staging kezbesites engedelyezve, de hianyzik az allowlist — kulso kuldes blokkolva.';

  @override
  String get releaseEmailProviderNoop => 'No-op (kikapcsolva)';

  @override
  String get releaseEmailProviderSmtp => 'SMTP';

  @override
  String get releaseEmailProviderPlaceholder => 'Szolgáltató helyőrző';

  @override
  String get releaseObservabilityTitle => 'Megfigyelhetőség';

  @override
  String get releaseObservabilityLogLevel => 'Naplózási szint';

  @override
  String get releaseObservabilityMetricsEnabled => 'Metrikák engedélyezve';

  @override
  String get releaseObservabilitySentryConfigured => 'Sentry beállítva';

  @override
  String get releaseObservabilityOtelConfigured => 'OpenTelemetry beállítva';

  @override
  String get releaseObservabilityCorrelationId =>
      'Korrelációs azonosító engedélyezve';

  @override
  String get releaseObservabilityNotice =>
      'A megfigyelhetőségi státusz csak konfigurációs jelzőket mutat. DSN, végpont URL-ek és titkok nem jelennek meg.';

  @override
  String get settingsReleaseSection => 'Kihelyezés és környezet';

  @override
  String get settingsReleaseCenterBody =>
      'Olvasható kihelyezési metaadatok, app verziók és környezeti státusz megtekintése.';

  @override
  String get settingsOpenReleaseCenter => 'Kihelyezési központ megnyitása';

  @override
  String get appEnvLocal => 'Helyi';

  @override
  String get appEnvDev => 'Fejlesztői';

  @override
  String get appEnvStaging => 'Staging';

  @override
  String get appEnvProduction => 'Éles';

  @override
  String get appConfigEnvironmentLabel => 'Környezet';

  @override
  String get appConfigApiStatusLabel => 'API';

  @override
  String get appConfigApiConfigured => 'Beállítva';

  @override
  String get appConfigApiNotConfigured => 'Nincs beállítva';

  @override
  String get appConfigMockFallbackActive => 'Mintavisszaesés aktív';

  @override
  String get appConfigProductionMisconfigured =>
      'Az éles buildhez API_BASE_URL szükséges. A mintavisszaesés le van tiltva.';

  @override
  String get appConfigProductionLoginBlocked =>
      'A bejelentkezés az éles API_BASE_URL beállításáig tiltott.';

  @override
  String loginStagingApiHost(String host) {
    return 'Staging API: $host';
  }

  @override
  String get backendMockFallbackBanner =>
      'Az éles backend nincs beállítva. A modulok helyi fejlesztéshez mintaadatot használnak.';

  @override
  String get settingsApiHostLabel => 'API host';

  @override
  String get navNotifications => 'Ertesitesek';

  @override
  String get notificationsTitle => 'Ertesitesek';

  @override
  String get notificationsPreferences => 'Beallitasok';

  @override
  String get notificationsMarkAllRead => 'Osszes olvasottra';

  @override
  String get notificationsEmpty => 'Nincsenek ertesitesek.';

  @override
  String get notificationsInAppOnlyTitle =>
      'Csak alkalmazason beluli ertesitesek';

  @override
  String get notificationsInAppOnlyBody =>
      'A push csatornak ebben a fazisban nem aktivak.';

  @override
  String get notificationsDetailTitle => 'Ertesites reszletei';

  @override
  String get notificationsNotFound => 'Az ertesites nem talalhato.';

  @override
  String get notificationsPreferencesTitle => 'Ertesitesi beallitasok';

  @override
  String get notificationsSavePreferences => 'Beallitasok mentese';

  @override
  String get notificationsSaved => 'Beallitasok mentve.';

  @override
  String get notificationsPrefSystemHealth => 'Rendszerallapot';

  @override
  String get notificationsPrefSecurity => 'Biztonsag';

  @override
  String get notificationsPrefSupport => 'Tamogatas';

  @override
  String get notificationsPrefBilling => 'Szamlazas';

  @override
  String get notificationsPrefRelease => 'Kihelyezes';

  @override
  String get notificationsPrefInAppOnlyHint =>
      'Ebben a fazisban csak alkalmazason beluli ertesitesek erhetok el.';

  @override
  String get notificationsPrefValidationAtLeastOne =>
      'Legalabb egy csatorna maradjon engedelyezve.';

  @override
  String get notificationsPrefValidationInAppOnly =>
      'Ebben a fazisban csak alkalmazason beluli ertesites tamogatott.';

  @override
  String get notificationsInAppChip => 'Csak alkalmazason belul';

  @override
  String get notificationsYes => 'Igen';

  @override
  String get notificationsNo => 'Nem';

  @override
  String get notificationsPushProviderTitle => 'Push szolgaltato allapot';

  @override
  String get notificationsPushStateInAppOnly => 'Csak alkalmazason belul';

  @override
  String get notificationsPushStateExternalNotConfigured =>
      'Kulso push nincs beallitva';

  @override
  String get notificationsPushStateConfigured => 'Push szolgaltato beallitva';

  @override
  String get notificationsPushProviderField => 'Szolgaltato';

  @override
  String get notificationsPushDeliveryEnabled => 'Kezbesites engedelyezve';

  @override
  String get notificationsPushTokenStorage => 'Token tarolasi mod';

  @override
  String get notificationsPushLastFailureCode => 'Utolso hibakod';

  @override
  String get notificationsPushProviderNotice =>
      'A push szolgaltato allapota csak metaadatot mutat. FCM, APNS vagy hitelesito adatok nem jelennek meg.';

  @override
  String get notificationsPushProviderNone => 'Nincs (csak alkalmazason belul)';

  @override
  String get notificationsPushProviderFcm => 'FCM';

  @override
  String get notificationsPushProviderApns => 'APNS';

  @override
  String get settingsNotificationsSection => 'Ertesitesek';

  @override
  String get settingsNotificationsBody =>
      'Alkalmazason beluli ertesitesi beallitasok kezelese.';

  @override
  String get settingsOpenNotificationPreferences =>
      'Ertesitesi beallitasok megnyitasa';

  @override
  String get translationPanelTitle => 'Forditas';

  @override
  String get translationProviderDisabled =>
      'A fordito szolgaltato nincs beallitva';

  @override
  String get translationTargetLanguageLabel => 'Celnyelv';

  @override
  String get translationRecipientLanguageLabel => 'Cimzett nyelve';

  @override
  String get translationTranslateAction => 'Forditas';

  @override
  String get translationTranslating => 'Forditas…';

  @override
  String get translationActionError => 'A forditas sikertelen';

  @override
  String get translationOriginalTitle => 'Eredeti szoveg';

  @override
  String get translationTranslatedTitle => 'Leforditott szoveg';

  @override
  String translationLanguageLabel(String code) {
    return 'Nyelv: $code';
  }

  @override
  String get translationMetadataOnlyNotice =>
      'A leforditott szoveg metaadat-only nezetben rejtve';

  @override
  String get translationBadgeMachine => 'Gepi forditas';

  @override
  String get translationBadgeNeedsReview => 'Felulvizsgalat szukseges';

  @override
  String get translationBadgeStale => 'Elavult forditas';

  @override
  String get translationBadgeApproved => 'Jovahagyva';

  @override
  String get translationHumanConfirmationRequired =>
      'Emberi jovahagyas szukseges a leforditott szoveg kuldese elott';

  @override
  String get translationReplyPreviewTitle => 'Valasz forditas elonezet';

  @override
  String get translationReplyPreviewNotice =>
      'Csak elonezet. Az eredeti piszkozat megmarad, automatikus kuldes nincs.';

  @override
  String get translationGeneratePreviewAction => 'Elonezet generalasa';

  @override
  String get translationNoAutoSendNotice =>
      'A jovahagyas keszre jeloli a forditas. A kuldes kulon explicit lepes marad.';

  @override
  String get translationDismissAction => 'Megse';

  @override
  String get translationApproveForSendAction => 'Forditas jovahagyasa';

  @override
  String get translationApproving => 'Jovahagyas…';

  @override
  String get translationDraftReplyAction => 'Valasz forditas piszkozata';

  @override
  String get translationReplyApprovedNotice =>
      'A forditas jovahagyva. Masolja vagy kuldje a normal tamogatasi folyamaton keresztul.';

  @override
  String get customerCommunicationsTitle => 'Ugyfel kommunikacio';

  @override
  String get customerCommunicationDetailTitle => 'Kommunikacios szal';

  @override
  String get customerCommunicationEvidencePackageTitle => 'Bizonyitek csomag';

  @override
  String get customerCommunicationLoadError =>
      'Az ugyfel kommunikacio betoltese sikertelen.';

  @override
  String get customerCommunicationActionError =>
      'Az ugyfel kommunikacios muvelet sikertelen.';

  @override
  String get customerCommunicationMockDataBadge => 'Mintaadat';

  @override
  String get customerCommunicationOpenModule =>
      'Ugyfel kommunikacio megnyitasa';

  @override
  String get customerCommunicationPrivacyNotice =>
      'A listanezet metaadat-elso. Az uzenettorzs csak jogosult reszletes nezetben jelenik meg.';

  @override
  String get customerCommunicationDetailMetadataOnly =>
      'Az uzenettorzs rejtve a szerepkor vagy a szal scope miatt.';

  @override
  String get customerCommunicationSearchHint =>
      'Kereses nev, domain vagy ceg alapjan';

  @override
  String get customerCommunicationListEmpty =>
      'Nincs egyezo ugyfel kommunikacios szal.';

  @override
  String get customerCommunicationDisputedBadge => 'Vitatott';

  @override
  String get customerCommunicationBillingRelatedBadge => 'Szamlazasi';

  @override
  String customerCommunicationThreadSubtitle(String domain, String companyId) {
    return '$domain · ceg $companyId';
  }

  @override
  String customerCommunicationUpdatedAt(String date) {
    return 'Frissitve: $date';
  }

  @override
  String get customerCommunicationFilterAll => 'Osszes';

  @override
  String get customerCommunicationFilterOpen => 'Nyitott';

  @override
  String get customerCommunicationFilterDisputed => 'Vitatott';

  @override
  String get customerCommunicationFilterClosed => 'Lezart';

  @override
  String get customerCommunicationFilterBillingRelated => 'Szamlazasi';

  @override
  String get customerCommunicationStatusOpen => 'Nyitott';

  @override
  String get customerCommunicationStatusClosed => 'Lezart';

  @override
  String get customerCommunicationStatusArchived => 'Archivalt';

  @override
  String get customerCommunicationStatusDisputed => 'Vitatott';

  @override
  String get customerCommunicationStatusUnknown => 'Ismeretlen';

  @override
  String get customerCommunicationSourcePublicSite => 'Publikus oldal';

  @override
  String get customerCommunicationSourceEmail => 'E-mail';

  @override
  String get customerCommunicationSourceAdminApp => 'Admin app';

  @override
  String get customerCommunicationSourceAdminWeb => 'Admin web';

  @override
  String get customerCommunicationSourceImport => 'Import';

  @override
  String get customerCommunicationSourceSupport => 'Tamogatas';

  @override
  String get customerCommunicationSourceSystem => 'Rendszer';

  @override
  String get customerCommunicationSourceUnknown => 'Ismeretlen';

  @override
  String get customerCommunicationDirectionInbound => 'Bejovo';

  @override
  String get customerCommunicationDirectionOutbound => 'Kimeno';

  @override
  String get customerCommunicationDirectionInternalNote => 'Belso jegyzet';

  @override
  String get customerCommunicationDirectionSystemEvent => 'Rendszer esemeny';

  @override
  String get customerCommunicationDirectionUnknown => 'Ismeretlen';

  @override
  String get customerCommunicationSenderCustomer => 'Ugyfel';

  @override
  String get customerCommunicationSenderPlatformAdmin => 'Platform admin';

  @override
  String get customerCommunicationSenderCompanyAdmin => 'Ceg admin';

  @override
  String get customerCommunicationSenderSystem => 'Rendszer';

  @override
  String get customerCommunicationSenderUnknown => 'Ismeretlen';

  @override
  String get customerCommunicationHumanReviewedBadge => 'Emberi felulvizsgalat';

  @override
  String customerCommunicationOriginalLabel(String language) {
    return 'Eredeti ($language)';
  }

  @override
  String customerCommunicationTranslatedLabel(String language) {
    return 'Leforditott ($language)';
  }

  @override
  String get customerCommunicationMessageMetadataOnly =>
      'Uzenettorzs rejtve (metaadat-only nezet).';

  @override
  String get customerCommunicationMessagesEmpty =>
      'Meg nincs naplozott uzenet.';

  @override
  String get customerCommunicationTimelineTitle => 'Idovonal';

  @override
  String get customerCommunicationAgreementsTitle =>
      'Megallapodas pillanatkepek';

  @override
  String get customerCommunicationEvidencePackagesTitle =>
      'Bizonyitek csomagok';

  @override
  String get customerCommunicationPackagesEmpty =>
      'Meg nincs generalva bizonyitek csomag.';

  @override
  String customerCommunicationAgreementPrice(
    String amount,
    String currency,
    String cycle,
  ) {
    return '$amount $currency · $cycle';
  }

  @override
  String customerCommunicationAgreementModules(String modules) {
    return 'Modulok: $modules';
  }

  @override
  String customerCommunicationAgreementAcceptedAt(String date) {
    return 'Elfogadva: $date';
  }

  @override
  String get customerCommunicationPdfPendingNotice =>
      'PDF generalas fuggoben; strukturalt bizonyitek csomag keszult az audit rekordokbol.';

  @override
  String get customerCommunicationPdfReadyNotice =>
      'A PDF bizonyitek csomag keszen all megosztasra ezen az eszkozon.';

  @override
  String get customerCommunicationPdfFailedNotice =>
      'A PDF generalas sikertelen. A strukturalt summaryJson tovabbra is elerheto az audit rekordokbol.';

  @override
  String get customerCommunicationPdfSourceOfTruthNotice =>
      'ViaNexis audit rekordokbol generalva. Az adatbazis audit rekordok maradnak a forrasigazsag; ez a PDF csak bemutato export.';

  @override
  String get customerCommunicationDownloadPdfAction => 'PDF letoltese';

  @override
  String customerCommunicationDownloadPdfSuccess(String bytes) {
    return 'PDF letoltve ($bytes bajt). Kezelje az adatvedelmi es megorezési szabalyzat szerint.';
  }

  @override
  String get customerCommunicationDownloadPdfFailed =>
      'A bizonyitek PDF letoltese sikertelen.';

  @override
  String get customerCommunicationSharePdfAction => 'PDF megosztasa';

  @override
  String get customerCommunicationSharePdfSuccess =>
      'A PDF megosztható. Használja az eszköz megosztási menüjét a megnyitáshoz vagy mentéshez.';

  @override
  String get customerCommunicationSharePdfFailed =>
      'A bizonyitek PDF megosztasa sikertelen.';

  @override
  String get customerCommunicationSharePdfInvalid =>
      'A bizonyitek PDF ures vagy hibas. Generalja ujra a csomagot, vagy probalja meg ujra.';

  @override
  String get customerCommunicationSharePdfUnavailable =>
      'A megosztas nem erheto el ezen az eszkozon. Probalkozzon ujra vagy hasznaljon masik eszkozt.';

  @override
  String get customerCommunicationSharePdfNotReady =>
      'A PDF meg nem all keszen. Varjon a generalasra, vagy generalja ujra a csomagot.';

  @override
  String customerCommunicationGeneratedBy(String userId) {
    return 'Generalta felhasznalo ID: $userId';
  }

  @override
  String get customerCommunicationSendReplyTitle => 'Ugyfel valasz kuldese';

  @override
  String get customerCommunicationSendReplyAction => 'Valasz kuldese';

  @override
  String get customerCommunicationSendReplyMessageLabel => 'Valasz uzenet';

  @override
  String get customerCommunicationSendReplySubjectLabel =>
      'Email targy (opcionalis)';

  @override
  String get customerCommunicationUseTranslatedTextLabel =>
      'Jovahagyott forditas hasznalata';

  @override
  String get customerCommunicationHumanConfirmationLabel =>
      'Megerositem, hogy a valasz kuldheto';

  @override
  String get customerCommunicationHumanConfirmedBadge => 'Emberi megerosites';

  @override
  String get customerCommunicationTranslationApprovedBadge =>
      'Forditas jovahagyva';

  @override
  String get customerCommunicationTranslatedReplyWarning =>
      'A leforditott valaszok nem kerulnek automatikusan kikuldesre. Ellenorizd es erositsd meg kuldes elott.';

  @override
  String get customerCommunicationDeliveryProviderDisabledNotice =>
      'A kuldesi szolgaltato le van tiltva; a valasz naplozva lesz, de nem megy ki kulso csatornara.';

  @override
  String get customerCommunicationReplyLoggedSkippedNotice =>
      'Valasz naplozva, kuldes kihagyva (szolgaltato tiltva).';

  @override
  String get customerCommunicationReplySentSuccess =>
      'Valasz sikeresen elkuldve.';

  @override
  String get customerCommunicationEvidenceDeliveryNotice =>
      'A bizonyitek csomagok tartalmazzak a kimenő kuldesi allapotot, ha elerheto.';

  @override
  String get customerCommunicationDeliveryStatusDraft => 'Piszkozat';

  @override
  String get customerCommunicationDeliveryStatusQueued => 'Sorban';

  @override
  String get customerCommunicationDeliveryStatusSkipped => 'Kihagyva';

  @override
  String get customerCommunicationDeliveryStatusSent => 'Elkuldve';

  @override
  String get customerCommunicationDeliveryStatusFailed => 'Sikertelen';

  @override
  String get customerCommunicationDeliveryStatusCancelled => 'Megszakitva';

  @override
  String get customerCommunicationDeliveryStatusUnknown => 'Ismeretlen allapot';

  @override
  String get customerCommunicationDeliveryChannelEmail => 'Email';

  @override
  String get customerCommunicationDeliveryChannelPortal => 'Portal';

  @override
  String get customerCommunicationDeliveryChannelManual => 'Manualis';

  @override
  String get customerCommunicationDeliveryChannelNone => 'Nincs';

  @override
  String get customerCommunicationDeliveryChannelUnknown =>
      'Ismeretlen csatorna';

  @override
  String get customerCommunicationDeliveryHistoryTitle =>
      'Kezbesitesi elozmenyek';

  @override
  String get customerCommunicationDeliveryHistoryEmpty =>
      'Meg nincs kezbesitesi kiserlet.';

  @override
  String get customerCommunicationDeliveryFilterAll => 'Osszes';

  @override
  String get customerCommunicationDeliveryFilterSkipped => 'Kihagyva';

  @override
  String get customerCommunicationDeliveryFilterFailed => 'Sikertelen';

  @override
  String get customerCommunicationDeliveryFilterSent => 'Elkuldve';

  @override
  String get customerCommunicationDeliveryFilterQueued => 'Varolistan';

  @override
  String get customerCommunicationResendTitle => 'Kezbesites ujrakuldese';

  @override
  String get customerCommunicationResendAction => 'Ujrakuldes';

  @override
  String get customerCommunicationResendAuditNotice =>
      'Az ujrakuldes uj, auditalt kezbesitesi kiserletet hoz letre.';

  @override
  String get customerCommunicationResendTranslationNotice =>
      'A leforditott valaszok csak jovahagyott forditas utan kuldethetok.';

  @override
  String get customerCommunicationResendSuccess =>
      'Ujrakuldes sikeresen naplozva.';

  @override
  String get customerCommunicationDeliveryMultipleAttempts =>
      'Tobb kezbesitesi kiserlet — lasd a kezbesitesi elozmenyeket.';

  @override
  String get customerCommunicationDeliveryResendAttempt =>
      'Ez a kiserlet egy korabbi kezbesites ujrakuldese.';

  @override
  String get customerCommunicationDeliveryTemplateLabel => 'E-mail sablon';

  @override
  String get customerCommunicationEvidenceRegenerationNotice =>
      'Az evidence csomagot erdemes ujrageneralni uj kezbesitesi kiserletek utan.';

  @override
  String get customerCommunicationHumanConfirmRequired =>
      'Emberi megerosites szukseges.';

  @override
  String get customerCommunicationDeliveryEventQueued => 'Varolistan';

  @override
  String get customerCommunicationDeliveryEventSent => 'Elkuldve';

  @override
  String get customerCommunicationDeliveryEventDelivered => 'Kezbesitve';

  @override
  String get customerCommunicationDeliveryEventBounced => 'Visszapattant';

  @override
  String get customerCommunicationDeliveryEventComplained => 'Panasz';

  @override
  String get customerCommunicationDeliveryEventOpened => 'Megnyitva';

  @override
  String get customerCommunicationDeliveryEventClicked => 'Kattintva';

  @override
  String get customerCommunicationDeliveryEventFailed => 'Sikertelen';

  @override
  String get customerCommunicationDeliveryEventProviderStatus =>
      'Szolgaltato statusz';

  @override
  String get customerCommunicationDeliveryEventUnknown => 'Ismeretlen esemeny';

  @override
  String customerCommunicationPackageGeneratedAt(String date) {
    return 'Generalva: $date';
  }

  @override
  String get customerCommunicationPackageTypeCommunicationEvidence =>
      'Kommunikacios bizonyitek';

  @override
  String get customerCommunicationPackageTypeSubscriptionDispute =>
      'Elofizetes vitat';

  @override
  String get customerCommunicationPackageTypeRegistrationEvidence =>
      'Regisztracios bizonyitek';

  @override
  String get customerCommunicationPackageTypePricingEvidence =>
      'Arazasi bizonyitek';

  @override
  String get customerCommunicationPackageTypeUnknown =>
      'Ismeretlen csomagtipus';

  @override
  String get customerCommunicationPackageStatusGenerated => 'Generalva';

  @override
  String get customerCommunicationPackageStatusFailed => 'Sikertelen';

  @override
  String get customerCommunicationPackageStatusUnknown => 'Ismeretlen allapot';

  @override
  String get customerCommunicationGeneratePackageTitle =>
      'Bizonyitek csomag generalasa';

  @override
  String get customerCommunicationGeneratePackageAction => 'Csomag generalasa';

  @override
  String get customerCommunicationMarkDisputedTitle =>
      'Szal vitatottkent jelolese';

  @override
  String get customerCommunicationMarkDisputedAction => 'Vitatott jeloles';

  @override
  String get customerCommunicationDisputedSectionTitle => 'Vita';

  @override
  String get customerCommunicationReasonLabel => 'Indoklas (kotelezo)';

  @override
  String get customerCommunicationReasonRequired =>
      'Legalabb 5 karakter szukseges.';

  @override
  String get customerCommunicationPackageTypeLabel => 'Csomag tipus';

  @override
  String get customerCommunicationExportAuditWarning =>
      'Az export audit altal naplozott bizonyitek csomagot keszit az adatbazis rekordokbol. Adjon meg indoklast.';

  @override
  String get customerCommunicationCancel => 'Megse';

  @override
  String get customerCommunicationDisputeMarkedSuccess =>
      'A szal vitatottkent jelolve.';

  @override
  String get customerCommunicationPackageGeneratedSuccess =>
      'Bizonyitek csomag generalva.';

  @override
  String get customerCommunicationSummaryJsonTitle =>
      'Strukturalt osszefoglalo (hiteles audit export)';

  @override
  String customerCommunicationPackageReason(String reason) {
    return 'Indoklas: $reason';
  }

  @override
  String customerCommunicationFileHash(String hash) {
    return 'Integritas hash: $hash';
  }

  @override
  String get customerCommunicationPackageNotFound =>
      'A bizonyitek csomag nem talalhato.';

  @override
  String get customerCommunicationSummaryTitle => 'Ugyfel kommunikacio';

  @override
  String customerCommunicationSummaryDisputed(String count) {
    return 'Vitatott: $count';
  }

  @override
  String customerCommunicationSummaryOpen(String count) {
    return 'Nyitott: $count';
  }

  @override
  String customerCommunicationSummaryTotal(String count) {
    return 'Osszesen: $count';
  }

  @override
  String get publicIntakesTitle => 'Publikus megkeresések';

  @override
  String get publicIntakeDashboardSubtitle =>
      'Webes érdeklődések és árajánlat-kérések. Elérhető a Továbbiak menüben is.';

  @override
  String get publicIntakeDashboardOpenAction =>
      'Publikus megkeresések megnyitása';

  @override
  String get publicIntakeModuleDescription =>
      'Webes érdeklődések, demo és árajánlat-kérések';

  @override
  String get publicIntakeNoLinkedThreadTitle =>
      'Még nincs ügyfélkommunikációs szál';

  @override
  String get publicIntakeNoLinkedThreadBody =>
      'Ez a megkeresés nincs ügyfélkommunikációs szálhoz kapcsolva. Itt tekintheti át a részleteket; a szál a háttér folyamat kapcsolásakor jelenhet meg.';

  @override
  String get publicIntakeNoLinksTitle => 'Nincs kapcsolt rekord';

  @override
  String get publicIntakeNoLinksBody =>
      'Ehhez a beküldéshez még nincs kommunikációs szál, árajánlat- vagy díjazási kérelem kapcsolva.';

  @override
  String get publicIntakeDetailTitle => 'Publikus megkeresés';

  @override
  String get publicIntakeSearchHint => 'Keresés cég, domain, ország…';

  @override
  String get publicIntakeListEmpty => 'Nincs a szűrőnek megfelelő megkeresés.';

  @override
  String get publicIntakeListError =>
      'Nem sikerült betölteni a megkereséseket.';

  @override
  String get publicIntakeDetailError =>
      'Nem sikerült betölteni a megkeresés részleteit.';

  @override
  String get publicIntakeMockDataBadge => 'Tesztadat';

  @override
  String get publicIntakeUnknownCustomer => 'Ismeretlen kapcsolat';

  @override
  String publicIntakeCreatedAt(String date) {
    return 'Beküldve: $date';
  }

  @override
  String get publicIntakeFilterAll => 'Mind';

  @override
  String get publicIntakeFilterNew => 'Új';

  @override
  String get publicIntakeFilterReviewing => 'Vizsgálat alatt';

  @override
  String get publicIntakeFilterQuoteDemo => 'Ajánlat / demo';

  @override
  String get publicIntakeFilterContacted => 'Kapcsolatfelvétel / ajánlat';

  @override
  String get publicIntakeFilterClosed => 'Lezárva';

  @override
  String get publicIntakeTypeContact => 'Kapcsolat';

  @override
  String get publicIntakeTypeDemoRequest => 'Demo kérés';

  @override
  String get publicIntakeTypeQuoteRequest => 'Ajánlatkérés';

  @override
  String get publicIntakeTypeRegistrationInterest => 'Regisztrációs érdeklődés';

  @override
  String get publicIntakeTypeSupportRequest => 'Támogatás';

  @override
  String get publicIntakeTypeUnknown => 'Ismeretlen típus';

  @override
  String get publicIntakeStatusNew => 'Új';

  @override
  String get publicIntakeStatusReviewing => 'Vizsgálat alatt';

  @override
  String get publicIntakeStatusContacted => 'Kapcsolatfelvétel';

  @override
  String get publicIntakeStatusQuoted => 'Ajánlatadva';

  @override
  String get publicIntakeStatusConverted => 'Konvertált';

  @override
  String get publicIntakeStatusRejected => 'Elutasítva';

  @override
  String get publicIntakeStatusClosed => 'Lezárva';

  @override
  String get publicIntakeStatusUnknown => 'Ismeretlen státusz';

  @override
  String get publicIntakeSectionCustomer => 'Ügyfél';

  @override
  String get publicIntakeSectionConsent => 'Hozzájárulás';

  @override
  String get publicIntakeSectionMessage => 'Eredeti üzenet';

  @override
  String get publicIntakeSectionQuote => 'Ajánlat részletei';

  @override
  String get publicIntakeSectionLinks => 'Kapcsolódó rekordok';

  @override
  String get publicIntakeFieldCustomerName => 'Kapcsolattartó neve';

  @override
  String get publicIntakeFieldEmailDomain => 'E-mail domain';

  @override
  String get publicIntakeFieldCompany => 'Cég';

  @override
  String get publicIntakeFieldCountry => 'Ország';

  @override
  String publicIntakeFieldOriginalLanguage(String lang) {
    return 'Eredeti nyelv: $lang';
  }

  @override
  String publicIntakeFieldFleetSize(String count) {
    return 'Flotta méret: $count';
  }

  @override
  String publicIntakeFieldOfficeUsers(String count) {
    return 'Irodai felhasználók: $count';
  }

  @override
  String publicIntakeFieldDriverApps(String count) {
    return 'Sofőr appok: $count';
  }

  @override
  String get publicIntakeFieldModules => 'Kért modulok';

  @override
  String get publicIntakeFieldAiFeatures => 'Kért AI funkciók';

  @override
  String get publicIntakeFieldStatus => 'Státusz';

  @override
  String get publicIntakeFieldConsentVersion => 'Hozzájárulás verzió';

  @override
  String get publicIntakeConsentPrivacy => 'Adatvédelmi hozzájárulás';

  @override
  String get publicIntakeConsentTerms => 'Felhasználási feltételek';

  @override
  String get publicIntakeConsentMarketing => 'Marketing hozzájárulás';

  @override
  String get publicIntakeConsentYes => 'Igen';

  @override
  String get publicIntakeConsentNo => 'Nem';

  @override
  String get publicIntakeOpenThreadAction =>
      'Ügyfél-kommunikációs szál megnyitása';

  @override
  String get publicIntakeLinkedQuote => 'Kapcsolt ajánlatkérés';

  @override
  String get publicIntakeLinkedPricing => 'Kapcsolt árazási megkeresés';

  @override
  String get publicIntakeChangeStatusAction => 'Státusz módosítása';

  @override
  String get publicIntakeStatusDialogTitle =>
      'Megkeresés státuszának módosítása';

  @override
  String get publicIntakeReasonLabel => 'Indoklás';

  @override
  String get publicIntakeReasonRequired =>
      'Elutasításnál vagy lezárásnál kötelező az indoklás.';

  @override
  String get publicIntakeReasonMinLength => 'Legalább 5 karakter szükséges.';

  @override
  String get publicIntakeCancel => 'Mégse';

  @override
  String get publicIntakeStatusConfirm => 'Státusz mentése';

  @override
  String get publicIntakeStatusSuccess => 'Státusz frissítve.';

  @override
  String get publicIntakeStatusError => 'Nem sikerült frissíteni a státuszt.';

  @override
  String get publicIntakeEvidenceNotice =>
      'Ez a publikus megkeresés az első kapcsolatfelvételtől naplózva van, és szerepelhet bizonyítékcsomagokban.';

  @override
  String publicIntakeDashboardNew(String count) {
    return 'Új publikus megkeresések: $count';
  }

  @override
  String publicIntakeDashboardHighPriority(String count) {
    return 'Ajánlat/demo kérések: $count';
  }

  @override
  String get actionCenterFilterPublicIntake => 'Publikus megkeresések';

  @override
  String get actionCenterTypePublicIntake => 'Publikus megkeresés';

  @override
  String get navMore => 'Továbbiak';

  @override
  String get modulesHubTitle => 'Modulok';

  @override
  String get modulesHubBody => 'További admin modulok és beállítások.';

  @override
  String get navReturnToDashboard => 'Vissza az irányítópultra';

  @override
  String get settingsLanguageSection => 'Nyelv';

  @override
  String get settingsLanguageBody =>
      'Válaszd ki az admin app megjelenítési nyelvét.';

  @override
  String get settingsLanguageHu => 'Magyar';

  @override
  String get settingsLanguageEn => 'Angol';

  @override
  String get devicePinSectionTitle => 'Eszköz PIN';

  @override
  String get devicePinSectionBody =>
      'Opcionális helyi PIN ehhez az eszközhöz. Nem helyettesíti a backend bejelentkezést.';

  @override
  String get devicePinSetAction => 'PIN beállítása';

  @override
  String get devicePinChangeAction => 'PIN módosítása';

  @override
  String get devicePinRemoveAction => 'PIN eltávolítása';

  @override
  String get devicePinCurrentLabel => 'Jelenlegi PIN';

  @override
  String get devicePinNewLabel => 'Új PIN';

  @override
  String get devicePinConfirmLabel => 'PIN megerősítése';

  @override
  String get devicePinSetSuccess => 'Az eszköz PIN mentve.';

  @override
  String get devicePinChangeSuccess => 'Az eszköz PIN frissítve.';

  @override
  String get devicePinRemoveSuccess => 'Az eszköz PIN eltávolítva.';

  @override
  String get devicePinMismatch => 'A két PIN nem egyezik.';

  @override
  String get devicePinInvalidLength => 'A PIN 4–8 számjegy legyen.';

  @override
  String get devicePinInvalidCurrent => 'A jelenlegi PIN helytelen.';

  @override
  String get devicePinNonNumeric => 'A PIN csak számjegyeket tartalmazhat.';
}
