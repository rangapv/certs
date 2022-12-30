#!/bin/bash
c1=`kubectl delete clusterissuer letsencrypt-stag`
c11=`kubectl delete issuer letsencrypt-stag`
c2=`kubectl delete certificate stagingcert`
c3=`kubectl delete secret letsencrypt-stag -n cert-manager`
c4=`kubectl delete ing nginx-ingress1`
c6=`kubectl get certificate`
c7=`kubectl get secret --all-namespaces`
