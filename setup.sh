#minikube start
eval $(minikube docker-env)
sh delete.sh
kubectl apply -f srcs/metallb/metallb.yaml
docker build -t services-nginx srcs/nginx/.
kubectl apply -f srcs/nginx/nginx.yaml
