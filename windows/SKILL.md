---
name: codex-dream-skin
description: Create, apply, launch, verify, repair, update, or restore a custom visual skin for the Windows Codex desktop app. Use when a user wants to turn an image or theme idea into a UI-free wallpaper with adaptive readability while preserving native Codex controls, or needs safe CDP theme troubleshooting and rollback.
---

# Codex Dream Skin

Apply a reversible renderer skin through Chromium DevTools Protocol while launching the official Store-installed Codex executable. Never replace or take ownership of files under `WindowsApps`.

## Workflow

1. Classify the request and establish the brief in `../docs/one-shot-skin-workflow.md`. Unless explicitly requested otherwise, build a visual skin—not a pet, floating component, fake UI mockup, or public preset pack.
2. Install Node.js 22 or newer, then double-click `Install Codex Dream Skin.cmd`. The guided wrapper asks before closing Codex, preserves the user's native appearance settings, seeds the initial theme, creates launch/restore/tray shortcuts, and launches the skin. CLI users can still call `scripts/install-dream-skin.ps1` directly after closing Codex.
3. Run the generated shortcut or `scripts/launch-windows.ps1`. Errors remain visible and are written under `%LOCALAPPDATA%\CodexDreamSkin`. The core `start-dream-skin.ps1` also remains available for automation.
4. Run `scripts/verify-dream-skin.ps1 -ScreenshotPath <absolute-path>` after launch. Treat a missing continuous wallpaper, home shell, native composer, sidebar layer, or injection marker as failure. The native suggestion count is responsive and may be two to four.
5. Inspect the screenshot against `references/qa-inventory.md`. Verify the home screen, normal tasks, composer, sidebar, common window widths, restart/reapply behavior, and Restore before signing off.
6. Run `scripts/restore-dream-skin.ps1` to remove the live skin, close the saved CDP session, and reopen Codex normally. Add `-RestoreBaseTheme` to restore only saved appearance keys, `-RecoverConfigBackup` for explicit byte-for-byte recovery of a damaged config, or `-Uninstall` to delete shortcuts. A completed config restore archives that install's backup so a later install captures a fresh baseline.

## Guardrails

- Preserve the official executable, package signature, user threads, pets, plugins, and authentication state.
- Never add a pet, avatar, floating character, independent button/card, or global decoration merely because the theme subject is a character. Those are separate products and require explicit scope.
- Theme images must be UI-free wallpapers. Never import a README screenshot, fake window, sidebar, card, composer, logo, or text baked into the bitmap.
- Paint one continuous 16:9 wallpaper across the full Codex window. Let the sidebar, main area, header, and composer act as coordinated readability layers; keep the home route expressive and task routes quieter.
- `appearance: auto` follows the native computed `color-scheme` first and the system appearance only as a fallback. Image brightness may tune color and composition, but must not flip the user's shell mode; explicit `light` and `dark` remain authoritative.
- Attach the "选择项目" treatment to Codex's real project-selector toolbar and keep the current project button clickable; never draw a disconnected replacement.
- Keep decorative layers `pointer-events: none` and keep real buttons, navigation, and composer above them.
- On app updates, rerun install and launch; the scripts discover the current Appx package dynamically. Saved paths are never trusted for process control unless they still match a registered package identity.
- `LaunchMode=Auto` first uses the registered Store application identity. If Windows discards the Chromium debugging arguments, it mirrors the currently verified installed runtime into the ignored local `runtime/<version>/` directory and launches that private copy with the Store profile. Never commit, redistribute, or package copied runtime files.
- The default launcher scans for a free port when `9335` is occupied. An explicitly requested occupied port fails closed.
- Keep the injection daemon running for navigation/reload resilience. Its state and logs live under `%LOCALAPPDATA%\CodexDreamSkin`.
- The watcher registers a generation-checked early payload for connected renderers so reload/navigation can paint the skin before the normal load-event fallback; unsupported CDP targets fall back safely.
- The active theme, saved themes, imported images, pause marker, and tray controls live under `%LOCALAPPDATA%\CodexDreamSkin`. Reject empty or over-16 MB images before copying or encoding them.
- Every managed-store write rejects junctions and other reparse points in every existing path component. Imports also use the bundled Node metadata parser before copying to reject dimensions above 16384px or 50MP.
- CDP targets must use a same-port loopback WebSocket, belong to the current Store package, retain the launch-time Browser ID, and expose expected Codex renderer markers.
- Loopback prevents LAN exposure, but Chromium CDP has no same-user authentication. Run only trusted local software while the skin is active, and use restore to close the debug session when it is no longer needed.
- Preserve `config.toml` as strict UTF-8. Never use encoding-dependent whole-file PowerShell reads/writes, silently transcode UTF-16, or overwrite a file that changed after it was read. Ambiguous TOML shapes must fail before writing rather than receive a best-effort rewrite.
- Keep install/start/restore/verify serialized with the per-user operation lock in `common-windows.ps1`.

## Checks

```powershell
powershell -NoProfile -File tests\run-tests.ps1
node --check scripts\injector.mjs
node --check assets\renderer-inject.js
```

## Resources

- `scripts/injector.mjs`: CDP connection, renderer injection, verification, screenshot, and removal.
- `scripts/common-windows.ps1`: Store-package discovery, Node validation, port ownership, state, and process identity safety.
- `scripts/install-windows.ps1`, `launch-windows.ps1`, `restore-windows.ps1`: user-facing wrappers with confirmation, persistent error dialogs, and logs.
- `scripts/config-utf8.ps1`: atomic UTF-8 configuration backup, selective restore, and explicit recovery.
- `assets/dream-skin.css`: full visual layer.
- `assets/renderer-inject.js`: idempotent DOM integration and cleanup.
- `assets/dream-reference.jpg`: programmatic Midnight Aurora abstract wallpaper seeded as the default and as a saved theme; it contains no Codex UI.
- `assets/theme.json`: shared adaptive theme contract for the seeded preset.
- `scripts/theme-windows.ps1`: persistent active/saved theme store, safe image import, pause state, and preset seeding.
- `scripts/tray-dream-skin.ps1`: Windows Forms tray for apply, pause, import, save, switch, and complete restore.
- `references/qa-inventory.md`: required functional and visual signoff coverage.
- `references/runtime-notes.md`: troubleshooting and update behavior.
- `tests/run-tests.ps1`: configuration, state, recovery, payload, and CDP validation regression checks.
