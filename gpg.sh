#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"

gpgconf --kill all
gpgconf --kill gpg-agent
rm ~/.gnupg/public-keys.d/pubring.db.lock
gpgconf --launch gpg-agent
echo "test" | gpg --clearsign