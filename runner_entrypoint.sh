#!/bin/bash

TOKEN_RESPONSE=$(curl -fsS -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_PAT}" \
    "https://api.github.com/orgs/${GITHUB_ORG}/actions/runners/registration-token" | jq -r '.token')

~/config.sh \
    --unattended \
    --name "${RUNNER_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --url "https://github.com/${GITHUB_ORG}" \
    --token "${TOKEN_RESPONSE}" \
    --replace

~/run.sh
