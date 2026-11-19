#!/usr/bin/env bash
set -euo pipefail
: "${RESULT_KEY:?}" "${NAME:?}" "${AGE_VERSION:?}"
ws="${GITHUB_WORKSPACE:?}"
tools="${RUNNER_TEMP:?}/age"
mkdir -p "$ws/out" "$ws/upload"
bash "$(dirname "${BASH_SOURCE[0]}")/tools.sh"
COPYFILE_DISABLE=1 tar -C "$ws" -czf - out | "$tools/age/age" -r "$RESULT_KEY" -o "$ws/upload/$NAME.tar.gz.age"
echo "packed: $(wc -c < "$ws/upload/$NAME.tar.gz.age") bytes"
