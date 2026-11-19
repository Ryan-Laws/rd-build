#!/usr/bin/env bash
set -euo pipefail
umask 077
: "${SRC_SSH_KEY:?}" "${SRC_REPO:?}" "${SHA:?}"
ws="${GITHUB_WORKSPACE:?}"
k="$(mktemp -d)"
printf '%s\n' "$SRC_SSH_KEY" | tr -d '\r' > "$k/id"
chmod 600 "$k/id"
export GIT_SSH_COMMAND="ssh -i $k/id -o IdentitiesOnly=yes -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=$k/known -o LogLevel=ERROR"
git init -q "$ws/src"
git -C "$ws/src" config core.autocrlf false
git -C "$ws/src" config advice.detachedHead false
git -C "$ws/src" remote add origin "git@github.com:$SRC_REPO.git"
ok=1
git -C "$ws/src" fetch -q --depth 1 origin "$SHA" >/dev/null 2>&1 || ok=0
[ "$ok" = 0 ] || git -C "$ws/src" checkout -q FETCH_HEAD >/dev/null 2>&1 || ok=0
rm -f "$k/id"
[ "$ok" = 1 ] || { echo "source: not fetched"; exit 1; }
( cd "$ws/src/rust" && rustup toolchain install ) >/dev/null 2>&1 || { echo "source: no toolchain"; exit 1; }
echo "source: ready"
