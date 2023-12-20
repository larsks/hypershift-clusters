#!/bin/bash

RELEASE_IMAGE="quay.io/openshift-release-dev/ocp-release@sha256:0ec9d715c717b2a592d07dd83860013613529fae69bc9eecb4b2d4ace679f6f3"

if (( $# < 2 )); then
	echo "$0: usage: $0 cluster_name cluster_domain" >&2
	exit 2
fi

CLUSTER_NAME=$1
CLUSTER_DOMAIN=$2
shift 2

CLUSTER_NAMESPACE=clusters-${CLUSTER_NAME}
API_ADDRESS=api.${CLUSTER_NAME}.${CLUSTER_DOMAIN}

# Due to a bug in the hcp cli, the namespace must exist first (even if
# we're using --render).
kubectl get namespace "${CLUSTER_NAMESPACE}" > /dev/null 2> /dev/null ||
	kubectl create namespace "${CLUSTER_NAMESPACE}"

hcp create cluster agent \
	--agent-namespace "${CLUSTER_NAMESPACE}" \
	--base-domain "${CLUSTER_DOMAIN}" \
	--name "${CLUSTER_NAME}" \
	--api-server-address "${API_ADDRESS}" \
	--pull-secret pull-secret.txt \
	--ssh-key id_rsa.pub \
	--release-image "${RELEASE_IMAGE}" \
	"$@"
