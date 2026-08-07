#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

IPA_PATH="$PROJECT_ROOT/build/ios/ipa/*.ipa"
EXPORT_OPTIONS="$PROJECT_ROOT/ios/ExportOptions-AdHoc.plist"

if [[ -z "${DIAWI_TOKEN:-}" ]]; then
  echo "Error: DIAWI_TOKEN is not set."
  echo 'Run: export DIAWI_TOKEN="your-token"'
  exit 1
fi

if [[ ! -f "$EXPORT_OPTIONS" ]]; then
  echo "Error: Missing $EXPORT_OPTIONS"
  exit 1
fi

echo "Cleaning Flutter project..."
flutter clean

echo "Getting dependencies..."
flutter pub get


echo "Building signed Ad Hoc IPA..."
flutter build ipa \
  --release \
  --export-options-plist="$EXPORT_OPTIONS"

IPA_FILE=$(find "$PROJECT_ROOT/build/ios/ipa" -maxdepth 1 -type f -name "*.ipa" | head -n 1)

if [[ -z "$IPA_FILE" ]]; then
  echo "Error: IPA was not generated."
  exit 1
fi

echo "IPA generated:"
echo "$IPA_FILE"

echo "Uploading IPA to Diawi..."

UPLOAD_RESPONSE=$(
  curl --silent --show-error \
    --request POST "https://upload.diawi.com/" \
    --form "token=$DIAWI_TOKEN" \
    --form "file=@$IPA_FILE"
)

echo "Diawi upload response:"
echo "$UPLOAD_RESPONSE"

JOB_ID=$(echo "$UPLOAD_RESPONSE" | sed -n 's/.*"job":"\([^"]*\)".*/\1/p')

if [[ -z "$JOB_ID" ]]; then
  echo "Error: Could not obtain Diawi job ID."
  echo "Check the Diawi response above."
  exit 1
fi

echo "Diawi job ID: $JOB_ID"
echo "Waiting for Diawi to process the IPA..."

for ATTEMPT in {1..30}; do
  STATUS_RESPONSE=$(
    curl --silent --show-error \
      "https://upload.diawi.com/status?token=$DIAWI_TOKEN&job=$JOB_ID"
  )

  echo "Status response:"
  echo "$STATUS_RESPONSE"

  DIAWI_LINK=$(echo "$STATUS_RESPONSE" | sed -n 's/.*"link":"\([^"]*\)".*/\1/p')

  if [[ -n "$DIAWI_LINK" ]]; then
    echo
    echo "Deployment completed successfully."
    echo "Install link:"
    echo "$DIAWI_LINK"
    exit 0
  fi

  sleep 5
done

echo "Error: Diawi did not finish processing within the expected time."
exit 1