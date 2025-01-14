#!/usr/bin/env bash

# standard bash error handling
set -o nounset  # treat unset variables as an error and exit immediately.
set -o errexit  # exit immediately when a command fails.
set -E          # needs to be set if we want the ERR trap
set -o pipefail # prevents errors in a pipeline from being masked
set -x

RELEASE_TAG=$1
RELEASE_ID=$2

IMG="europe-docker.pkg.dev/kyma-project/prod/istio-manager:${RELEASE_TAG}" make generate-manifests

REPOSITORY=${REPOSITORY:-kyma-project/istio}
GITHUB_URL=https://uploads.github.com/repos/${REPOSITORY}
GITHUB_AUTH_HEADER="Authorization: Bearer ${GITHUB_TOKEN}"

curl -f -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "${GITHUB_AUTH_HEADER}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @"istio-manager.yaml" \
  ${GITHUB_URL}/releases/${RELEASE_ID}/assets?name=istio-manager.yaml

curl -f -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "${GITHUB_AUTH_HEADER}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/octet-stream" \
  --data-binary @"config/samples/operator_v1alpha2_istio.yaml" \
  ${GITHUB_URL}/releases/${RELEASE_ID}/assets?name=istio-default-cr.yaml
