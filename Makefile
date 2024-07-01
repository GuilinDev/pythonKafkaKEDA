.PHONY: up install configure helm-install helm-install-services helm-install-deployments clean create-namespace

up: clean configure create-namespace helm-install

clean:
	@echo "Uninstalling any existing Helm release..."
	helm uninstall kafka-setup || true
	@echo "Deleting all resources in the kafka namespace..."
	kubectl delete all --all -n kafka || true
	@echo "Deleting namespace kafka if it exists..."
	kubectl delete namespace kafka --ignore-not-found

configure:
	@echo "Configuring kubectl to use MicroK8s..."
	alias kubectl='microk8s kubectl'
	microk8s kubectl config view --raw > ~/.kube/config
	kubectl config get-contexts
	kubectl config use-context microk8s

create-namespace:
	@echo "Creating namespace kafka with Helm annotations..."
	kubectl create namespace kafka --dry-run=client -o yaml | kubectl apply -f -
	kubectl label namespace kafka app.kubernetes.io/managed-by=Helm --overwrite
	kubectl annotate namespace kafka meta.helm.sh/release-name=kafka-setup --overwrite
	kubectl annotate namespace kafka meta.helm.sh/release-namespace=default --overwrite

helm-install: helm-install-services helm-install-deployments

helm-install-services:
	@echo "Installing Helm chart services..."
	helm template kafka-setup ./kafka-setup --include-crds --set onlyInstallServices=true | kubectl apply -f -

helm-install-deployments:
	@echo "Installing Helm chart deployments..."
	helm template kafka-setup ./kafka-setup --set onlyInstallServices=false | kubectl apply -f -
