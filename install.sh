#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SKILL_NAME="devit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_SRC="$SCRIPT_DIR/skills/$SKILL_NAME"
SKILL_DEST="$SKILLS_DIR/$SKILL_NAME"

# Verify source exists
if [ ! -d "$SKILL_SRC" ]; then
  echo "Error: skill source not found at $SKILL_SRC" >&2
  exit 1
fi

# Create skills directory if needed
mkdir -p "$SKILLS_DIR"

# Remove existing install (symlink or directory)
if [ -L "$SKILL_DEST" ] || [ -d "$SKILL_DEST" ]; then
  rm -rf "$SKILL_DEST"
fi

# Symlink so git pull updates are picked up automatically
ln -s "$SKILL_SRC" "$SKILL_DEST"

echo ""
echo "  devit installed successfully"
echo ""
echo "  Skill location: $SKILL_DEST -> $SKILL_SRC"
echo ""
echo "  Open a new Claude Code session and run /devit to get started."
echo ""
