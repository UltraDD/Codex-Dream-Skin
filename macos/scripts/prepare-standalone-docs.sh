#!/bin/bash

set -euo pipefail

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || {
  printf 'Usage: %s <archive-root> [source-docs]\n' "$0" >&2
  exit 1
}

ARCHIVE_ROOT="$(cd "$1" && pwd -P)"
DOCS_SOURCE=""
if [ "$#" -eq 2 ]; then
  DOCS_SOURCE="$(cd "$2" && pwd -P)"
else
  SCRIPT_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
  for candidate in "$SCRIPT_ROOT/docs" "$SCRIPT_ROOT/../docs"; do
    if [ -f "$candidate/reference-background-prompt-guide.md" ]; then
      DOCS_SOURCE="$(cd "$candidate" && pwd -P)"
      break
    fi
  done
fi
[ -n "$DOCS_SOURCE" ] || {
  printf 'Could not locate the prompt documentation beside the macOS tree.\n' >&2
  exit 1
}
DOCS_TARGET="$ARCHIVE_ROOT/docs"

for name in \
  reference-background-prompt-guide.md \
  reference-background-prompt-guide.en.md \
  background-generation-prompts.md; do
  [ -f "$DOCS_SOURCE/$name" ] || {
    printf 'Required prompt documentation is missing: %s\n' "$DOCS_SOURCE/$name" >&2
    exit 1
  }
done
[ -f "$ARCHIVE_ROOT/NOTICE.md" ] || {
  printf 'Standalone NOTICE is missing: %s\n' "$ARCHIVE_ROOT/NOTICE.md" >&2
  exit 1
}

/bin/mkdir -p "$DOCS_TARGET"
/bin/cp "$DOCS_SOURCE/reference-background-prompt-guide.md" \
  "$DOCS_SOURCE/reference-background-prompt-guide.en.md" \
  "$DOCS_SOURCE/background-generation-prompts.md" \
  "$DOCS_TARGET/"

# Prompt guides are authored from the repository root. The macOS tree becomes
# the root of standalone archives, while Windows files remain repository-only.
WINDOWS_ASSET_URL='https://github.com/Fei-Away/Codex-Dream-Skin/blob/main/windows/assets/'
WINDOWS_ASSET_TOKEN='__CODEX_DREAM_SKIN_WINDOWS_ASSET_URL__'
for file in "$DOCS_TARGET"/*.md; do
  temporary="${file}.standalone"
  /usr/bin/sed \
    -e 's#macos/presets/#presets/#g' \
    -e 's#macos/assets/#assets/#g' \
    -e 's#macos/NOTICE\.md#NOTICE.md#g' \
    -e "s#${WINDOWS_ASSET_URL}#${WINDOWS_ASSET_TOKEN}#g" \
    -e "s#https://github.com/Fei-Away/Codex-Dream-Skin/tree/main/windows/assets/#${WINDOWS_ASSET_TOKEN}#g" \
    -e "s#windows/assets/#${WINDOWS_ASSET_URL}#g" \
    -e "s#${WINDOWS_ASSET_TOKEN}#${WINDOWS_ASSET_URL}#g" \
    "$file" > "$temporary"
  /bin/mv "$temporary" "$file"
done

for file in "$DOCS_TARGET"/*.md; do
  if /usr/bin/grep -E -q 'macos/(presets|assets)/|macos/NOTICE\.md' "$file"; then
    printf 'Standalone prompt guide retains a repository-only macOS path: %s\n' "$file" >&2
    exit 1
  fi
done
NOTICE="$ARCHIVE_ROOT/NOTICE.md"
if /usr/bin/grep -E -q '`\.\./(docs|windows)/' "$NOTICE"; then
  printf 'Standalone NOTICE retains a parent-repository path: %s\n' "$NOTICE" >&2
  exit 1
fi
