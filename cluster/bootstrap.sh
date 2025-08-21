#!/usr/bin/env bash
set -euo pipefail

kubectl create ns argocd || true

helm repo add argo https://argoproj.github.io/argo-helm >/dev/null
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null
helm repo add linkerd https://helm.linkerd.io/stable >/dev/null
helm repo add podinfo https://stefanprodan.github.io/podinfo >/dev/null
helm repo update >/dev/null

# Install Argo CD (let ingress-nginx front it later)
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --version 6.7.17 \
  --values - <<'YAML'
server:
  extraArgs: ["--insecure"]
  service:
    type: ClusterIP
dex:
  enabled: false
configs:
  params:
    server.insecure: "true"
YAML

echo "Argo CD installed. Now apply the root app (make sync-root) once ingress-nginx app is committed."

