# System monitoring UI

## Purpose

The Admin App `system_monitoring` feature consumes the platform-admin
system-monitoring APIs and presents an incident-aware operations view.
It runs **in parallel** with the existing `system_health` module — that
module is not removed or replaced.

## Live / mock policy

| Mode | When | Behavior |
|------|------|----------|
| **Live** | `AppConfig.shouldUseLiveRepositories == true` | Calls `/platform-admin/system-monitoring/*` with bearer auth. Failures surface as errors / unknown / unavailable. **Never** synthesizes a healthy overview. |
| **Mock** | `shouldUseLiveRepositories == false` | `MockSystemMonitoringRepository` returns realistic sample data (including `not_configured` / `unknown` for unconfigured deps) and shows the mock-data badge. |

Rules:

- Mock is only used when live repositories are disabled.
- On live API errors the UI shows unavailable/unknown — never fake healthy.
- `not_configured` must never be presented as healthy.

## Routes

| Path | Screen |
|------|--------|
| `/system-monitoring` | Overview (status, metrics strip, component grid, active incidents, refresh) |
| `/system-monitoring/components/:key` | Component detail + diagnostic suggestion |
| `/system-monitoring/incidents` | Incident list with filters |
| `/system-monitoring/incidents/:id` | Incident detail (timeline, acknowledge, status, notes) |

RBAC: `AdminDestination.systemMonitoring` — `superAdmin` and `supportAdmin`
(same posture as system health). Discoverable from the modules hub and via
**Open incident center** on the System Health screen.

## Component status meanings

| Status | Meaning |
|--------|---------|
| `healthy` | Evidence indicates the component is operating normally |
| `degraded` | Responding but impaired (e.g. elevated latency) |
| `unhealthy` | Evidence indicates failure |
| `unknown` | Insufficient evidence — prefer over false healthy |
| `disabled` | Intentionally turned off |
| `not_configured` | Required config/credentials missing — never report as healthy |

## Incident severity / status

- Severity: `info` \| `warning` \| `high` \| `critical`
- Status: `open` \| `investigating` \| `monitoring` \| `resolved` \| `dismissed`

## AI / rule diagnostic disclaimer

Diagnostic cards may show rule-based or AI-generated suggestions. The UI always
shows the disclaimer (`systemMonitoringAiDisclaimer`):

> Advisory only — not an automatic repair instruction; suggestions may be incomplete.

Operators must not treat suggestions as automatic production repair commands.
