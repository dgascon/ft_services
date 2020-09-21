#!/bin/bash


function dashboard {
  minikube dashboard
}


function delete {
  kubectl delete --all deployments
  kubectl delete --all pods
  kubectl delete --all services
  kubectl delete --all pvc
}

function setup_metallb {

  kubectl apply -f srcs/metallb/namespace.yaml
  kubectl apply -f srcs/metallb/metallb-manif.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f srcs/metallb/metallb.yaml
}

function setup_nginx {
  docker build -t services-nginx srcs/nginx/.
  kubectl apply -f srcs/nginx/nginx.yaml
}

function setup {

  # Mise en place des variables d environnement
  eval $(minikube docker-env)

  # Suppression des donnees preexistante
  delete

  # Installation metallb and Application du yaml de metallb
  setup_metallb

  # Application et build du yaml de nginx
  setup_nginx
}


if [ "$1" == "dashboard" ]
then
  dashboard
elif [ "$1" == "start" ] || [ -z "$1" ]
then
  setup
elif [ "$1" == "delete" ]
then
  delete
fi
