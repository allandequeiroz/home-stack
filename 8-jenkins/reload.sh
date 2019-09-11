#!/usr/bin/env bash

# Maintained by Allan de Queiroz <allan.queiroz@ig.com>

DELETE=false
APPLY=false
DEFAULT=true

for i in "$@"
do
    case ${i} in

        -d | --delete )                      DELETE=true
                                             DEFAULT=false
                                             ;;
        -a | --apply )                       APPLY=true
                                             DEFAULT=false        
                                             ;;
        -h | --help )                        echo -e "Usage : ./reload.sh [OPTIONS]"
                                             echo -e "\t-d | --delete                     Delete the configurations"
                                             echo -e "\t-a | --apply                      Apply the configurations"
                                             echo "If no option is specified by default will be delete then apply everything"
                                             exit 0
                                             ;;
    esac
    shift
done

clear

delete() {
    echo "Everything was deleted, waiting for 5 seconds before providing a report..."
    # kubectl delete -f ingress.yaml > /dev/null
    # kubectl delete -f rbac.yaml > /dev/null
    kubectl delete -f jenkins.yaml > /dev/null
}

apply() {
    echo "Everything was applied, waiting for 5 seconds before providing a report..."
    kubectl apply -f jenkins.yaml > /dev/null
    # kubectl apply -f rbac.yaml > /dev/null
    # kubectl apply -f ingress.yaml > /dev/null
}

if [ ${DELETE} == true ]; then
    delete
fi

if [ ${APPLY} == true ]; then
    apply
fi

if [ ${DEFAULT} == true ]; then
    delete
    apply
fi

sleep 5
echo ""

echo -e "# Deployments"
kubectl get deploy -o wide | grep jenkins
kubectl get deploy -o wide | grep nginx

echo -e "\n# Pod"
kubectl get po -o wide | grep jenkins
kubectl get po -o wide | grep nginx

JENKINS_POD=$(kubectl get po -o wide | grep jenkins | grep Running | awk '{print $1}')
#echo -e "\n# Pod Description"
#kubectl describe pod ${POD}

echo -e "\n# Service"
kubectl get service -o wide | grep jenkins
kubectl get service -o wide | grep nginx

echo -e "\n# Ingress\n"
kubectl get ingress -o wide | grep jenkins

kubectl logs -f --tail 500 ${JENKINS_POD}