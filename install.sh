#!/usr/bin/env bash
set -euo pipefail

# Cognitive Night installer — copies skills and agents into your Claude Code user directory.
# Override the destination with CLAUDE_DIR=/path ./install.sh

DEST="${CLAUDE_DIR:-$HOME/.claude}"
SRC="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$DEST/skills" "$DEST/agents"

for skill in "$SRC"/skills/*/; do
  name="$(basename "$skill")"
  if [ -d "$DEST/skills/$name" ]; then
    echo "skip  skills/$name (already installed — remove it first to update)"
  else
    cp -R "$skill" "$DEST/skills/$name"
    echo "ok    skills/$name"
  fi
done

for agent in "$SRC"/agents/*.md; do
  name="$(basename "$agent")"
  if [ -f "$DEST/agents/$name" ]; then
    echo "skip  agents/$name (already installed — remove it first to update)"
  else
    cp "$agent" "$DEST/agents/$name"
    echo "ok    agents/$name"
  fi
done

echo
echo "Done. Skills register automatically in Claude Code:"
echo "  /fable-mindset  /orchestration  /loop-engineering  + 'verifier' agent"
