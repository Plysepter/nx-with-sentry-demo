#!/bin/bash

# Show file execution within the CI logs
set -x

SENTRY_PROJECT_ARGS=""

SENTRY_CLI=./node_modules/.bin/sentry-cli

# Get a space separated list of apps that are a part of this new release
AFFECTED_APPS=$(./node_modules/.bin/nx affected:apps --plain --base=$LAST_RELEASE --head=HEAD)

# Create sentry project args
for app in $AFFECTED_APPS
do
  # The Sentry CLI can be passed multiple projects as part of a release by passing in "-p APP_NAME" for each app
  SENTRY_PROJECT_ARGS="$SENTRY_PROJECT_ARGS -p ${app} "
done

# Create a release
$SENTRY_CLI releases -o $SENTRY_ORG new $SENTRY_PROJECT_ARGS $SENTRY_VERSION

# Sentry needs to upload the sourcemaps and commits for each app separately, so we do so in a loop
for app in $AFFECTED_APPS
do
# Associate commits
$SENTRY_CLI releases -o $SENTRY_ORG -p $app set-commits $SENTRY_VERSION --auto

# Upload source maps for each app
$SENTRY_CLI releases -o $SENTRY_ORG -p $app files \
 $SENTRY_VERSION upload-sourcemaps $SOURCEMAP_PREFIX/$app
done

# Finalize and mark the release as deployed
$SENTRY_CLI releases finalize $SENTRY_VERSION
# By passing the name as $NEW_VERSION we are linking the semantic release version to the Sentry release.
# -e Production is telling Sentry we are deploying to the Production environment. For best results make sure the string matches that of that in your apps main.ts
$SENTRY_CLI releases deploys $SENTRY_VERSION new -e Production --name $NEW_VERSION
