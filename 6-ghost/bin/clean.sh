#!/usr/bin/env bash

kubectl delete ingresses.extensions ghost-ingress
kubectl delete services ghost-service
kubectl delete deployments ghost


