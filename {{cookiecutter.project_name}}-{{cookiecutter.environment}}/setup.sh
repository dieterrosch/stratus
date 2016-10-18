# #Foswiki
# cd foswiki && docker build -t foswiki . && docker push foswiki && cd ..
# kubectl create -f foswiki.yaml

# #RabbitMQ
# kubectl create -f rabbitmq.yaml

#Display commands as executed
set -o verbose
set -x

#RocketChat
kubectl apply -f rocketchat --namespace = {{cookiecutter.environment}}

MINIKUBE_IP=$(minikube ip)
echo "Minikube is running on $MINIKUBE_IP."
echo "Please add the following lines to your /etc/hosts file..."
echo -e "$MINIKUBE_IP \t rocketchat.{{cookiecutter.stratus_root_domain}}"
#echo -e "$MINIKUBE_IP \t rabbitmq.atlas.local"
