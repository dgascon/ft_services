#!/bin/bash

SERVICES=(nginx mysql phpmyadmin)

function @log() {
  echo "Execute function $*" | tr '_' ' '
  if [[ "$DEBUG" == 'False' ]]; then
    eval "$*" 1>/dev/null
  elif [[ "$DEBUG" == 'True' ]]; then
    eval "$*"
  fi
    echo "Function $2 done"
}

function clean() {
  for service in ${SERVICES[*]}; do
    clean_service "$service";
  done
  clean_metallb
  kubectl delete --all pvc
  kubectl delete --all secrets
  kubectl delete --all pv
}

function clean_service() {
  if [[ "$DEBUG" == 'True' ]]; then
    kubectl delete --wait=False deployment "$1"
  else
    kubectl delete deployment "$1"
  fi
  kubectl delete service "$1"-service
}

function clean_metallb() {
  if [[ "$DEBUG" == 'True' ]]; then
    kubectl delete --all --wait=False deployments -n metallb-system
    kubectl delete --all --wait=False pods -n metallb-system
  else
    kubectl delete --all deployments -n metallb-system
    kubectl delete --all pods -n metallb-system
  fi
  kubectl delete --all services -n metallb-system
  kubectl delete --all secrets -n metallb-system
}

function delete() {
  clean
  minikube stop
  minikube delete
}

function setup_metallb() {
  sed -e "s/IP_START/$MINIKUBE_START/g;s/IP_END/$MINIKUBE_END/g" srcs/metallb/template/template_metallb.yaml > srcs/metallb/metallb.yaml
  kubectl apply -f srcs/metallb/namespace.yaml
  kubectl apply -f srcs/metallb/metallb-manif.yaml
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
  kubectl apply -f srcs/metallb/metallb.yaml
}

function setup() {
  docker build -t services-"$1" srcs/"$1"/.
  kubectl apply -f srcs/"$1"/configyaml/.
}

function restart() {
  clean
  start
}

function start() {
  @log get_ip
  @log setup_metallb
  for service in ${SERVICES[*]}; do
    (@log setup "$service" &)
  done
}

function get_ip() {
  MINIKUBE_IP=$(minikube ip)
  MINIKUBE_IP_1_3=$(echo "$MINIKUBE_IP" | cut -d '.' -f 1,2,3)
  START=$(echo "$MINIKUBE_IP" | cut -d '.' -f 4)

  MINIKUBE_START="$MINIKUBE_IP_1_3".$((START + 1))
  MINIKUBE_END="$MINIKUBE_IP_1_3".254
}

MINIKUBE_IS_LUNCH=$(minikube ip | wc -l | bc)

if [[ "$MINIKUBE_IS_LUNCH" == 2 ]]; then
  minikube start --driver=virtualbox
fi

eval "$(minikube docker-env)"

if [[ "$2" == 'DEBUG=True' ]] || [[ "$2" == '-d' ]] || [[ "$2" == '--debug' ]]; then
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
ip)
  get_ip
  ;;
setup_metallb)
  @log setup_metallb
  ;;
clean_metallb)
  clean_metallb
  ;;
setup)
  @log setup "$2"
  ;;
clean_service)
  clean_service "$2"
  ;;
esac
