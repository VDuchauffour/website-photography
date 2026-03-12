#!/usr/bin/env bash
set -euo pipefail

# Requires: s3cmd configured for Scaleway
#
# Setup (one-time):
#   scw object config install type=s3cmd
#
# Usage:
#   ./upload.sh <local-dir> <remote-prefix>
#   ./upload.sh ./photos/brutalist-towers gallery/brutalist-towers

BUCKET="photos"
REGION="fr-par"

if [[ $# -lt 2 ]]; then
	echo "Usage: $0 <local-directory> <remote-prefix>"
	echo "Example: $0 ./photos/brutalist-towers gallery/brutalist-towers"
	exit 1
fi

LOCAL_DIR="$1"
REMOTE_PREFIX="$2"

if [[ ! -d "$LOCAL_DIR" ]]; then
	echo "Error: directory '$LOCAL_DIR' does not exist"
	exit 1
fi

echo "Uploading ${LOCAL_DIR} → s3://${BUCKET}/${REMOTE_PREFIX}/"
echo ""

s3cmd sync "$LOCAL_DIR/" "s3://${BUCKET}/${REMOTE_PREFIX}/" \
	--acl-public \
	--add-header="Cache-Control: public, max-age=31536000, immutable" \
	--exclude=".*" \
	--exclude="*.DS_Store" \
	--include="*.jpg" \
	--include="*.jpeg" \
	--include="*.png" \
	--include="*.webp" \
	--include="*.avif" \
	--no-preserve \
	--human-readable-sizes

echo ""
echo "Done. Images available at:"
echo "  https://${BUCKET}.s3.${REGION}.scw.cloud/${REMOTE_PREFIX}/"
