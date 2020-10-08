#!/bin/bash

SERVICES=(nginx phpmyadmin wordpress grafana)


function @log() {
  echo -e "\033[33mExecute function \033[34m$* \033[0m" | tr '_' ' '
  if [[ "$DEBUG" == 'False' ]]; then
    eval "$*" 1>/dev/null
  elif [[ "$DEBUG" == 'True' ]]; then
    eval "$*"
  fi
  echo -e "\033[32mFunction \033[34m$* \033[32mdone \033[0m "
  if [ "$#" -ge 2 ]
    then
      TRUC+=$(kubectl get service "$2"-service | grep 'service' | awk 'length($4)>6{ printf "%s : %s:21\n", $1, $4}')
  fi
}

function clean() {
  for service in ${SERVICES[*]}; do
    clean_service "$service";
  done
  clean_service ftps
  clean_service mysql
  clean_service influxdb
  clean_metallb
  (kubectl delete --all pvc &)
  (kubectl delete --all secrets &)
  (kubectl delete --all pv &)
}

function clean_service() {
  if [[ "$DEBUG" == 'True' ]]; then
    (kubectl delete --wait=False deployment "$1" &)
  else
    (kubectl delete deployment "$1" &)
  fi
  (kubectl delete service "$1"-service &)
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
  sed -e "s/IP_START/$MINIKUBE_START/g;s/IP_END/$MINIKUBE_END/g" srcs/metallb/template/template_metallb.tpl > srcs/metallb/metallb.yaml
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
  @log setup ftps
  (@log setup mysql &)
  (@log setup influxdb &)

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
  sed -i -e "s/pasv_address=.*/pasv_address=$MINIKUBE_START/g" ./srcs/ftps/srcs/vsftpd.conf
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
  kubectl get service ftps-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | ftps://%s:21\n", $1, $4}'
  kubectl get service nginx-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | http://%s:80\n", $1, $4}'
  kubectl get service nginx-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | https://%s:443\n", $1, $4}'
  kubectl get service nginx-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | ssh www@%s -p %s\n", $1, $4, 22}'
  kubectl get service grafana-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | http://%s:3000\n", $1, $4}'
  kubectl get service phpmyadmin-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | http://%s:5000\n", $1, $4}'
  kubectl get service wordpress-service | grep 'service' | awk 'length($4)>6{ printf "%-20s | http://%s:5050\n", $1, $4}'
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
test)
  @log "chevre"
  ;;
esac
