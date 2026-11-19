#!/usr/bin/env bash
set -euo pipefail
: "${RESULT_KEY:?}" "${NAME:?}" "${AGE_VERSION:?}"
ws="${GITHUB_WORKSPACE:?}"
tools="${RUNNER_TEMP:?}/age"
mkdir -p "$ws/out" "$ws/upload" "$tools"
base="https://github.com/FiloSottile/age/releases/download/v$AGE_VERSION/age-v$AGE_VERSION"
case "$(uname -s)" in
  Darwin) curl -fsSL "$base-darwin-arm64.tar.gz" | tar -xz -C "$tools" ;;
  Linux) curl -fsSL "$base-linux-amd64.tar.gz" | tar -xz -C "$tools" ;;
  *) curl -fsSL -o "$tools/age.zip" "$base-windows-amd64.zip" && unzip -q -o "$tools/age.zip" -d "$tools" ;;
esac
tar -C "$ws" -czf - out | "$tools/age/age" -r "$RESULT_KEY" -o "$ws/upload/$NAME.tar.gz.age"
echo "packed: $(wc -c < "$ws/upload/$NAME.tar.gz.age") bytes"
