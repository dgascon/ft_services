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
  kubectl apply -f srcs/nginx/nginx-service.yaml
  kubectl apply -f srcs/nginx/nginx-deployment.yaml
}

function setup_mysql {
  docker build -t services-mysql srcs/mysql/.
  kubectl apply -f srcs/mysql/mysql-pv.yaml
  kubectl apply -f srcs/mysql/mysql-pvc.yaml
  kubectl apply -f srcs/mysql/mysql-service.yaml
  kubectl apply -f srcs/mysql/mysql-deployment.yaml
}

function restart {
  # Mise en place des variables d environnement
  eval "$(minikube docker-env)"

  # Suppression des donnees preexistante
  delete

  # Installation metallb and Application du yaml de metallb
  setup_metallb

  # Application et build du yaml de nginx
  setup_nginx

  # Application et build du yaml de mysql
  setup_mysql
}

function start {

  # Mise en place des variables d environnement
  eval "$(minikube docker-env)"

  # Installation metallb and Application du yaml de metallb
  setup_metallb

  # Application et build du yaml de nginx
  setup_nginx

  # Application et build du yaml de mysql
  setup_mysql
}

case "$1" in
  "")
    start
    ;;
  start)
    start
    ;;
  restart)
    restart
    ;;
  delete)
    delete
    ;;
  dashboard)
    ;;
esac