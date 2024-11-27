#!/bin/bash

NAMESPACE="formazione-sou"
DEPLOYMENT_NAME="formazione-sou-deployment"

# Recupera il deployment in formato JSON
DEPLOYMENT=$(kubectl get deployment $DEPLOYMENT_NAME -n $NAMESPACE -o json)

# Controlla liveness probe
LIVENESS_PROBE=$(echo $DEPLOYMENT | jq '.spec.template.spec.containers[0].livenessProbe' | grep -v null)
READINESS_PROBE=$(echo $DEPLOYMENT | jq '.spec.template.spec.containers[0].readinessProbe' | grep -v null)
RESOURCE_REQUESTS=$(echo $DEPLOYMENT | jq '.spec.template.spec.containers[0].resources.requests' | grep -v null)
RESOURCE_LIMITS=$(echo $DEPLOYMENT | jq '.spec.template.spec.containers[0].resources.limits' | grep -v null)

MISSING=""

if [ -z "$LIVENESS_PROBE" ]; then
  MISSING+="Liveness Probe, "
fi
if [ -z "$READINESS_PROBE" ]; then
  MISSING+="Readiness Probe, "
fi
if [ -z "$RESOURCE_REQUESTS" ]; then
  MISSING+="Resource Requests, "
fi
if [ -z "$RESOURCE_LIMITS" ]; then
  MISSING+="Resource Limits, "
fi

if [ -n "$MISSING" ]; then
  echo "ERROR: Deployment '$DEPLOYMENT_NAME' is missing: ${MISSING%, }"
  exit 1
else
  echo "SUCCESS: Deployment '$DEPLOYMENT_NAME' meets all best practices."
  exit 0
fi
