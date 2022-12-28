#!/bin/bash
#ususage : ./cert.sh secret_id_aws
set -E
inp="$@"
sec1="${@:1:1}"

certman() {
c1=`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml`
c1s="$?"
if [[ ( "$c1s" -eq 0 ) ]]
then
	echo " CertManager YAML with ,webhook,injector create successfully"
fi
}

stagsecret() {

stagsec=`kubectl create secret generic stag-route53-credentials-secret --from-literal=secretkeyid=$sec1 -n cert-manager`

}

certman
stagsecret
