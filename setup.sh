#!/bin/bash


function dashboard {
  minikube dashboard
}


function clean {
  kubectl delete --all deployments
  kubectl delete --all pods
  kubectl delete --all services
  kubectl delete --all pvc
  kubectl delete --all secrets
  kubectl delete --all pv
}


function delete {
  clean
  minikube stop
  minikube delete
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


function setup_mysql {
  docker build -t services-mysql srcs/mysql/.
  kubectl apply -f srcs/mysql/mysql.yaml
}


function setup_wp {
    docker build -t service-wp ./srcs/wordpress/.
    #kubectl apply -f ./srcs/wordpress/wordpress-deployment.yaml
    kubectl apply -k ./
}


function restart {

  # Suppression des donnees preexistante
  clean

  start
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

  # Application et build du yaml de wp
  setup_wp
}


function lunch {
  minikube start --driver=virtualbox
  start
}

case "$1" in
  "")
    lunch
    ;;
  start)
    start
    ;;
  restart)
    restart
    ;;
  clean)
    clean
    ;;
  delete)
    delete
    ;;
  dashboard)
    dashboard
    ;;
esac