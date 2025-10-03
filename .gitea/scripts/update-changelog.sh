#!/bin/bash

DEFAULT_GITEA_SERVER_URL="${GITHUB_SERVER_URL:-"https://gitea.com"}"
DEFAULT_GITEA_REPOSITORY="${GITHUB_REPOSITORY:-"gitea/helm-gitea"}"
DEFAULT_GITEA_TOKEN="${ISSUE_RW_TOKEN:-""}"

if [ -z "${1}" ]; then
  read -p "Enter hostname of the Gitea instance [${DEFAULT_GITEA_SERVER_URL}]: " CURRENT_GITEA_SERVER_URL
  if [ -z "${CURRENT_GITEA_SERVER_URL}" ]; then
    CURRENT_GITEA_SERVER_URL="${DEFAULT_GITEA_SERVER_URL}"
  fi
else
  CURRENT_GITEA_SERVER_URL=$1
fi

if [ -z "${2}" ]; then
  read -p "Enter name of the git repository [${DEFAULT_GITEA_REPOSITORY}]: " CURRENT_GITEA_REPOSITORY
  if [ -z "${CURRENT_GITEA_REPOSITORY}" ]; then
    CURRENT_GITEA_REPOSITORY="${DEFAULT_GITEA_REPOSITORY}"
  fi
else
  CURRENT_GITEA_REPOSITORY=$2
fi

if [ -z "${3}" ]; then
  read -p "Enter token to access the Gitea instance [${DEFAULT_GITEA_TOKEN}]: " CURRENT_GITEA_TOKEN
  if [ -z "${CURRENT_GITEA_TOKEN}" ]; then
    CURRENT_GITEA_TOKEN="${DEFAULT_GITEA_TOKEN}"
  fi
else
  CURRENT_GITEA_TOKEN=$3
fi

if ! git sv rn -o /tmp/changelog.md; then
  echo "ERROR: Failed to generate /tmp/changelog.md" 1>&2
  exit 1
fi

CURL_ARGS=(
  "--data-urlencode" "q=Changelog for upcoming version"
  # "--data-urlencode=\"q=Changelog for upcoming version\""
  "--data-urlencode" "state=open"
  "--fail"
  "--header" "Accept: application/json"
  "--header" "Authorization: token ${CURRENT_GITEA_TOKEN}"
  "--request" "GET"
  "--silent"
)

if ! ISSUE_NUMBER="$(curl "${CURL_ARGS[@]}" "${CURRENT_GITEA_SERVER_URL}/api/v1/repos/${CURRENT_GITEA_REPOSITORY}/issues" | jq '.[].number')"; then
  echo "ERROR: Failed query issue number" 1>&2
  exit 1
fi
export ISSUE_NUMBER

if ! echo "" | jq --raw-input --slurp --arg title "Changelog for upcoming version" --arg body "$(cat /tmp/changelog.md)" '{title: $title, body: $body}' 1> /tmp/payload.json; then
  echo "ERROR: Failed to create JSON payload file" 1>&2
  exit 1
fi

CURL_ARGS=(
  "--data" "@/tmp/payload.json"
  "--fail"
  "--header" "Authorization: token ${CURRENT_GITEA_TOKEN}"
  "--header" "Content-Type: application/json"
  "--location"
  "--silent"
  "--output" "/dev/null"
)

if [ -z "${ISSUE_NUMBER}" ]; then
  if ! curl "${CURL_ARGS[@]}" --request POST "${CURRENT_GITEA_SERVER_URL}/api/v1/repos/${CURRENT_GITEA_REPOSITORY}/issues"; then
    echo "ERROR: Failed to create new issue!" 1>&2
    exit 1
  else
    echo "INFO: Successfully created new issue!"
  fi
else
  if ! curl "${CURL_ARGS[@]}" --request PATCH "${CURRENT_GITEA_SERVER_URL}/api/v1/repos/${CURRENT_GITEA_REPOSITORY}/issues/${ISSUE_NUMBER}"; then
    echo "ERROR: Failed to update issue with ID ${ISSUE_NUMBER}!" 1>&2
    exit 1
  else
    echo "INFO: Successfully updated existing issue with ID ${ISSUE_NUMBER}!"
    echo "INFO: ${CURRENT_GITEA_SERVER_URL}/${CURRENT_GITEA_REPOSITORY}/issues/${ISSUE_NUMBER}"
  fi
fi
