#!/usr/bin/env bash
set -euo pipefail

ZIP_FILE_NAME="$1"
VERSION="$2"
LAMBDA_ARTIFACTS_BUCKET="$3"
FILE_NAME="$4"

S3_KEY="list-s3-contents-$VERSION-$ZIP_FILE_NAME.zip"

if aws s3 ls s3://$LAMBDA_ARTIFACTS_BUCKET/$S3_KEY; then
  echo "Artifact $S3_KEY already exists. Skipping build."
else
  echo "Building package for version $VERSION"
  cd app
  zip -r ../$ZIP_FILE_NAME.zip $FILE_NAME
  cd ..
  aws s3 cp $ZIP_FILE_NAME.zip s3://$LAMBDA_ARTIFACTS_BUCKET/$S3_KEY
fi
