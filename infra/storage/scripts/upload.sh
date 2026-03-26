#!/usr/bin/env bash
set -euo pipefail

REGION="fr-par"

if [[ $# -lt 3 ]]; then
	echo "Usage: $0 <bucket> <local-path> <remote-prefix>"
	echo "Examples:"
	echo "  $0 my-bucket ./photos/brutalist-towers series/brutalist-towers"
	echo "  $0 my-bucket ./photo.jpg series/brutalist-towers"
	exit 1
fi

BUCKET="$1"
LOCAL_PATH="$2"
REMOTE_PREFIX="$3"

if [[ ! -e "$LOCAL_PATH" ]]; then
	echo "Error: '$LOCAL_PATH' does not exist"
	exit 1
fi

S3CMD_OPTS=(
	--add-header="Cache-Control: public, max-age=31536000, immutable"
	--no-preserve
	--human-readable-sizes
	--host="s3.${REGION}.scw.cloud"
	--host-bucket="%(bucket)s.s3.${REGION}.scw.cloud"
)

if [[ -n "${AWS_ACCESS_KEY_ID:-}" ]]; then
	S3CMD_OPTS+=(--access_key="${AWS_ACCESS_KEY_ID}")
fi
if [[ -n "${AWS_SECRET_ACCESS_KEY:-}" ]]; then
	S3CMD_OPTS+=(--secret_key="${AWS_SECRET_ACCESS_KEY}")
fi

if [[ -f "$LOCAL_PATH" ]]; then
	FILENAME="$(basename "$LOCAL_PATH")"
	REMOTE_URL="s3://${BUCKET}/${REMOTE_PREFIX}/${FILENAME}"
	echo "Uploading ${LOCAL_PATH} → ${REMOTE_URL}"
	echo ""
	s3cmd put "${S3CMD_OPTS[@]}" "$LOCAL_PATH" "$REMOTE_URL"
	echo ""
	echo "Done. Image available at:"
	echo "  https://${BUCKET}.s3.${REGION}.scw.cloud/${REMOTE_PREFIX}/${FILENAME}"
else
	echo "Uploading ${LOCAL_PATH}/ → s3://${BUCKET}/${REMOTE_PREFIX}/"
	echo ""
	s3cmd sync "${S3CMD_OPTS[@]}" \
		--exclude=".*" \
		--exclude="*.DS_Store" \
		--include="*.jpg" \
		--include="*.jpeg" \
		--include="*.png" \
		--include="*.webp" \
		--include="*.avif" \
		"$LOCAL_PATH/" "s3://${BUCKET}/${REMOTE_PREFIX}/"
	echo ""
	echo "Done. Images available at:"
	echo "  https://${BUCKET}.s3.${REGION}.scw.cloud/${REMOTE_PREFIX}/"
fi
