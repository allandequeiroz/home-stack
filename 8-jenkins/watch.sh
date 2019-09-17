#!/usr/bin/env bash

slave=

while [ -z "${slave}" ];
do
    slave=$(kubectl get pod | grep jenkins | grep slave | awk '{ print $1 }')
    sleep 1
done        

echo -e "\nInspecting ${slave}\n" ;  kubectl describe pod ${slave} ; kubectl logs -f ${slave} jnlp