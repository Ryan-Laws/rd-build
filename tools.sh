#!/usr/bin/env bash
set -euo pipefail
: "${AGE_VERSION:?}"
tools="${RUNNER_TEMP:?}/age"
[ ! -x "$tools/age/age" ] && [ ! -x "$tools/age/age.exe" ] || exit 0
mkdir -p "$tools"
base="https://github.com/FiloSottile/age/releases/download/v$AGE_VERSION/age-v$AGE_VERSION"
case "$(uname -s)" in
  Darwin) curl -fsSL "$base-darwin-arm64.tar.gz" | tar -xz -C "$tools" ;;
  Linux) curl -fsSL "$base-linux-amd64.tar.gz" | tar -xz -C "$tools" ;;
  *) curl -fsSL -o "$tools/age.zip" "$base-windows-amd64.zip" && unzip -q -o "$tools/age.zip" -d "$tools" ;;
esac
