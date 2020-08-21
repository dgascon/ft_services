docker build -t services-nginx srcs/nginx/.
kubectl delete pod nginx
kubectl create -f srcs/nginx/nginx.yaml