# ViaNexis Admin App — environments

## Profiles

| `APP_ENV` | Purpose | Mock fallback when API unset |
|-----------|---------|------------------------------|
| `local` | Local UI / emulator (default) | Yes |
| `dev` | Shared dev API | Yes |
| `staging` | Pre-production | No |
| `production` | Production operators | No |

## Dart defines

| Define | Required | Description |
|--------|----------|-------------|
| `APP_ENV` | No (defaults to `local`) | Environment profile |
| `API_BASE_URL` | Yes for staging/production | HTTPS base URL of `transdoc-backend` |
| `ALLOW_MOCK_FALLBACK` | No | `true` forces mock fallback even in staging/production (debug only) |

## Examples

Local / emulator (Android emulator → host machine):

```powershell
flutter run --dart-define=APP_ENV=local --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

Development:

```powershell
flutter run --dart-define=APP_ENV=dev --dart-define=API_BASE_URL=https://api-dev.example.com
```

Staging release APK:

```powershell
flutter build apk --release --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://api-staging.example.com
```

Production release APK:

```powershell
flutter build apk --release --dart-define=APP_ENV=production --dart-define=API_BASE_URL=https://api.example.com
```

## Privacy

- Never embed secrets, tokens, or database URLs in the app.
- Settings and release views show API **host** only, not credentials.
- Mock fallback is disabled in staging/production unless `ALLOW_MOCK_FALLBACK=true`.
