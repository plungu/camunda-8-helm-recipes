.PHONY: kube-kind
kube-kind:
	kind create cluster \
	  --config=$(root)/recipes/kind/include/config.yaml \
	  --name $(DEPLOYMENT_NAME)
	
#	kubectl apply -f $(root)/kind/include/ssd-storageclass-kind.yaml

.PHONY: clean-kube-kind
clean-kube-kind: use-kube
	kind delete cluster --name $(DEPLOYMENT_NAME)

.PHONY: use-kube
use-kube:
	kubectl config use-context kind-$(DEPLOYMENT_NAME)

.PHONY: kube-status
kube-status:
	kubectl get nodes -o wide
	kubectl cluster-info 