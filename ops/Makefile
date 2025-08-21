SHELL := /bin/bash
CLUSTER := k3s-gitops
K3D := k3d

.PHONY: up down ctx argo-pass sync-root portfw

up:
	$(K3D) cluster create $(CLUSTER) \
		--servers 1 --agents 1 \
		--port "80:80@loadbalancer" --port "443:443@loadbalancer" \
		--k3s-arg "--disable=traefik@server:0"
	kubectl cluster-info
	../cluster/bootstrap.sh

down:
	$(K3D) cluster delete $(CLUSTER)

ctx:
	kubectl config use-context k3d-$(CLUSTER)

argo-pass:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo

sync-root:
	kubectl -n argocd apply -f ../apps/root/application-root.yaml

portfw:
	@echo "If you need quick access before ingress is ready:"
	@echo "kubectl -n argocd port-forward svc/argocd-server 8080:80"

