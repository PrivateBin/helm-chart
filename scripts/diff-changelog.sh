#!/usr/bin/env bash

TARGET_BRANCH=${1:-${GITHUB_BASE_REF}}

CHANGELOG_DIFF=$(git diff --no-color "origin/${TARGET_BRANCH}" -- CHANGELOG.md)

if [ -z "$CHANGELOG_DIFF" ]; then
  echo "No changes in CHANGELOG.md"
  echo "::warning ::no changes in CHANGELOG.md"
  # exit 0
else
  CHANGELOG_DIFF="${CHANGELOG_DIFF//'%'/'%25'}"
  CHANGELOG_DIFF="${CHANGELOG_DIFF//$'\n'/'%0A'}"
  CHANGELOG_DIFF="${CHANGELOG_DIFF//$'\r'/'%0D'}"

  echo "::set-output name=diff::$( echo "$CHANGELOG_DIFF")"
fi
