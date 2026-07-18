# Codex Dream Skin

<p align="center">
  <a href="./README.md">中文</a> · <strong>English</strong>
</p>

<p align="center">
  <strong>Give the Codex desktop app a more personal atmosphere.</strong><br>
  External theming · local CDP injection · no official package modification
</p>

<p align="center">
  Unofficial and not affiliated with OpenAI. It does not modify <code>.app</code>, <code>app.asar</code>, or WindowsApps.
</p>

This project is a fork of [Fei-Away/Codex-Dream-Skin](https://github.com/Fei-Away/Codex-Dream-Skin). GitHub's fork network preserves the upstream relationship, commit history, and contributor attribution.

## What this fork changes

This fork focuses on a publicly distributable, privacy-safe, and fully recoverable desktop theming tool rather than a collection of celebrity, character, or branded theme assets.

- Removes celebrity portraits, protected characters, branded theme packs, and screenshots that could expose accounts, chats, task titles, or local paths from the current `main` branch.
- Keeps only programmatically generated abstract examples; user images, theme libraries, configuration, and runtime copies stay local.
- Improves the Windows double-click install, launch, tray import, and Restore flows while retaining macOS menu-bar switching and local image import.
- Restricts CDP to `127.0.0.1` and never modifies official Codex binaries, signatures, `app.asar`, or WindowsApps.
- Adds bilingual guidance, media-rights boundaries, Issue/PR templates, and cross-platform regression coverage.

Because this is a GitHub fork, upstream commits remain part of the shared fork network. This fork's current `main` branch and future releases do not redistribute the removed media. Verify portrait, copyright, and trademark permissions before reusing assets from upstream history.

## Start with one image

Codex Dream Skin turns a wide, UI-free image that you are allowed to use into an installable, switchable, verifiable, and recoverable Codex theme. The repository distributes abstract examples only; it does not bundle celebrity, character, or branded theme packs.

Shortest Windows path:

1. Prepare a wide background with no sidebar, buttons, composer, or readable text.
2. Download and extract the repository, then run [`windows/Install Codex Dream Skin.cmd`](./windows/Install%20Codex%20Dream%20Skin.cmd).
3. Use the tray menu to import your image.
4. Check the new-task route, a normal task route, and the composer, then save the theme.
5. Use the Restore shortcut whenever you want the official appearance back.

On macOS, the menu bar can switch between the bundled programmatic abstract presets or an image you import. See [`macos/README.md`](./macos/README.md).

<p align="center">
  <img src="docs/images/screenshot-demo-art.png" alt="Codex Dream Skin abstract-background example" width="900"><br>
  <sub>The example demonstrates a background combined with native controls; public screenshots should contain fictional, sanitized content.</sub>
</p>

Some Microsoft Store environments need an approximately 1.8GB local launch copy. It is runtime state, not theme media, and remains excluded from GitHub and releases.

## What it does

- Keeps native controls interactive instead of painting a fake interface into the wallpaper.
- Extends a wide background across the window and reduces its emphasis on task routes.
- Imports, saves, and switches local themes.
- Pauses theming and restores the official appearance.
- Keeps CDP on `127.0.0.1` and does not modify official binaries or signatures.

## Entry points

| Platform | Directory | Entry point |
|---|---|---|
| macOS | [`macos/`](./macos/) | Double-click `Install Codex Dream Skin.command` |
| Windows | [`windows/`](./windows/) | Double-click `Install Codex Dream Skin.cmd` |

Further reading:

- [One-shot custom skin workflow](./docs/one-shot-skin-workflow.md)
- [Windows custom skin guide](./docs/windows-custom-skin-guide.md)
- [Reference-image and clean-background prompts](./docs/reference-background-prompt-guide.en.md)
- [Platform paths and differences](./docs/platforms.md)
- [Documentation index](./docs/INDEX.md)

## Media and privacy boundaries

- Commit only media you own or have explicit permission to redistribute.
- Do not commit celebrity likenesses, protected characters, customer brands, private chats, account names, real task titles, or screenshots containing local paths.
- AI generation does not automatically resolve likeness, trademark, or source-material rights.
- Imported images, saved themes, configuration, and runtime copies remain Git-ignored local state.

## Sponsor

Thanks to [Passion8](https://passion8.cc/register?aff=TuPe) for sponsoring the project. The theming workflow is independent from API-provider configuration and does not rewrite it.

## Feedback and contributions

- Issues: use the [issue templates](./.github/ISSUE_TEMPLATE/) and include the platform, version, reproduction steps, and Restore result.
- Pull requests: use the [PR template](./.github/pull_request_template.md) and include tests plus a sanitized screenshot when needed.

## License

The software is released under the [MIT License](./LICENSE). Example media and third-party marks do not automatically inherit redistribution rights from the code license; see [NOTICE.md](./NOTICE.md).
