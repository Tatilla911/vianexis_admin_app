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
  String get navSystemMonitoring => 'Rendszerfelügyelet';

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
  String get applicationsTitle => 'Jelentkezések';

  @override
  String applicationDetailTitle(String id) {
    return 'Jelentkezés #$id';
  }

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
  String get authSessionRevoked =>
      'A munkamenet visszavonásra került. Jelentkezzen be újra.';

  @override
  String get authUnableToRestoreSession =>
      'Nem sikerült helyreállítani a munkamenetet. Jelentkezzen be újra.';

  @override
  String get authOfflineSessionRestorePending =>
      'A munkamenet helyreállítása offline állapot miatt függőben van.';

  @override
  String get authRememberDevice => 'Emlékezzen rám ezen az eszközön';

  @override
  String get authActiveSessions => 'Aktív eszközök';

  @override
  String get authCurrentDevice => 'Ez az eszköz';

  @override
  String get authUnknownDevice => 'Ismeretlen eszköz';

  @override
  String get authLegacySession => 'Korábbi bejelentkezés';

  @override
  String get authLastActive => 'Utolsó használat';

  @override
  String get authSessionExpires => 'Lejárat';

  @override
  String get authRemoveSession => 'Munkamenet megszüntetése';

  @override
  String get authLogoutAllOtherDevices => 'Kijelentkezés minden más eszközről';

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
  String get registrationApproveSuccess =>
      'Cég jóváhagyva. Meghívó létrehozva.';

  @override
  String get registrationApproveOutcomeTitle => 'Jóváhagyás eredménye';

  @override
  String get registrationFieldApplicationReference => 'Jelentkezési azonosító';

  @override
  String get registrationFieldCompanyId => 'Cég ID';

  @override
  String get registrationFieldAdminEmail => 'Cégadmin e-mail';

  @override
  String get registrationFieldInviteStatus => 'Meghívó kézbesítés';

  @override
  String get registrationFieldInviteExpiresAt => 'Meghívó lejárat';

  @override
  String get registrationFieldInviteTokenId => 'Meghívó token ID';

  @override
  String get registrationInviteDeliverySent => 'Elküldve';

  @override
  String get registrationInviteDeliveryPending =>
      'Meghívó létrehozva; kézbesítés függőben vagy sikertelen (SMTP)';

  @override
  String get registrationInviteDeliveryAccepted => 'Elfogadva';

  @override
  String get registrationInviteDeliveryExpired => 'Lejárt';

  @override
  String get registrationInviteDeliveryRevoked => 'Visszavonva';

  @override
  String get registrationInviteResend => 'Meghívó újraküldése';

  @override
  String get registrationInviteRevoke => 'Meghívó visszavonása';

  @override
  String get registrationInviteResendSuccess =>
      'Meghívó újraküldve (új token).';

  @override
  String get registrationInviteRevokeSuccess =>
      'A függő meghívó tokenek visszavonva.';

  @override
  String get registrationPasswordSetupSend =>
      'Biztonságos jelszóbeállító link küldése';

  @override
  String get registrationPasswordSetupSent =>
      'Jelszóbeállító / visszaállító e-mail elküldve.';

  @override
  String get registrationPasswordSetupQueued =>
      'Jelszóbeállító link létrehozva; e-mail kézbesítés függőben vagy sikertelen (SMTP).';

  @override
  String get registrationInviteManageHint =>
      'A jelentkezés jóváhagyva. Meghívó újraküldése vagy jelszóbeállító link küldése (soha nem plaintext jelszó).';

  @override
  String get registrationOpenCompany => 'Cég megnyitása';

  @override
  String get registrationPermissionPolicyTitle => 'Jóváhagyási jogosultság';

  @override
  String get registrationPermissionSuperAdminOnly =>
      'A céges jóváhagyás/elutasítás csak super_admin. A reviewer csak a sort láthatja.';

  @override
  String get applicationsCompatBanner =>
      'Céges onboarding postafiók: Regisztrációk. Ez a Jelentkezések nézet kompatibilitási felület a vegyes public intake-ekhez.';

  @override
  String get applicationsOpenRegistrations => 'Regisztrációk megnyitása';

  @override
  String get applicationsCompanyUseRegistrations =>
      'A céges jelentkezéseket a Regisztrációk (elsődleges postafiók) felületen kell elbírálni.';

  @override
  String get applicationsFilterCompany => 'Cég';

  @override
  String get applicationsFilterDriver => 'Sofőr';

  @override
  String get applicationsFilterPartner => 'Partner';

  @override
  String get applicationsFilterNew => 'Új';

  @override
  String get applicationsEmpty => 'Nincs jelentkezés';

  @override
  String applicationsLoadError(String error) {
    return 'Hiba: $error';
  }

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
  String get platformCompanySectionBasics => 'Alapadatok';

  @override
  String get platformCompanySectionContacts => 'Kapcsolattartók';

  @override
  String get platformCompanySectionAssessment => 'Igényfelmérés';

  @override
  String get platformCompanySectionPricing => 'Árazás és ajánlat';

  @override
  String get platformCompanySectionSubscription => 'Előfizetés';

  @override
  String get platformCompanySectionDocuments => 'Dokumentumok';

  @override
  String get platformCompanySectionAudit => 'Audit';

  @override
  String get platformCompanyAssessmentEmpty =>
      'Még nincs kapcsolt céges igényfelmérés.';

  @override
  String get platformCompanyPricingEmpty => 'Még nincs árazási javaslat.';

  @override
  String get platformCompanyPricingNotFinal =>
      'Csak automatikus javaslat — nem végleges ár.';

  @override
  String get platformCompanyPricingHasOverride => 'Admin felülbírálás mentve.';

  @override
  String platformCompanyAssessmentStatus(String status) {
    return 'Státusz: $status';
  }

  @override
  String platformCompanyAssessmentVersion(String version) {
    return 'Verzió: $version';
  }

  @override
  String platformCompanyAssessmentLastSaved(String value) {
    return 'Utolsó mentés: $value';
  }

  @override
  String platformCompanyAssessmentSubmittedAt(String value) {
    return 'Beküldve: $value';
  }

  @override
  String platformCompanyAssessmentDrivers(String count) {
    return 'Sofőrök: $count';
  }

  @override
  String platformCompanyAssessmentMonthlyTrips(String count) {
    return 'Havi fuvarok: $count';
  }

  @override
  String platformCompanyAssessmentModules(String value) {
    return 'Modulok: $value';
  }

  @override
  String platformCompanyPricingSuggestedPackage(String value) {
    return 'Ajánlott csomag: $value';
  }

  @override
  String platformCompanyPricingMonthlyNet(String value) {
    return 'Javasolt havi nettó: $value';
  }

  @override
  String platformCompanyPricingOneTimeNet(String value) {
    return 'Javasolt egyszeri nettó: $value';
  }

  @override
  String platformCompanyMetricContacts(String count) {
    return 'Kapcsolattartó kártyák: $count';
  }

  @override
  String platformCompanyMetricDepartments(String count) {
    return 'Részlegek: $count';
  }

  @override
  String platformCompanyMetricDocuments(String count) {
    return 'Dokumentumok: $count';
  }

  @override
  String platformCompanyMetricPackages(String count) {
    return 'Dokumentumcsomagok: $count';
  }

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
  String get platformCompanySectionOverview => 'Áttekintés';

  @override
  String get platformCompanyOverviewHint =>
      'A cég jelenlegi azonosítója és működési státusza.';

  @override
  String get platformCompanySectionRegistration =>
      'Regisztráció és eredeti beadás';

  @override
  String get platformCompanyOriginalSubmitted => 'Eredetileg beadott adat';

  @override
  String get platformCompanyCurrentValid => 'Jelenleg érvényes adat';

  @override
  String get platformCompanyOriginalCurrentDiff =>
      'Eltérés az eredeti és a jelenlegi adat között';

  @override
  String get platformCompanyRegistrationLoadError =>
      'A regisztrációs pillanatkép nem tölthető be.';

  @override
  String get platformCompanyRegistrationSubmittedAt => 'Beadás időpontja';

  @override
  String get platformCompanyRegistrationSubmitter => 'Beadó személy';

  @override
  String get platformCompanySectionAmendments => 'Módosítások';

  @override
  String get platformCompanyAmendAction => 'Adatok módosítása';

  @override
  String get platformCompanyAmendFieldLabel => 'Módosítandó mező';

  @override
  String get platformCompanyAmendFieldRequired => 'Válasszon mezőt.';

  @override
  String get platformCompanyAmendCurrentValue => 'Jelenlegi érték';

  @override
  String get platformCompanyAmendNewValue => 'Új érték';

  @override
  String get platformCompanyAmendOldValue => 'Régi érték';

  @override
  String get platformCompanyAmendReason => 'Módosítás indoka';

  @override
  String get platformCompanyAmendReasonRequired =>
      'Az indok megadása kötelező.';

  @override
  String get platformCompanyAmendAuthSource =>
      'Kinek a kérésére / engedélyével';

  @override
  String get platformCompanyAmendAuthorizedBy => 'Engedélyezte';

  @override
  String get platformCompanyAmendAuthMethod => 'Engedélyezés módja';

  @override
  String get platformCompanyAmendAuthReference =>
      'Kapcsolódó hivatkozás (opcionális)';

  @override
  String get platformCompanyAmendAuthRequired =>
      'Az engedélyezési mezők kötelezőek.';

  @override
  String get platformCompanyAmendAuthCustomerEmail =>
      'Ügyfél e-mailes jóváhagyása';

  @override
  String get platformCompanyAmendAuthCustomerPhone =>
      'Ügyfél telefonos jóváhagyása';

  @override
  String get platformCompanyAmendAuthCustomerDocument =>
      'Ügyfél által küldött dokumentum';

  @override
  String get platformCompanyAmendAuthInternalApproval => 'Belső jóváhagyás';

  @override
  String get platformCompanyAmendAuthContract => 'Szerződés vagy megállapodás';

  @override
  String get platformCompanyAmendAuthOfficialRegistry =>
      'Hivatalos nyilvántartás alapján';

  @override
  String get platformCompanyAmendAuthOther => 'Egyéb';

  @override
  String get platformCompanyAmendAuthCustomerCall => 'Ügyfél telefonhívás';

  @override
  String get platformCompanyAmendAuthCustomerTicket => 'Ügyfél support jegy';

  @override
  String get platformCompanyAmendAuthInternalPolicy => 'Belső szabályzat';

  @override
  String get platformCompanyAmendAuthLegalDocument => 'Jogi dokumentum';

  @override
  String get platformCompanyAmendInternalComment => 'Belső megjegyzés';

  @override
  String get platformCompanyAmendCustomerComment =>
      'Ügyfél számára látható megjegyzés (opcionális)';

  @override
  String get platformCompanyAmendSensitiveNotice =>
      'Érzékeny mező: alkalmazás előtt jóváhagyás szükséges.';

  @override
  String get platformCompanyAmendSubmit => 'Módosítás mentése';

  @override
  String get platformCompanyAmendSubmitSuccess =>
      'A módosítási kérelem mentve.';

  @override
  String get platformCompanyAmendSubmitError =>
      'A módosítási kérelem mentése sikertelen.';

  @override
  String get platformCompanyAmendLoadError =>
      'A módosítások betöltése sikertelen.';

  @override
  String get platformCompanyAmendHistoryEmpty =>
      'Még nincs módosítási előzmény.';

  @override
  String get platformCompanyAmendStatus => 'Státusz';

  @override
  String get platformCompanyAmendStatusDraft => 'Piszkozat';

  @override
  String get platformCompanyAmendStatusPending => 'Jóváhagyásra vár';

  @override
  String get platformCompanyAmendStatusApproved => 'Jóváhagyott';

  @override
  String get platformCompanyAmendStatusRejected => 'Elutasított';

  @override
  String get platformCompanyAmendStatusApplied => 'Alkalmazott';

  @override
  String get platformCompanyAmendStatusReverted => 'Visszavont';

  @override
  String get platformCompanyAmendStatusCancelled => 'Visszavonva';

  @override
  String get platformCompanyAmendStatusConflict => 'Ütközés';

  @override
  String get platformCompanyAmendConflict =>
      'Ütközés történt: az adat időközben megváltozott.';

  @override
  String get platformCompanyAmendApprove => 'Jóváhagyás';

  @override
  String get platformCompanyAmendReject => 'Elutasítás';

  @override
  String get platformCompanyAmendApply => 'Alkalmazás';

  @override
  String get platformCompanyAmendFieldLegalName => 'Hivatalos cégnév';

  @override
  String get platformCompanyAmendFieldTradeName => 'Kereskedelmi név';

  @override
  String get platformCompanyAmendFieldVat => 'Adószám / VAT';

  @override
  String get platformCompanyAmendFieldRegistrationNumber => 'Cégjegyzékszám';

  @override
  String get platformCompanyAmendFieldCountry => 'Ország';

  @override
  String get platformCompanyAmendFieldRegisteredAddress => 'Székhely';

  @override
  String get platformCompanyAmendFieldBillingAddress => 'Számlázási cím';

  @override
  String get platformCompanyAmendFieldWebsite => 'Weboldal';

  @override
  String get platformCompanyAmendFieldPrimaryEmail => 'Fő e-mail';

  @override
  String get platformCompanyAmendFieldPhone => 'Telefonszám';

  @override
  String get platformCompanyAmendFieldPreferredLanguage =>
      'Kapcsolattartási nyelv';

  @override
  String get platformCompanyAmendFieldBillingContactEmail =>
      'Számlázási kapcsolattartó e-mail';

  @override
  String get platformCompanyAmendFieldStatus => 'Cég státusz';

  @override
  String get platformCompanyAmendFieldPrimaryContact =>
      'Elsődleges kapcsolattartó';

  @override
  String get platformCompanyAmendFieldBillingContact =>
      'Számlázási kapcsolattartó';

  @override
  String get platformCompanyAmendNewValueJsonHint => 'Érvényes JSON megadása';

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
  String get adminUserInviteEmailPending =>
      'Admin meghívva, de az e-mail küldése nem igazolt.';

  @override
  String get adminUserInviteEmailFailed =>
      'Admin meghívva, de a meghívó e-mail sikertelen.';

  @override
  String get adminUserInviteEmailSkipped =>
      'Admin meghívva, de az e-mail küldés ki van kapcsolva.';

  @override
  String get adminUserInviteConsoleOnly =>
      'Admin meghívva; az e-mail csak konzolra került (nem kézbesítve).';

  @override
  String get adminUserInviteProviderMissing =>
      'Admin meghívva, de nincs beállított e-mail provider.';

  @override
  String get adminUserInviteAllowlistBlocked =>
      'Admin meghívva, de a staging allowlist blokkolta a címzettet.';

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
  String get actionCenterFilterCustomerCommunication => 'Ügyfélkommunikáció';

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
  String get actionCenterTypeCustomerCommunication => 'Ügyfélkommunikáció';

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
      'Staging allowlist engedélyezve';

  @override
  String get releaseEmailDeliveryAllowlistDomains =>
      'Engedélyezett domainek (szám)';

  @override
  String get releaseEmailDeliveryAllowlistRecipients =>
      'Engedélyezett címzettek (szám)';

  @override
  String get releaseEmailDeliveryLastFailureCode => 'Utolsó hibakód';

  @override
  String get releaseEmailDeliveryStagingAllowlistMissing =>
      'Staging kézbesítés engedélyezve, de hiányzik az allowlist — külső küldés blokkolva.';

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
  String get navNotifications => 'Értesítések';

  @override
  String get notificationsTitle => 'Értesítések';

  @override
  String get notificationsPreferences => 'Beállítások';

  @override
  String get notificationsMarkAllRead => 'Összes olvasottra';

  @override
  String get notificationsEmpty => 'Nincsenek értesítések.';

  @override
  String get notificationsInAppOnlyTitle =>
      'Csak alkalmazáson belüli értesítések';

  @override
  String get notificationsInAppOnlyBody =>
      'A push csatornák ebben a fázisban nem aktívak.';

  @override
  String get notificationsDetailTitle => 'Értesítés részletei';

  @override
  String get notificationsNotFound => 'Az értesítés nem található.';

  @override
  String notificationsLoadError(String error) {
    return 'Hiba: $error';
  }

  @override
  String notificationsTypeLabel(String value) {
    return 'Típus: $value';
  }

  @override
  String notificationsSeverityLabel(String value) {
    return 'Súlyosság: $value';
  }

  @override
  String notificationsInAppOnlyLabel(String value) {
    return 'Csak alkalmazáson belül: $value';
  }

  @override
  String get notificationsPreferencesTitle => 'Értesítési beállítások';

  @override
  String get notificationsSavePreferences => 'Beállítások mentése';

  @override
  String get notificationsSaved => 'Beállítások mentve.';

  @override
  String get notificationsPrefSystemHealth => 'Rendszerállapot';

  @override
  String get notificationsPrefSecurity => 'Biztonsag';

  @override
  String get notificationsPrefSupport => 'Tamogatas';

  @override
  String get notificationsPrefBilling => 'Számlázás';

  @override
  String get notificationsPrefRelease => 'Kihelyezes';

  @override
  String get notificationsPrefInAppOnlyHint =>
      'Ebben a fázisban csak alkalmazáson belüli értesítések érhetők el.';

  @override
  String get notificationsPrefValidationAtLeastOne =>
      'Legalább egy csatorna maradjon engedélyezve.';

  @override
  String get notificationsPrefValidationInAppOnly =>
      'Ebben a fázisban csak alkalmazáson belüli értesítés támogatott.';

  @override
  String get notificationsInAppChip => 'Csak alkalmazáson belül';

  @override
  String get notificationsYes => 'Igen';

  @override
  String get notificationsNo => 'Nem';

  @override
  String get notificationsPushProviderTitle => 'Push szolgáltató állapot';

  @override
  String get notificationsPushStateInAppOnly => 'Csak alkalmazáson belül';

  @override
  String get notificationsPushStateExternalNotConfigured =>
      'Külső push nincs beállítva';

  @override
  String get notificationsPushStateConfigured => 'Push szolgáltató beállítva';

  @override
  String get notificationsPushProviderField => 'Szolgáltató';

  @override
  String get notificationsPushDeliveryEnabled => 'Kézbesítés engedélyezve';

  @override
  String get notificationsPushTokenStorage => 'Token tarolasi mod';

  @override
  String get notificationsPushLastFailureCode => 'Utolsó hibakód';

  @override
  String get notificationsPushProviderNotice =>
      'A push szolgáltató állapota csak metaadatot mutat. FCM, APNS vagy hitelesito adatok nem jelennek meg.';

  @override
  String get notificationsPushProviderNone => 'Nincs (csak alkalmazáson belül)';

  @override
  String get notificationsPushProviderFcm => 'FCM';

  @override
  String get notificationsPushProviderApns => 'APNS';

  @override
  String get settingsNotificationsSection => 'Értesítések';

  @override
  String get settingsNotificationsBody =>
      'Alkalmazáson belüli értesítési beállítások kezelése.';

  @override
  String get settingsOpenNotificationPreferences =>
      'Értesítési beállítások megnyitása';

  @override
  String get settingsOpenSoundSettings => 'Hangok és értesítések';

  @override
  String get settingsSoundTitle => 'Hangok és értesítések';

  @override
  String get settingsSoundDescription =>
      'Válasszon hangokat admin riasztásokhoz, üzenetekhez és visszajelzésekhez.';

  @override
  String get settingsSoundAlarm => 'Kritikus platform riasztás';

  @override
  String get settingsSoundMessage => 'Normal üzenet';

  @override
  String get settingsSoundRing => 'Bejövő support/hivas jel';

  @override
  String get settingsSoundSign => 'Sikeres admin művelet visszajelzése';

  @override
  String get settingsSoundEnabled => 'Hangok bekapcsolva';

  @override
  String get settingsSoundMuted => 'Hangok némítva';

  @override
  String get settingsSoundPreview => 'Előnézet';

  @override
  String get settingsSoundStopPreview => 'Előnézet leállítása';

  @override
  String get settingsSoundRestoreDefault => 'Alapértelmezettek visszaállítása';

  @override
  String get settingsSoundVolume => 'Hangerő';

  @override
  String get settingsSoundSystemLimitations =>
      'Elotérben alkalmazáson belüli hang. Új riasztások rendszerértesítést is mutatnak csatornahanggal, amig az admin session aktiv. Teljes hatter pushhez FCM/APNS kell.';

  @override
  String get settingsSoundCriticalAlert =>
      'A kritikus platform riasztások nyugtázást igényelhetnek, és a platform követelményei szerint felülírhatják a némítást.';

  @override
  String get settingsSoundSelectionSaved => 'Hangválasztás mentve';

  @override
  String get settingsSoundPerEventTitle => 'Eseményenkénti hangok';

  @override
  String get settingsSoundPerEventDescription =>
      'Képernyő megnyitas soha nem ad hangot. A kritikus események az alarm kategorian maradnak.';

  @override
  String settingsSoundEventDefault(String soundId) {
    return 'Alapértelmezett: $soundId';
  }

  @override
  String get settingsSoundTestAlert => 'Teszt riasztás küldése';

  @override
  String get settingsSoundTestAlertTitle => 'ViaNexis Admin teszt riasztás';

  @override
  String get settingsSoundTestAlertBody =>
      'Ha látja ezt a bannert és hallja a riasztást, az értesítések működnek.';

  @override
  String get settingsSoundTestAlertSent => 'Teszt riasztás elküldve';

  @override
  String get settingsSoundPermissionDenied =>
      'Az értesítési engedély szükséges a zárolóképernyői riasztásokhoz.';

  @override
  String get settingsSoundEventCompanyRegistration => 'Új cégregisztráció';

  @override
  String get settingsSoundEventDriverRegistration => 'Új sofőrregisztráció';

  @override
  String get settingsSoundEventSupportTicket => 'Új support jegy';

  @override
  String get settingsSoundEventSupportAccess => 'Support hozzáférési keres';

  @override
  String get settingsSoundEventSystemCritical => 'Kritikus rendszerállás';

  @override
  String get settingsSoundEventAuditSecurity => 'Audit biztonsagi esemény';

  @override
  String get settingsSoundEventBilling => 'Számlázási problema';

  @override
  String get settingsSoundEventBulkOnboarding => 'Tömeges onboarding kész';

  @override
  String get settingsSoundEventApprovalSuccess => 'Sikeres admin művelet';

  @override
  String get settingsSoundEventIncomingContact => 'Bejövő kapcsolatkérés';

  @override
  String get settingsSoundAlarm1 => 'Riasztási hang 1';

  @override
  String get settingsSoundAlarm2 => 'Riasztási hang 2';

  @override
  String get settingsSoundAlarm3 => 'Riasztási hang 3';

  @override
  String get settingsSoundMessage1 => 'Üzenet hang 1';

  @override
  String get settingsSoundMessage2 => 'Üzenet hang 2';

  @override
  String get settingsSoundMessage3 => 'Üzenet hang 3';

  @override
  String get settingsSoundMessage4 => 'Üzenet hang 4';

  @override
  String get settingsSoundRing1 => 'Csengő hang 1';

  @override
  String get settingsSoundRing2 => 'Csengő hang 2';

  @override
  String get settingsSoundRing3 => 'Csengő hang 3';

  @override
  String get settingsSoundRing4 => 'Csengő hang 4';

  @override
  String get settingsSoundSign1 => 'Siker hang 1';

  @override
  String get settingsSoundSign2 => 'Siker hang 2';

  @override
  String get settingsSoundSign3 => 'Siker hang 3';

  @override
  String get settingsSoundSign4 => 'Siker hang 4';

  @override
  String get translationPanelTitle => 'Fordítás';

  @override
  String get translationProviderDisabled =>
      'A fordító szolgáltató nincs beállítva';

  @override
  String get translationTargetLanguageLabel => 'Célnyelv';

  @override
  String get translationRecipientLanguageLabel => 'Címzett nyelve';

  @override
  String get translationTranslateAction => 'Fordítás';

  @override
  String get translationTranslating => 'Fordítás…';

  @override
  String get translationActionError => 'A fordítás sikertelen';

  @override
  String get translationOriginalTitle => 'Eredeti szöveg';

  @override
  String get translationTranslatedTitle => 'Lefordított szöveg';

  @override
  String translationLanguageLabel(String code) {
    return 'Nyelv: $code';
  }

  @override
  String get translationMetadataOnlyNotice =>
      'A lefordított szöveg metaadat-only nézetben rejtve';

  @override
  String get translationBadgeMachine => 'Gépi fordítás';

  @override
  String get translationBadgeNeedsReview => 'Felülvizsgálat szükséges';

  @override
  String get translationBadgeStale => 'Elavult fordítás';

  @override
  String get translationBadgeApproved => 'Jóváhagyva';

  @override
  String get translationHumanConfirmationRequired =>
      'Emberi jóváhagyás szükséges a lefordított szöveg küldése előtt';

  @override
  String get translationReplyPreviewTitle => 'Válasz fordítás előnézet';

  @override
  String get translationReplyPreviewNotice =>
      'Csak előnézet. Az eredeti piszkozat megmarad, automatikus küldés nincs.';

  @override
  String get translationGeneratePreviewAction => 'Előnézet generálása';

  @override
  String get translationNoAutoSendNotice =>
      'A jóváhagyás készre jelöli a fordítást. A küldés külön, explicit lépés marad.';

  @override
  String get translationDismissAction => 'Mégse';

  @override
  String get translationApproveForSendAction => 'Fordítás jóváhagyása';

  @override
  String get translationApproving => 'Jóváhagyás…';

  @override
  String get translationDraftReplyAction => 'Válasz fordítás piszkozata';

  @override
  String get translationReplyApprovedNotice =>
      'A fordítás jóváhagyva. Másolja vagy küldje a normál támogatási folyamaton keresztül.';

  @override
  String get customerCommunicationsTitle => 'Ügyfélkommunikáció';

  @override
  String get customerCommunicationDetailTitle => 'Kommunikációs szál';

  @override
  String get customerCommunicationEvidencePackageTitle => 'Bizonyíték csomag';

  @override
  String get customerCommunicationLoadError =>
      'Az ügyfélkommunikáció betöltése sikertelen.';

  @override
  String get customerCommunicationActionError =>
      'Az ügyfél kommunikációs művelet sikertelen.';

  @override
  String get customerCommunicationMockDataBadge => 'Mintaadat';

  @override
  String get customerCommunicationOpenModule => 'Ügyfélkommunikáció megnyitása';

  @override
  String get customerCommunicationPrivacyNotice =>
      'A listanezet metaadat-elso. Az üzenettörzs csak jogosult reszletes nézetben jelenik meg.';

  @override
  String get customerCommunicationDetailMetadataOnly =>
      'Az üzenettörzs rejtve a szerepkör vagy a szál scope miatt.';

  @override
  String get customerCommunicationSearchHint =>
      'Keresés név, domain vagy cég alapján';

  @override
  String get customerCommunicationListEmpty =>
      'Nincs egyező ügyfélkommunikációs szál.';

  @override
  String get customerCommunicationDisputedBadge => 'Vitatott';

  @override
  String get customerCommunicationBillingRelatedBadge => 'Számlázási';

  @override
  String customerCommunicationThreadSubtitle(String domain, String companyId) {
    return '$domain · cég $companyId';
  }

  @override
  String customerCommunicationUpdatedAt(String date) {
    return 'Frissítve: $date';
  }

  @override
  String get customerCommunicationFilterAll => 'Összes';

  @override
  String get customerCommunicationFilterOpen => 'Nyitott';

  @override
  String get customerCommunicationFilterDisputed => 'Vitatott';

  @override
  String get customerCommunicationFilterClosed => 'Lezart';

  @override
  String get customerCommunicationFilterBillingRelated => 'Számlázási';

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
  String get customerCommunicationDirectionInbound => 'Bejövő';

  @override
  String get customerCommunicationDirectionOutbound => 'Kimenő';

  @override
  String get customerCommunicationDirectionInternalNote => 'Belső jegyzet';

  @override
  String get customerCommunicationDirectionSystemEvent => 'Rendszer esemény';

  @override
  String get customerCommunicationDirectionUnknown => 'Ismeretlen';

  @override
  String get customerCommunicationSenderCustomer => 'Ügyfél';

  @override
  String get customerCommunicationSenderPlatformAdmin => 'Platform admin';

  @override
  String get customerCommunicationSenderCompanyAdmin => 'Cég admin';

  @override
  String get customerCommunicationSenderSystem => 'Rendszer';

  @override
  String get customerCommunicationSenderUnknown => 'Ismeretlen';

  @override
  String get customerCommunicationHumanReviewedBadge => 'Emberi felülvizsgálat';

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
      'Üzenettorzs rejtve (metaadat-only nezet).';

  @override
  String get customerCommunicationMessagesEmpty =>
      'Még nincs naplózott üzenet.';

  @override
  String get customerCommunicationTimelineTitle => 'Idovonal';

  @override
  String get customerCommunicationAgreementsTitle =>
      'Megállapodás-pillanatképek';

  @override
  String get customerCommunicationEvidencePackagesTitle =>
      'Bizonyíték csomagok';

  @override
  String get customerCommunicationPackagesEmpty =>
      'Még nincs generálva bizonyíték csomag.';

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
      'PDF generálás függőben; strukturált bizonyíték csomag készült az audit rekordokból.';

  @override
  String get customerCommunicationPdfReadyNotice =>
      'A PDF bizonyíték csomag készen all megosztasra ezen az eszközön.';

  @override
  String get customerCommunicationPdfFailedNotice =>
      'A PDF generálás sikertelen. A strukturált summaryJson tovabbra is elérhető az audit rekordokból.';

  @override
  String get customerCommunicationPdfSourceOfTruthNotice =>
      'ViaNexis audit rekordokból generálva. Az adatbázis audit rekordok maradnak a forrasigazsag; ez a PDF csak bemutato export.';

  @override
  String get customerCommunicationDownloadPdfAction => 'PDF letöltése';

  @override
  String customerCommunicationDownloadPdfSuccess(String bytes) {
    return 'PDF letöltve ($bytes bájt). Kezelje az adatvédelmi és megőrzési szabályzat szerint.';
  }

  @override
  String get customerCommunicationDownloadPdfFailed =>
      'A bizonyíték PDF letöltése sikertelen.';

  @override
  String get customerCommunicationSharePdfAction => 'PDF megosztása';

  @override
  String get customerCommunicationSharePdfSuccess =>
      'A PDF megosztható. Használja az eszköz megosztási menüjét a megnyitáshoz vagy mentéshez.';

  @override
  String get customerCommunicationSharePdfFailed =>
      'A bizonyíték PDF megosztása sikertelen.';

  @override
  String get customerCommunicationSharePdfInvalid =>
      'A bizonyíték PDF üres vagy hibás. Generálja újra a csomagot, vagy próbálja még újra.';

  @override
  String get customerCommunicationSharePdfUnavailable =>
      'A megosztas nem érhető el ezen az eszközön. Próbálkozzon újra vagy használjon másik eszközt.';

  @override
  String get customerCommunicationSharePdfNotReady =>
      'A PDF még nem all készen. Várjon a generálásra, vagy generálja újra a csomagot.';

  @override
  String customerCommunicationGeneratedBy(String userId) {
    return 'Generálta felhasználó ID: $userId';
  }

  @override
  String get customerCommunicationSendReplyTitle => 'Ügyfél válasz küldése';

  @override
  String get customerCommunicationSendReplyAction => 'Válasz küldése';

  @override
  String get customerCommunicationSendReplyMessageLabel => 'Válasz üzenet';

  @override
  String get customerCommunicationSendReplySubjectLabel =>
      'Email targy (opcionalis)';

  @override
  String get customerCommunicationUseTranslatedTextLabel =>
      'Jóváhagyott fordítás használata';

  @override
  String get customerCommunicationHumanConfirmationLabel =>
      'Megerősítem, hogy a válasz küldhető';

  @override
  String get customerCommunicationHumanConfirmedBadge => 'Emberi megerősítés';

  @override
  String get customerCommunicationTranslationApprovedBadge =>
      'Fordítás jóváhagyva';

  @override
  String get customerCommunicationTranslatedReplyWarning =>
      'A lefordított válaszok nem kerülnek automatikusan kiküldésre. Ellenőrizd és erősítsd meg küldés előtt.';

  @override
  String get customerCommunicationDeliveryProviderDisabledNotice =>
      'A küldési szolgáltató le van tiltva; a válasz naplózva lesz, de nem megy ki külső csatornára.';

  @override
  String get customerCommunicationReplyLoggedSkippedNotice =>
      'Válasz naplózva, küldés kihagyva (szolgáltató tiltva).';

  @override
  String get customerCommunicationReplySentSuccess =>
      'Válasz sikeresen elküldve.';

  @override
  String get customerCommunicationEvidenceDeliveryNotice =>
      'A bizonyíték csomagok tartalmazzák a kimenő küldési állapotot, ha elérhető.';

  @override
  String get customerCommunicationDeliveryStatusDraft => 'Piszkozat';

  @override
  String get customerCommunicationDeliveryStatusQueued => 'Sorban';

  @override
  String get customerCommunicationDeliveryStatusSkipped => 'Kihagyva';

  @override
  String get customerCommunicationDeliveryStatusSent => 'Elküldve';

  @override
  String get customerCommunicationDeliveryStatusFailed => 'Sikertelen';

  @override
  String get customerCommunicationDeliveryStatusCancelled => 'Megszakítva';

  @override
  String get customerCommunicationDeliveryStatusUnknown => 'Ismeretlen állapot';

  @override
  String get customerCommunicationDeliveryChannelEmail => 'Email';

  @override
  String get customerCommunicationDeliveryChannelPortal => 'Portal';

  @override
  String get customerCommunicationDeliveryChannelManual => 'Manuális';

  @override
  String get customerCommunicationDeliveryChannelNone => 'Nincs';

  @override
  String get customerCommunicationDeliveryChannelUnknown =>
      'Ismeretlen csatorna';

  @override
  String get customerCommunicationDeliveryHistoryTitle =>
      'Kézbesítési előzmények';

  @override
  String get customerCommunicationDeliveryHistoryEmpty =>
      'Még nincs kézbesítési kísérlet.';

  @override
  String get customerCommunicationDeliveryFilterAll => 'Összes';

  @override
  String get customerCommunicationDeliveryFilterSkipped => 'Kihagyva';

  @override
  String get customerCommunicationDeliveryFilterFailed => 'Sikertelen';

  @override
  String get customerCommunicationDeliveryFilterSent => 'Elküldve';

  @override
  String get customerCommunicationDeliveryFilterQueued => 'Várólistán';

  @override
  String get customerCommunicationResendTitle => 'Kézbesítés újraküldése';

  @override
  String get customerCommunicationResendAction => 'Újraküldés';

  @override
  String get customerCommunicationResendAuditNotice =>
      'Az újraküldés új, auditált kézbesítési kísérletet hoz létre.';

  @override
  String get customerCommunicationResendTranslationNotice =>
      'A lefordított válaszok csak jóváhagyott fordítás után küldhetők.';

  @override
  String get customerCommunicationResendSuccess =>
      'Újraküldés sikeresen naplózva.';

  @override
  String get customerCommunicationDeliveryMultipleAttempts =>
      'Több kézbesítési kísérlet — lásd a kézbesítési előzményeket.';

  @override
  String get customerCommunicationDeliveryResendAttempt =>
      'Ez a kísérlet egy korábbi kézbesítés újraküldése.';

  @override
  String get customerCommunicationDeliveryTemplateLabel => 'E-mail sablon';

  @override
  String get customerCommunicationEvidenceRegenerationNotice =>
      'Az evidence csomagot érdemes újragenerálni új kézbesítési kísérletek után.';

  @override
  String get customerCommunicationHumanConfirmRequired =>
      'Emberi megerősítés szükséges.';

  @override
  String get customerCommunicationDeliveryEventQueued => 'Várólistán';

  @override
  String get customerCommunicationDeliveryEventSent => 'Elküldve';

  @override
  String get customerCommunicationDeliveryEventDelivered => 'Kézbesítve';

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
      'Szolgáltató státusz';

  @override
  String get customerCommunicationDeliveryEventUnknown => 'Ismeretlen esemény';

  @override
  String customerCommunicationPackageGeneratedAt(String date) {
    return 'Generálva: $date';
  }

  @override
  String get customerCommunicationPackageTypeCommunicationEvidence =>
      'Kommunikációs bizonyíték';

  @override
  String get customerCommunicationPackageTypeSubscriptionDispute =>
      'Elofizetes vitat';

  @override
  String get customerCommunicationPackageTypeRegistrationEvidence =>
      'Regisztrációs bizonyíték';

  @override
  String get customerCommunicationPackageTypePricingEvidence =>
      'Árazási bizonyíték';

  @override
  String get customerCommunicationPackageTypeUnknown =>
      'Ismeretlen csomagtipus';

  @override
  String get customerCommunicationPackageStatusGenerated => 'Generálva';

  @override
  String get customerCommunicationPackageStatusFailed => 'Sikertelen';

  @override
  String get customerCommunicationPackageStatusUnknown => 'Ismeretlen állapot';

  @override
  String get customerCommunicationGeneratePackageTitle =>
      'Bizonyíték csomag generálása';

  @override
  String get customerCommunicationGeneratePackageAction => 'Csomag generálása';

  @override
  String get customerCommunicationMarkDisputedTitle =>
      'Szál vitatottként jelölése';

  @override
  String get customerCommunicationMarkDisputedAction => 'Vitatott jelölés';

  @override
  String get customerCommunicationDisputedSectionTitle => 'Vita';

  @override
  String get customerCommunicationReasonLabel => 'Indoklás (kötelező)';

  @override
  String get customerCommunicationReasonRequired =>
      'Legalabb 5 karakter szükséges.';

  @override
  String get customerCommunicationPackageTypeLabel => 'Csomag tipus';

  @override
  String get customerCommunicationExportAuditWarning =>
      'Az export audit által naplózott bizonyíték csomagot készít az adatbázis rekordokból. Adjon meg indoklást.';

  @override
  String get customerCommunicationCancel => 'Mégse';

  @override
  String get customerCommunicationDisputeMarkedSuccess =>
      'A szál vitatottként jelölve.';

  @override
  String get customerCommunicationPackageGeneratedSuccess =>
      'Bizonyíték csomag generálva.';

  @override
  String get customerCommunicationSummaryJsonTitle =>
      'Strukturalt osszefoglalo (hiteles audit export)';

  @override
  String customerCommunicationPackageReason(String reason) {
    return 'Indoklás: $reason';
  }

  @override
  String customerCommunicationFileHash(String hash) {
    return 'Integritás hash: $hash';
  }

  @override
  String get customerCommunicationPackageNotFound =>
      'A bizonyíték csomag nem található.';

  @override
  String get customerCommunicationSummaryTitle => 'Ügyfélkommunikáció';

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
    return 'Összesen: $count';
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
  String get settingsAppearanceSection => 'Megjelenés';

  @override
  String get settingsAppearanceBody =>
      'Válassz nappali (világos), éjszakai (sötét) vagy rendszer szerinti üzemmódot.';

  @override
  String get settingsAppearanceSystem => 'Rendszer';

  @override
  String get settingsAppearanceDay => 'Nappali';

  @override
  String get settingsAppearanceNight => 'Éjszakai';

  @override
  String get settingsSoundEventCustomSound => 'Hang ehhez az eseményhez';

  @override
  String get settingsSoundEventUseCategoryDefault =>
      'Kategória alapértelmezett';

  @override
  String get registrationFieldReviewNotes => 'Ellenőrzési megjegyzés';

  @override
  String get registrationSectionDecision => 'Döntés';

  @override
  String get registrationRejectionReasonTitle => 'Elutasítás részletei';

  @override
  String get applicationsFilterRejected => 'Elutasítottak';

  @override
  String get applicationRejectReasonTitle => 'Jelentkezés elutasítása';

  @override
  String get applicationRejectReasonHint =>
      'Az indok az érintettnek is elküldhető, és a rekordon megmarad';

  @override
  String get applicationRejectConfirm => 'Elutasítás';

  @override
  String get applicationFieldReviewedAt => 'Ellenőrizve';

  @override
  String get applicationFieldReviewNotes => 'Indok';

  @override
  String get driverAccessRejectedTitle => 'Elutasított sofőr jelentkezések';

  @override
  String get driverAccessRejectedEmpty =>
      'Nincs elutasított sofőr jelentkezés.';

  @override
  String get driverAccessRejectedLoadFailed =>
      'Nem sikerült betölteni az elutasított sofőr jelentkezéseket.';

  @override
  String get driverAccessStatusRejected => 'Elutasítva';

  @override
  String get driverAccessRejectedAt => 'Elutasítva ekkor';

  @override
  String get driverAccessRejectedReason => 'Indok';

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

  @override
  String get navOperations => 'Műveleti áttekintés';

  @override
  String get operationsTitle => 'Műveleti áttekintés';

  @override
  String get operationsModuleDescription =>
      'Platform működési mutatók, fuvarok, sofőrök és függőségek.';

  @override
  String get operationsOpenModule => 'Műveleti áttekintés megnyitása';

  @override
  String get operationsMockBadge => 'Tesztadat';

  @override
  String get operationsLoadFailed =>
      'A műveleti áttekintés betöltése sikertelen.';

  @override
  String get operationsPrivacyNotice =>
      'Csak aggregált platform metaadat. Fuvar-, dokumentum- és üzenettartalom nem jelenik meg.';

  @override
  String get operationsPendingSyncTitle => 'Függőben lévő szinkron problémák';

  @override
  String get operationsPendingSyncDependency =>
      'A szinkron figyelmeztetések platform szintű listája még nincs bekötve.';

  @override
  String get operationsPendingSyncUnavailable =>
      'A függő szinkron számláló megbízható backend forrásból még nem érhető el.';

  @override
  String operationsExchangeMetricsSummary(
    int total,
    int disputed,
    int missing,
  ) {
    return '$total rekord · $disputed vitás · $missing hiányos';
  }

  @override
  String get operationsExchangeRecordsTitle => 'Raklap/göngyöleg rekordok';

  @override
  String get operationsExchangeRecordsDependency =>
      'A platform szintű exchange rekord lista endpointja még nem érhető el.';

  @override
  String get operationsCompanyCount => 'Cégek (aktív/összes)';

  @override
  String get operationsActiveDrivers => 'Aktív sofőrök (becslés)';

  @override
  String get operationsActiveTrips => 'Aktív fuvarok';

  @override
  String get operationsCompletedTrips => 'Lezárt fuvarok';

  @override
  String get operationsSupportAccess => 'Aktív support hozzáférés';

  @override
  String get operationsPublicIntakes => 'Függő publikus megkeresések';

  @override
  String get operationsPendingRegistrations => 'Függő regisztrációk';

  @override
  String get operationsPackagesGenerated => 'Generált csomagok';

  @override
  String get operationsModulesTitle => 'Műveleti modulok';

  @override
  String get operationsLinkDriverAccess => 'Sofőr hozzáférés';

  @override
  String get operationsLinkTrips => 'Fuvar áttekintő';

  @override
  String get operationsLinkExchangeRecords => 'Exchange rekordok';

  @override
  String get operationsLinkNotificationStatus => 'Értesítések státusza';

  @override
  String get operationsLinkSupportAccess => 'Support hozzáférés';

  @override
  String get operationsLinkPublicIntakes => 'Publikus megkeresések';

  @override
  String get driverAccessTitle => 'Sofőr hozzáférés';

  @override
  String get driverAccessMockBadge => 'Tesztadat';

  @override
  String get driverAccessLoadFailed => 'A sofőr lista betöltése sikertelen.';

  @override
  String get driverAccessPrivacyNotice =>
      'Csak metaadat: név, státusz, eszköz címke, session szám. Token, PIN hash és üzenettartalom nem jelenik meg.';

  @override
  String get driverAccessBackendTitle => 'Backend függőség';

  @override
  String get driverAccessBackendMessage =>
      'A platform sofőr lista endpointja még nem érhető el. Mock módban minta adat látható.';

  @override
  String get driverAccessDetailTitle => 'Sofőr részletek';

  @override
  String get driverAccessNotFound => 'A sofőr nem található.';

  @override
  String get driverAccessFieldName => 'Név';

  @override
  String get driverAccessFieldCompany => 'Cég';

  @override
  String get driverAccessRegistrationStatus => 'Regisztráció státusz';

  @override
  String get driverAccessFieldDeviceLabel => 'Eszköz címke';

  @override
  String get driverAccessFieldActiveSessions => 'Aktív sessionök';

  @override
  String get driverAccessFieldLastActivity => 'Utolsó aktivitás';

  @override
  String get driverAccessEnableDisableTitle => 'Sofőr engedélyezés/tiltás';

  @override
  String get driverAccessEnableDisableDependency =>
      'A sofőr státusz módosítása endpoint még nem érhető el.';

  @override
  String get driverAccessEnable => 'Sofőr engedélyezése';

  @override
  String get driverAccessDisable => 'Sofőr tiltása';

  @override
  String get driverAccessStatusChangeSuccess => 'Sofőr státusz frissítve.';

  @override
  String get driverAccessStatusChangeFailed =>
      'A sofőr státusz nem módosítható.';

  @override
  String get driverAccessDeviceNotificationTitle => 'Eszköz push regisztráció';

  @override
  String get driverAccessDeviceNotificationUnavailable =>
      'A sofőr eszköz push metaadat még nem érhető el a backendből.';

  @override
  String get driverAccessHasPushToken =>
      'Push token regisztrálva (csak metaadat).';

  @override
  String get driverAccessNoPushToken => 'Nincs regisztrált push token.';

  @override
  String get driverAccessStatusPending => 'Függőben';

  @override
  String get driverAccessStatusActive => 'Aktív';

  @override
  String get driverAccessStatusDisabled => 'Letiltva';

  @override
  String get driverAccessStatusInvited => 'Meghívott';

  @override
  String get driverAccessPendingTitle => 'Függő sofőr regisztrációk';

  @override
  String get driverAccessPendingEmpty =>
      'Nincs függőben lévő sofőr regisztráció.';

  @override
  String get driverAccessPendingApprove => 'Jóváhagyás';

  @override
  String get driverAccessPendingApproveSuccess =>
      'Sofőr regisztráció jóváhagyva.';

  @override
  String get driverAccessPendingApproveFailed =>
      'A sofőr regisztráció jóváhagyása sikertelen.';

  @override
  String get driverAccessPendingLoadFailed =>
      'A függő sofőr regisztrációk betöltése sikertelen.';

  @override
  String get driverAccessPendingBackendMessage =>
      'A függő sofőr regisztráció endpoint még nem érhető el a staging backenden.';

  @override
  String get driverAccessPendingReject => 'Elutasítás';

  @override
  String get driverAccessPendingRejectTitle => 'Sofőr regisztráció elutasítása';

  @override
  String get driverAccessPendingRejectReason => 'Indoklás (kötelező)';

  @override
  String get driverAccessPendingRejectCancel => 'Mégse';

  @override
  String get driverAccessPendingRejectConfirm => 'Regisztráció elutasítása';

  @override
  String get driverAccessPendingRejectSuccess =>
      'Sofőr regisztráció elutasítva.';

  @override
  String get driverAccessPendingRejectFailed =>
      'A sofőr regisztráció elutasítása sikertelen.';

  @override
  String get driverAccessPendingCompanyCode => 'Cégkód';

  @override
  String get driverAccessPendingCreatedAt => 'Beküldve';

  @override
  String get driverAccessNoActiveDrivers =>
      'Nincs aktív sofőr profil a listában.';

  @override
  String get tripsOverviewTitle => 'Fuvar áttekintő';

  @override
  String get tripsOverviewMockBadge => 'Tesztadat';

  @override
  String get tripsOverviewLoadFailed =>
      'A fuvar áttekintő betöltése sikertelen.';

  @override
  String get tripsOverviewPrivacyNotice =>
      'Csak fuvar metaadat: azonosító, státusz, exchange jelzők. Dokumentum- és üzenettartalom nem jelenik meg.';

  @override
  String get tripsOverviewActiveCount => 'Aktív fuvarok';

  @override
  String get tripsOverviewCompletedCount => 'Lezárt fuvarok';

  @override
  String get tripsOverviewParkedCount => 'Parkolt fuvarok';

  @override
  String get tripsOverviewBackendTitle => 'Backend függőség';

  @override
  String get tripsOverviewBackendMessage =>
      'A platform fuvar lista endpointja még nem érhető el. Összesítő számok a dashboard API-ból jönnek.';

  @override
  String get tripsOverviewListTitle => 'Fuvarok';

  @override
  String get tripsOverviewExchangeIndicator => 'Van exchange rekord';

  @override
  String get tripsOverviewExchangeAttention => 'Exchange figyelmeztetés';

  @override
  String get tripsOverviewPendingSync => 'Függő szinkron';

  @override
  String get tripsOverviewStatusActive => 'Aktív';

  @override
  String get tripsOverviewStatusCompleted => 'Lezárt';

  @override
  String get tripsOverviewStatusParked => 'Parkolt';

  @override
  String get tripsOverviewStatusPending => 'Függő';

  @override
  String get exchangeRecordsTitle => 'Exchange rekordok';

  @override
  String get exchangeRecordsMockBadge => 'Tesztadat';

  @override
  String get exchangeRecordsLoadFailed =>
      'Az exchange rekordok betöltése sikertelen.';

  @override
  String get exchangeRecordsPrivacyNotice =>
      'Csak rekord metaadat: tétel, mennyiség, státusz, időbélyeg. Melléklet tartalom és storage kulcs nem jelenik meg.';

  @override
  String get exchangeRecordsBackendTitle => 'Backend függőség';

  @override
  String get exchangeRecordsBackendMessage =>
      'A platform szintű exchange rekord lista endpointja még nem érhető el.';

  @override
  String get exchangeRecordsFilterAll => 'Összes';

  @override
  String get exchangeRecordsFilterDisputed => 'Vitás';

  @override
  String get exchangeRecordsFilterDamaged => 'Sérült';

  @override
  String get exchangeRecordsFilterMissing => 'Hiányzó';

  @override
  String get exchangeRecordsListEmpty =>
      'Nincs megjeleníthető rekord a szűrővel.';

  @override
  String get exchangeRecordsFieldStatus => 'Státusz';

  @override
  String get exchangeRecordsFieldMissing => 'Hiány';

  @override
  String get exchangeRecordsFieldDamaged => 'Sérült';

  @override
  String get exchangeRecordsStatusCompleted => 'Lezárt';

  @override
  String get exchangeRecordsStatusDisputed => 'Vitás';

  @override
  String get exchangeRecordsStatusDamaged => 'Sérült';

  @override
  String get exchangeRecordsStatusMissing => 'Hiányzó';

  @override
  String get exchangeRecordsStatusUnknown => 'Ismeretlen';

  @override
  String get notificationStatusTitle => 'Értesítések státusza';

  @override
  String get notificationStatusPrivacyNotice =>
      'Csak push infrastruktúra metaadat. FCM/APNS token, secret és credential nem jelenik meg.';

  @override
  String get notificationStatusLoadFailed =>
      'Az értesítés státusz betöltése sikertelen.';

  @override
  String get notificationStatusDriverFoundationTitle =>
      'Sofőr app értesítés alap';

  @override
  String get notificationStatusDriverFoundationReady =>
      'Kész — in-app és push foundation implementálva.';

  @override
  String get notificationStatusDeviceTokenTitle => 'Eszköz token regisztráció';

  @override
  String get notificationStatusDeviceTokenDependency =>
      'A sofőr eszköz token regisztráció endpointja még nem érhető el az admin számára.';

  @override
  String get notificationStatusEventsTitle => 'Utolsó értesítési események';

  @override
  String get notificationStatusEventsDependency =>
      'A platform értesítési esemény lista endpointja még nem érhető el.';

  @override
  String get notificationStatusEventsUnavailable =>
      'Az értesítési esemény tároló még nem érhető el (sourceUnavailable).';

  @override
  String get notificationStatusEventsEmpty =>
      'Még nincs rögzített értesítési esemény.';

  @override
  String get notificationStatusProductionPushConfigured =>
      'Éles push backend konfigurálva';

  @override
  String get notificationStatusBackendDependency =>
      'Backend függőség — éles push még nem teljes.';

  @override
  String get companyExchangeItemSortOrder => 'Sorrend';

  @override
  String get companyExchangePackagingCrudTitle => 'Göngyöleg lista szerkesztés';

  @override
  String get companyExchangePackagingCrudDependency =>
      'Az alapértelmezett göngyöleg tételek CRUD műveletei még nem érhetők el. Jelenleg csak olvasható lista.';

  @override
  String get companyExchangeManualPalletRecordTitle =>
      'Sofőr manuális raklap rögzítés';

  @override
  String get companyExchangeManualPalletRecordDependency =>
      'A sofőr manuális raklap rögzítés policy kapcsoló endpointja még nem érhető el.';

  @override
  String get companyExchangeManualPalletEnabled =>
      'Sofőr manuális raklap rögzítés engedélyezése';

  @override
  String get companyExchangeManualPalletEnabledHint =>
      'Bekapcsolva a sofőr manuálisan rögzíthet raklapcserét.';

  @override
  String get companyExchangeAddPackagingItem => 'Göngyöleg hozzáadása';

  @override
  String get companyExchangeEditPackagingItem => 'Göngyöleg szerkesztése';

  @override
  String get companyExchangePackagingItemName => 'Göngyöleg neve';

  @override
  String get companyExchangePackagingItemNameRequired =>
      'Add meg a göngyöleg nevét.';

  @override
  String get companyExchangePackagingItemNotes => 'Megjegyzés';

  @override
  String get companyExchangePackagingItemSortOrder => 'Sorrend';

  @override
  String get companyExchangeSavePackagingItem => 'Mentés';

  @override
  String get companyExchangePackagingItemSaved => 'Göngyöleg lista mentve.';

  @override
  String get companyExchangePackagingItemSaveFailed =>
      'Nem sikerült menteni a göngyöleg elemet.';

  @override
  String get companyExchangeDeactivatePackagingItem => 'Deaktiválás';

  @override
  String get companyExchangeReactivatePackagingItem => 'Újraaktiválás';

  @override
  String get companyExchangePackagingItemEmpty =>
      'Még nincs rögzített göngyöleg elem ennél a cégnél.';

  @override
  String get companyExchangeCancel => 'Mégse';

  @override
  String get systemMonitoringTitle => 'Rendszerfelügyelet';

  @override
  String get systemMonitoringOpenIncidentCenter => 'Incidensközpont megnyitása';

  @override
  String get systemMonitoringLoadError =>
      'A rendszerfelügyeleti adatok betöltése sikertelen.';

  @override
  String get systemMonitoringActionUnavailable =>
      'Ez a felügyeleti művelet még nem érhető el a csatlakoztatott backenden.';

  @override
  String get systemMonitoringMockDataBadge => 'Mintaadat';

  @override
  String get systemMonitoringComponentsTitle => 'Komponensek';

  @override
  String get systemMonitoringComponentsEmpty =>
      'Nincs a szűrőnek megfelelő komponens.';

  @override
  String get systemMonitoringActiveIncidentsTitle => 'Aktív incidensek';

  @override
  String get systemMonitoringViewAllIncidents => 'Összes incidens';

  @override
  String get systemMonitoringIncidentsEmpty =>
      'Nincs a szűrőnek megfelelő incidens.';

  @override
  String get systemMonitoringIncidentsTitle => 'Incidensek';

  @override
  String get systemMonitoringIncidentDetailTitle => 'Incidens';

  @override
  String get systemMonitoringComponentDetailTitle => 'Komponens';

  @override
  String get systemMonitoringRefreshAction => 'Felügyelet frissítése';

  @override
  String get systemMonitoringPrivacyNotice =>
      'Csak metaadat — nincs bérlői üzemeltetési fuvar-, dokumentum- vagy üzenettartalom.';

  @override
  String systemMonitoringOverallStatusLabel(String status) {
    return 'Összesített állapot: $status';
  }

  @override
  String systemMonitoringLastRefresh(String date) {
    return 'Utolsó frissítés: $date';
  }

  @override
  String get systemMonitoringMetricHealthy => 'Egészséges';

  @override
  String get systemMonitoringMetricDegraded => 'Romlott';

  @override
  String get systemMonitoringMetricUnhealthy => 'Nem egészséges';

  @override
  String get systemMonitoringMetricUnknown => 'Ismeretlen';

  @override
  String get systemMonitoringMetricNotConfigured => 'Nincs konfigurálva';

  @override
  String get systemMonitoringMetricActiveIncidents => 'Aktív incidensek';

  @override
  String get systemMonitoringMetricCriticalIncidents => 'Kritikus incidensek';

  @override
  String systemMonitoringMetricApiErrors(String count) {
    return 'API hibák (1 óra): $count';
  }

  @override
  String systemMonitoringMetricFailedNotifications(String count) {
    return 'Sikertelen értesítések: $count';
  }

  @override
  String systemMonitoringMetricDbLatency(String ms) {
    return 'DB késleltetés: $ms ms';
  }

  @override
  String get systemMonitoringMetricRedisConnected => 'Redis csatlakozva';

  @override
  String get systemMonitoringMetricRedisDisconnected =>
      'Redis nincs csatlakozva';

  @override
  String get systemMonitoringStatusHealthy => 'Egészséges';

  @override
  String get systemMonitoringStatusDegraded => 'Romlott';

  @override
  String get systemMonitoringStatusUnhealthy => 'Nem egészséges';

  @override
  String get systemMonitoringStatusUnknown => 'Ismeretlen';

  @override
  String get systemMonitoringStatusDisabled => 'Kikapcsolva';

  @override
  String get systemMonitoringStatusNotConfigured => 'Nincs konfigurálva';

  @override
  String get systemMonitoringFilterAll => 'Összes';

  @override
  String get systemMonitoringFilterDegradedUnhealthy =>
      'Romlott / nem egészséges';

  @override
  String get systemMonitoringFilterOpen => 'Nyitott';

  @override
  String get systemMonitoringFilterInvestigating => 'Vizsgálat alatt';

  @override
  String get systemMonitoringFilterMonitoring => 'Megfigyelés alatt';

  @override
  String get systemMonitoringFilterResolved => 'Megoldott';

  @override
  String get systemMonitoringFilterDismissed => 'Elvetett';

  @override
  String get systemMonitoringFilterCritical => 'Kritikus';

  @override
  String get systemMonitoringFilterHigh => 'Magas';

  @override
  String get systemMonitoringIncidentSeverityInfo => 'Információ';

  @override
  String get systemMonitoringIncidentSeverityWarning => 'Figyelmeztetés';

  @override
  String get systemMonitoringIncidentSeverityHigh => 'Magas';

  @override
  String get systemMonitoringIncidentSeverityCritical => 'Kritikus';

  @override
  String get systemMonitoringIncidentSeverityUnknown => 'Ismeretlen';

  @override
  String get systemMonitoringIncidentStatusOpen => 'Nyitott';

  @override
  String get systemMonitoringIncidentStatusInvestigating => 'Vizsgálat alatt';

  @override
  String get systemMonitoringIncidentStatusMonitoring => 'Megfigyelés alatt';

  @override
  String get systemMonitoringIncidentStatusResolved => 'Megoldott';

  @override
  String get systemMonitoringIncidentStatusDismissed => 'Elvetett';

  @override
  String get systemMonitoringIncidentStatusUnknown => 'Ismeretlen';

  @override
  String get systemMonitoringIncidentSourceAlertRule => 'Riasztási szabály';

  @override
  String get systemMonitoringIncidentSourceManual => 'Kézi';

  @override
  String get systemMonitoringIncidentSourceHealthCheck => 'Állapotellenőrzés';

  @override
  String get systemMonitoringIncidentSourceRecovery => 'Helyreállítás';

  @override
  String get systemMonitoringIncidentSourceUnknown => 'Ismeretlen forrás';

  @override
  String systemMonitoringIncidentDetectedAt(String date) {
    return 'Észlelve: $date';
  }

  @override
  String systemMonitoringIncidentAcknowledgedAt(String date) {
    return 'Nyugtázva: $date';
  }

  @override
  String systemMonitoringActiveIncidentsBadge(String count) {
    return '$count aktív';
  }

  @override
  String systemMonitoringResponseTimeMs(String ms) {
    return '$ms ms';
  }

  @override
  String get systemMonitoringDependencyCritical => 'Kritikus függőség';

  @override
  String get systemMonitoringDependencyOptional => 'Opcionális függőség';

  @override
  String get systemMonitoringDependencyColocated => 'Együtt telepített';

  @override
  String get systemMonitoringDependencyExternal => 'Külső';

  @override
  String get systemMonitoringDependencyUnknown => 'Ismeretlen függőség';

  @override
  String get systemMonitoringFieldCheckedAt => 'Ellenőrizve';

  @override
  String get systemMonitoringFieldDependencyType => 'Függőség típusa';

  @override
  String get systemMonitoringFieldResponseTime => 'Válaszidő';

  @override
  String get systemMonitoringFieldTechnicalCode => 'Technikai kód';

  @override
  String get systemMonitoringFieldConfigured => 'Konfigurálva';

  @override
  String get systemMonitoringFieldAffectedCapabilities => 'Érintett képességek';

  @override
  String get systemMonitoringFieldEvidence => 'Bizonyíték';

  @override
  String get systemMonitoringFieldComponent => 'Komponens';

  @override
  String get systemMonitoringYes => 'Igen';

  @override
  String get systemMonitoringNo => 'Nem';

  @override
  String get systemMonitoringDiagnosticTitle => 'Diagnosztikai javaslat';

  @override
  String get systemMonitoringAiDisclaimer =>
      'Csak tájékoztató — a szabály-/AI-javaslat nem automatikus javítási utasítás, és hiányos lehet.';

  @override
  String get systemMonitoringDiagnosticPossibleCauses => 'Lehetséges okok';

  @override
  String get systemMonitoringDiagnosticRecommendedChecks =>
      'Ajánlott ellenőrzések';

  @override
  String get systemMonitoringDiagnosticMissingEvidence => 'Hiányzó bizonyíték';

  @override
  String get systemMonitoringDiagnosticAiGenerated => 'AI által generált';

  @override
  String get systemMonitoringDiagnosticRuleBased => 'Szabályalapú';

  @override
  String get systemMonitoringDiagnosticConfidenceLow =>
      'Megbízhatóság: alacsony';

  @override
  String get systemMonitoringDiagnosticConfidenceMedium =>
      'Megbízhatóság: közepes';

  @override
  String get systemMonitoringDiagnosticConfidenceHigh => 'Megbízhatóság: magas';

  @override
  String get systemMonitoringDiagnosticConfidenceUnknown =>
      'Megbízhatóság: ismeretlen';

  @override
  String get systemMonitoringDiagnosticUrgencyLow => 'Sürgősség: alacsony';

  @override
  String get systemMonitoringDiagnosticUrgencyMedium => 'Sürgősség: közepes';

  @override
  String get systemMonitoringDiagnosticUrgencyHigh => 'Sürgősség: magas';

  @override
  String get systemMonitoringDiagnosticUrgencyCritical => 'Sürgősség: kritikus';

  @override
  String get systemMonitoringDiagnosticUrgencyUnknown =>
      'Sürgősség: ismeretlen';

  @override
  String get systemMonitoringTimelineTitle => 'Idővonal';

  @override
  String get systemMonitoringTimelineEmpty =>
      'Még nincsenek idővonal-események.';

  @override
  String get systemMonitoringNoteLabel => 'Megjegyzés';

  @override
  String get systemMonitoringNoteRequired => 'Legalább 3 karaktert adjon meg.';

  @override
  String get systemMonitoringActionAcknowledge => 'Nyugtázás';

  @override
  String get systemMonitoringActionAddNote => 'Megjegyzés hozzáadása';

  @override
  String get systemMonitoringActionChangeStatus => 'Állapot módosítása';

  @override
  String get systemMonitoringActionSuccess => 'Felügyeleti művelet mentve.';

  @override
  String get systemMonitoringActionError =>
      'A felügyeleti művelet mentése sikertelen.';

  @override
  String get systemMonitoringActionAuditNotice =>
      'Ez a művelet rögzítésre kerül a platform audit naplójában.';

  @override
  String get eventLogPdfArchiveTitle => 'Eseménynapló PDF archívum';

  @override
  String get eventLogPdfArchiveBody =>
      'A szűrt eseménynapló pillanatképeket ViaNexis stílusú PDF-ként tárolhatod. Megnyitáskor nagyítható, letölthető és megosztható. Az ékezetes betűk Unicode betűtípussal jelennek meg.';

  @override
  String get eventLogPdfArchiveEmpty => 'Még nincs tárolt eseménynapló PDF.';

  @override
  String get eventLogPdfArchiveLoadFailed =>
      'Nem sikerült betölteni a PDF archívumot.';

  @override
  String get eventLogPdfTitle => 'ViaNexis eseménynapló';

  @override
  String get eventLogPdfSubtitle =>
      'Platform audit és működési tevékenység pillanatkép';

  @override
  String eventLogPdfGeneratedAt(String when) {
    return 'Generálva: $when';
  }

  @override
  String get eventLogPdfEmpty =>
      'Nincs a jelenlegi szűrőknek megfelelő esemény.';

  @override
  String get eventLogPdfGenerate => 'Jelenlegi szűrő mentése PDF-ként';

  @override
  String get eventLogPdfSaved => 'Az eseménynapló PDF elmentve az archívumba.';

  @override
  String get eventLogPdfSaveFailed =>
      'Nem sikerült elmenteni az eseménynapló PDF-et.';

  @override
  String get eventLogPdfShare => 'PDF megosztása';

  @override
  String get eventLogPdfShareFailed => 'Nem sikerült megosztani a PDF-et.';

  @override
  String get eventLogPdfDownload => 'PDF letöltése / exportálása';

  @override
  String get eventLogPdfDeleteTitle => 'PDF törlése';

  @override
  String eventLogPdfDeleteBody(String fileName) {
    return 'Töröljük a(z) $fileName fájlt az archívumból?';
  }

  @override
  String get eventLogPdfDeleteAllTitle => 'Tevékenység-PDF-ek törlése';

  @override
  String get eventLogPdfDeleteAllBody =>
      'Töröljük az összes tárolt eseménynapló tevékenység-PDF-et erről az eszközről?';

  @override
  String get eventLogPdfDeleteConfirm => 'Törlés';

  @override
  String get eventLogPdfDeleted => 'Törölve.';

  @override
  String eventLogPdfEntryCount(int count) {
    return '$count esemény';
  }

  @override
  String get notificationsDeleteMenu => 'Értesítések / tevékenységek törlése';

  @override
  String get notificationsDeleteTitle => 'Értesítés törlése';

  @override
  String get notificationsDeleteBody =>
      'Véglegesen töröljük ezt az értesítést?';

  @override
  String get notificationsDeleteAllTitle => 'Összes értesítés törlése';

  @override
  String get notificationsDeleteAllBody =>
      'Töröljük az összes értesítést a postaládából?';

  @override
  String get notificationsDeleteBothTitle =>
      'Értesítések és tevékenység-PDF-ek törlése';

  @override
  String get notificationsDeleteBothBody =>
      'Töröljük az összes értesítést és az összes tárolt tevékenység-PDF-et?';

  @override
  String get notificationsDeleteConfirm => 'Törlés';

  @override
  String get notificationsDeleted => 'Értesítés(ek) törölve.';

  @override
  String get notificationsDeletedBoth =>
      'Értesítések és tevékenység-PDF-ek törölve.';

  @override
  String get systemHealthFieldAffectedUser => 'Érintett felhasználó';

  @override
  String get systemHealthNotifyCompanyTitle => 'Cég értesítése';

  @override
  String systemHealthNotifyCompanyBody(String company, String user) {
    return 'Küldjünk autómatikus visszajelzést a(z) $company cégnek (felhasználó: $user), hogy észleltük a hibát, utánanézünk, amint lehet javítjuk, és értesítjük, amint változás állt be?';
  }

  @override
  String get systemHealthNotifyCompanyConfirm => 'Visszajelzés küldése';

  @override
  String get systemHealthNotifyCompanySuccess =>
      'A visszajelző e-mail elküldve.';

  @override
  String get systemHealthNotifyCompanyFailed =>
      'Nem sikerült elküldeni a visszajelző e-mailt.';

  @override
  String get qrCodesTitle => 'QR-kódok';

  @override
  String get qrCodesGenerateAction => 'QR-kód generálása';

  @override
  String get qrCodesUserTitle => 'Felhasználói QR';

  @override
  String get qrCodesDriverTitle => 'Sofőr QR';

  @override
  String get qrCodesCompanyTitle => 'Céges QR';

  @override
  String get qrCodesPurposeLabel => 'Cél';

  @override
  String get qrCodesPurposeUserInvite => 'Meghívó QR';

  @override
  String get qrCodesPurposeUserActivation => 'Aktiválási QR';

  @override
  String get qrCodesPurposePasswordSetup => 'Jelszóbeállító QR';

  @override
  String get qrCodesPurposeDriverAppLink => 'Driver App összekapcsoló QR';

  @override
  String get qrCodesPurposeDriverProfile => 'Sofőr profil QR';

  @override
  String get qrCodesPurposeCompanyProfile => 'Céges adatlap QR';

  @override
  String get qrCodesPurposeCompanyInvite => 'Céges meghívó QR';

  @override
  String get qrCodesPurposeCompanyPortalLogin => 'Portál hozzáférési QR';

  @override
  String get qrCodesPurposeCompanyOnboarding => 'Onboarding QR';

  @override
  String get qrCodesPurposeSupportReference => 'Support referencia QR';

  @override
  String get qrCodesPurposeInternalAdmin => 'Belső admin rekord QR';

  @override
  String get qrCodesPurposePublicCompany => 'Nyilvános céges info QR';

  @override
  String get qrCodesPurposePublicDriver => 'Nyilvános sofőr ID QR';

  @override
  String get qrCodesExpiresLabel => 'Lejárat';

  @override
  String get qrCodesSingleUse => 'Egyszer használható';

  @override
  String get qrCodesMultiUse => 'Többször használható';

  @override
  String get qrCodesUsageLimit => 'Felhasználási limit';

  @override
  String get qrCodesStatusActive => 'Aktív';

  @override
  String get qrCodesStatusExpired => 'Lejárt';

  @override
  String get qrCodesStatusConsumed => 'Felhasznált';

  @override
  String get qrCodesStatusRevoked => 'Visszavont';

  @override
  String get qrCodesShare => 'QR megosztása';

  @override
  String get qrCodesSave => 'QR mentése';

  @override
  String get qrCodesCopyLink => 'Link másolása';

  @override
  String get qrCodesRegenerate => 'Újragenerálás';

  @override
  String get qrCodesRevoke => 'Visszavonás';

  @override
  String get qrCodesHistory => 'QR előzmények';

  @override
  String get qrCodesSecurityWarning =>
      'Csak hivatalos ViaNexis alkalmazásban vagy oldalon nyissa meg. Soha ne osszon meg jelszót.';

  @override
  String get qrCodesInvalid => 'Érvénytelen QR';

  @override
  String get qrCodesExpired => 'Lejárt QR';

  @override
  String get qrCodesConsumed => 'Már felhasznált QR';

  @override
  String get qrCodesAccessDenied => 'Hozzáférés megtagadva';

  @override
  String get qrCodesStagingBadge => 'STAGING / TESZT — nem éles';

  @override
  String get qrCodesProductionBadge => 'Éles QR';

  @override
  String get qrCodesCreateSuccess => 'QR-kód létrehozva';

  @override
  String get qrCodesRevokeSuccess => 'QR-kód visszavonva';

  @override
  String get qrCodesRegenerateSuccess => 'QR-kód újragenerálva';

  @override
  String get qrCodesLinkCopied => 'Biztonságos link bemásolva';

  @override
  String get qrCodesEmptyHistory => 'Még nincs QR-kód';

  @override
  String get qrCodesCreate => 'Létrehozás';

  @override
  String get qrCodesClose => 'Bezárás';

  @override
  String get qrCodesTargetSummary => 'Célrekord';

  @override
  String get qrCodesUsedCount => 'Használatok';

  @override
  String get qrCodesIdentityCard => 'Azonosító kártya';

  @override
  String get qrCodesShareCard => 'Kártya megosztása';

  @override
  String get qrCodesSaveCard => 'Kártya mentése';

  @override
  String get qrCodesCardSaved => 'Azonosító kártya mentésre kész';

  @override
  String get qrCodesOpenQr => 'QR megnyitása';

  @override
  String get qrCodesQrSaved => 'QR kép mentésre kész';

  @override
  String get qrCodesAttachPhoto => 'Fénykép csatolása';

  @override
  String get qrCodesChangePhoto => 'Fénykép cseréje';

  @override
  String get qrCodesRemovePhoto => 'Fénykép eltávolítása';

  @override
  String get qrCodesCardBrandDriver => 'ViaNexis Sofőr ID';

  @override
  String get qrCodesCardBrandCompany => 'ViaNexis Cég ID';

  @override
  String get qrCodesCardBrandUser => 'ViaNexis Felhasználó ID';

  @override
  String get qrCodesCardFieldName => 'Név';

  @override
  String get qrCodesCardFieldId => 'Azonosító';

  @override
  String get qrCodesCardFieldRole => 'Szerep';

  @override
  String get qrCodesCardFieldPurpose => 'Cél';

  @override
  String get qrCodesCardFieldDetail => 'Részlet';

  @override
  String get qrCodesRoleDriver => 'Sofőr';

  @override
  String get qrCodesRoleCompany => 'Cég';

  @override
  String get qrCodesRoleUser => 'Felhasználó';

  @override
  String get qrCodesSendEmail => 'E-mail küldése';

  @override
  String get qrCodesDeliveryStatus => 'E-mail kézbesítés';

  @override
  String get qrCodesDeliveryDisabled =>
      'A meghívó létrejött, de az e-mail kézbesítés nincs engedélyezve.';

  @override
  String get qrCodesDeliverySent => 'Meghívó e-mail elküldve.';

  @override
  String get qrCodesDeliveryFailed =>
      'A meghívó e-mailt nem sikerült elküldeni.';

  @override
  String get qrCodesRecipientEmail => 'Címzett e-mail';

  @override
  String get qrCodesInviteeName => 'Meghívott neve (opcionális)';

  @override
  String get qrCodesActivationLink => 'Aktiváló link';

  @override
  String get qrCodesSendSuccess => 'Meghívó e-mail sikeresen elküldve.';

  @override
  String get qrCodesSendSkipped =>
      'Meghívó létrehozva. Az e-mail nem lett elküldve (kihagyva).';
}
