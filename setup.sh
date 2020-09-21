#!/bin/sh

# Mise en place des variables d environnement
eval $(minikube docker-env)

# Suppression des donnees preexistante
sh delete.sh

# Installation metallb
kubectl apply -f srcs/metallb/namespace.yaml
kubectl apply -f srcs/metallb/metallb-manif.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# Application du yaml de metallb
kubectl apply -f srcs/metallb/metallb.yaml

# Application et build du yaml de nginx
docker build -t services-nginx srcs/nginx/.
kubectl apply -f srcs/nginx/nginx.yaml
