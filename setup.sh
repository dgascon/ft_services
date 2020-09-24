#!/bin/bash

function @ {
  echo "Execute function $1" | tr '_' ' '
  if [[ "$DEBUG" == 'False' ]]; then
    eval "$1 $#" 1> /dev/null
  elif [[ "$DEBUG" == 'True' ]]; then
    eval "$1 $#"
  fi
}

function clean {
  kubectl delete --all deployments
  kubectl delete --all pods
  kubectl delete --all services
  kubectl delete --all pvc
  kubectl delete --all secrets
  kubectl delete --all pv

  kubectl delete --all deployments -n metallb-system
  kubectl delete --all pods -n metallb-system
  kubectl delete --all services -n metallb-system
  kubectl delete --all secrets -n metallb-system
}


function delete {
  clean
  minikube stop
  minikube delete
}


function setup_metallb {
  sed -e "s/IP_START/$MINIKUBE_START/g;s/IP_END/$MINIKUBE_END/g" srcs/metallb/template_metallb.yaml > srcs/metallb/metallb.yaml
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


function setup_wp {
    docker build -t service-wp ./srcs/wordpress/.
    kubectl apply -f ./srcs/wordpress/srcs/wordpress.yaml
}


function restart {
  clean
  start
}


function start {
  @ get_ip
  @ setup_metallb
  @ setup_nginx
  @ setup_mysql
  @ setup_wp
}

function get_ip {
    MINIKUBE_IP=$(minikube ip)
    MINIKUBE_IP_1_3=$(echo "$MINIKUBE_IP" | cut -d '.' -f 1).$(echo "$MINIKUBE_IP" | cut -d '.' -f 2).$(echo "$MINIKUBE_IP" | cut -d '.' -f 3)
    START=$(echo "$MINIKUBE_IP" | cut -d '.' -f 4)

    MINIKUBE_START="$MINIKUBE_IP_1_3".$((START + 1))
    MINIKUBE_END="$MINIKUBE_IP_1_3".254
}

eval "$(minikube docker-env)"

MINIKUBE_IS_LUNCH=$(minikube ip | wc -l | bc)

if [[ "$MINIKUBE_IS_LUNCH" == 2 ]]; then
  minikube start --driver=virtualbox
fi

if [[ "$2" == 'DEBUG=True' ]]; then
  DEBUG='True'
else
  DEBUG='False'
fi

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
  clean)
    clean
    ;;
  delete)
    delete
    ;;
  dashboard)
    minikube dashboard
    ;;
esac