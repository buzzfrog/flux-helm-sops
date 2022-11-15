#!/bin/bash
set -e

info()
{
    echo '[INFO] ' "$@"
}

warn()
{
    echo '[WARN] ' "$@" >&2
}

fatal()
{
    echo '[ERROR] ' "$@" >&2
    exit 1
}

SOURCE_REPO=https://github.com/buzzfrog/flux-helm-sops
SOURCE_BRANCH=main
KUSTOMIZE_FOLDER=./clusters/cluster1/app1

# create cluster
info "Create a new Kind cluster..."
kind delete cluster 
kind create cluster --config ./manifests/cluster-config.yaml

flux install

kubectl create namespace flux-workspace

flux create source git source-repository \
    --url=$SOURCE_REPO \
    --namespace flux-workspace \
    --branch=main \
    --interval=1m

flux create kustomization cluster \
    --path=./clusters/cluster1/app1 \
    --source=source-repository \
    --namespace flux-workspace \
    --prune=true \
    --interval=1m
