# Repository Guidelines

## Project Structure & Module Organization

- `macos/` is the primary product: shell launchers, `scripts/` runtime logic, `assets/` CSS/injection payloads, `menubar/` SwiftBar integration, and `tests/` checks.
- `windows/` contains PowerShell launch/install/restore scripts, Node CDP injection, platform assets, references, and Windows-specific tests.
- `docs/` holds platform notes, project history, promotional copy, and sanitized abstract examples. Public images must not contain real accounts, chats, task titles, local paths, celebrity likenesses, or protected characters.
- `.github/` contains issue and pull-request templates. Keep platform behavior documented in `docs/platforms.md`.

## Theme Request Contract

When a user asks to "build a [subject] skin," interpret `skin` as a visual theme made from a UI-free wallpaper plus the native Codex interface. Do not create a pet, floating companion, avatar, fake UI mockup, or distributable preset unless the user explicitly asks for that separate deliverable.

Before implementation, read `README.md`, `docs/INDEX.md`, `docs/one-shot-skin-workflow.md`, and the target platform's `SKILL.md`. Produce a short brief that fixes the platform, layout mode, safe area, native-UI boundary, delivery scope, and acceptance checks. Use repository defaults when those choices are not material: detect the current OS, use `taskMode: auto`, preserve native UI, and keep delivery local. Pause only when the platform cannot be detected, the user provides conflicting layout signals that `auto` cannot resolve, or asset rights/publication scope are unclear.

Default to a local installation. Do not commit user wallpapers, generated character packs, local runtime copies, user configuration, or screenshots containing account names, task titles, or chats. A single sanitized effect screenshot is acceptable when the user authorizes a public example and `NOTICE.md` records its asset boundary.

## Build, Test, and Development Commands

- `cd macos && npm test`: run shell/JavaScript syntax, payload, configuration round-trip, signature, and doctor checks.
- `macos/scripts/doctor-macos.sh`: validate the installed Codex app, signed bundled Node runtime, theme payload, and optional live session.
- `macos/scripts/build-release.sh`: test and build the macOS release ZIP plus SHA-256 file.
- `macos/scripts/build-client-release.sh <output.zip>`: create the customer-facing double-click package.
- `powershell -File windows/tests/run-tests.ps1`: run Windows configuration and static regression checks.

Do not bypass failing checks. Document platform-only test blockers in the PR.

## Coding Style & Naming Conventions

Use two-space indentation in shell, PowerShell, JavaScript, JSON, and CSS. Shell entry points use `set -euo pipefail`; Node files use ESM. Follow existing kebab-case script names such as `start-dream-skin-macos.sh`. Prefer existing platform helpers over new dependencies. Keep comments short and focused on safety or non-obvious behavior.

## Testing Guidelines

Tests must cover changed install, start, inject, verify, pause, and restore behavior. For renderer or CSS changes, run live verification and inspect both home and task routes. Configuration tests must include Chinese/non-ASCII project names and prove unrelated TOML content survives install/restore. Never rewrite `config.toml` through an encoding-dependent API; require strict UTF-8, atomic writes, and a recoverable backup.

Visual signoff also includes the composer, sidebar, common window widths, restart/reapply behavior, and a real Restore cycle. A changed accent color without a visible wallpaper is a failure. Preview composites and README screenshots are never valid wallpaper inputs.

## Commit & Pull Request Guidelines

Prefer `type(scope): summary`, for example `fix(windows): preserve UTF-8 config on restore`. Complete the PR template with platform, rationale, actual test results, linked issues, and screenshots for visual changes. Do not include private chats, API keys, `auth.json`, or customer data.

## Security & Release Notes

CDP must remain loopback-only. Never modify official `.app`, WindowsApps, `app.asar`, signatures, API keys, or Base URLs. Update `macos/CHANGELOG.md` for user-visible macOS changes and bump `macos/VERSION` for release-worthy work. Maintain a clearly labeled Windows changelog as parity features and fixes ship.
