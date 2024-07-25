
.EXPORT_ALL_VARIABLES:
# https://github.com/k3d-io/k3d/pull/1268
K3D_FIX_MOUNTS=1
# https://github.com/k3d-io/k3d/issues/209
# K3D_FIX_DNS=1


.PHONY: create-k3d
create-k3d:
	#./create_cluster.sh
	k3d cluster create -c k3d-cluster.yaml

.PHONY: delete-k3d
delete-k3d:
	k3d cluster delete picluster

.PHONY: create-kind
create-kind:
	kind create cluster --config kind-cluster.yaml
	kubectl label node/picluster-control-plane node-role.kubernetes.io/master=true

.PHONY: delete-kind
delete-kind:
	kind delete cluster -n picluster

.PHONY: crds-install
crds-install:
	kubectl kustomize --enable-helm --load-restrictor=LoadRestrictionsNone \
	   ./kubernetes/infrastructure/crds/overlays/dev | kubectl apply --server-side -f - 

.PHONY: helm-setup
helm-setup:
	helm repo add cilium https://helm.cilium.io/
	helm repo update
	
.PHONY: cilium-install-helm
cilium-install-helm:
	helm install cilium cilium/cilium --namespace kube-system -f cilium-values.yaml

.PHONY: cilium-config
cilium-config:
	kubectl kustomize --enable-helm --load-restrictor=LoadRestrictionsNone \
	   ./kubernetes/infrastructure/cilium-config/overlays/dev | kubectl apply -f -

.PHONY: flux-cli-install
flux-cli-install:
	curl -s https://fluxcd.io/install.sh | sudo bash

.PHONY: flux-cli-bootstrap
flux-cli-bootstrap:
	flux bootstrap github \
		--token-auth \
		--owner=ricsanfre \
		--repository=fluxcd-test \
		--branch=master \
		--path=kubernetes/clusters/dev \
		--personal


.PHONY: cluster-bootstrap
cluster-bootstrap:
	kubectl kustomize --enable-helm --load-restrictor=LoadRestrictionsNone \
	   ./kubernetes/clusters/bootstrap | kubectl apply -f -

.PHONY: flux-bootstrap
flux-bootstrap:
	kubectl kustomize --enable-helm --load-restrictor=LoadRestrictionsNone \
	   ./kubernetes/clusters/dev/flux-system | kubectl apply -f -