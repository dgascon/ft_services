# Mise en place des variables d environnement
eval $(minikube docker-env)

# Suppression des donnees preexistante
sh delete.sh

# Installation metallb
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

# Application du yaml de metallb
kubectl apply -f srcs/metallb/metallb.yaml

# Application et build du yaml de nginx
docker build -t services-nginx srcs/nginx/.
kubectl apply -f srcs/nginx/nginx.yaml
