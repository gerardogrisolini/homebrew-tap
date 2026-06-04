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

VERSION="$1"
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

# Update the formula
sed -i '' "s|url \".*\"|url \"${DOWNLOAD_URL}\"|" "$FORMULA_PATH"
sed -i '' "s|sha256 \".*\"|sha256 \"${SHA256}\"|" "$FORMULA_PATH"

echo "Formula updated: ${FORMULA_PATH}"
echo ""
echo "Next steps:"
echo "  cd ${SCRIPT_DIR}"
echo "  git add ${FORMULA}"
echo "  git commit -m \"Update mlx-server to ${TAG}\""
echo "  git push"
