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
}
