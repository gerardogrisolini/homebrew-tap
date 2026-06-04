#!/usr/bin/env bash
set -euo pipefail

# update-formula.sh — update the Homebrew formula after a new release
#
# Usage: ./update-formula.sh <version>
# Example: ./update-formula.sh 0.1.0

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 0.1.0"
    exit 1
fi

VERSION="${1#v}"
if [ -z "$VERSION" ]; then
    echo "Error: version cannot be empty" >&2
    exit 1
fi

TAG="v${VERSION}"
REPO="gerardogrisolini/mlx-server"
FORMULA="Formula/mlx-server.rb"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${TAG}/mlx-server-${TAG}-macos-arm64.tar.gz"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
FORMULA_PATH="${SCRIPT_DIR}/${FORMULA}"

if [ ! -f "$FORMULA_PATH" ]; then
    echo "Error: formula not found at ${FORMULA_PATH}" >&2
    exit 1
fi

echo "Updating formula to ${TAG}..."

# Download and compute SHA256
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

echo "Downloading ${DOWNLOAD_URL}..."
curl --fail --silent --show-error --location "$DOWNLOAD_URL" -o "$TMPFILE"

SHA256=$(shasum -a 256 "$TMPFILE" | awk '{print $1}')
echo "SHA256: ${SHA256}"

ruby - "$FORMULA_PATH" "$DOWNLOAD_URL" "$SHA256" <<'RUBY'
path, download_url, sha256 = ARGV
formula = File.read(path)

unless formula.sub!(/^(\s*)url ".*"$/) { "#{$1}url \"#{download_url}\"" }
  abort "Error: url stanza not found in #{path}"
end

unless formula.sub!(/^(\s*)sha256 ".*"$/) { "#{$1}sha256 \"#{sha256}\"" }
  abort "Error: sha256 stanza not found in #{path}"
end

File.write(path, formula)
RUBY

echo "Formula updated: ${FORMULA_PATH}"

if [ "${CI:-}" != "true" ]; then
    echo ""
    echo "Next steps:"
    echo "  cd ${SCRIPT_DIR}"
    echo "  git add ${FORMULA}"
    echo "  git commit -m \"Update mlx-server to ${TAG}\""
    echo "  git push"
fi
