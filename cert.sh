#!/bin/bash
#ususage : ./cert.sh secret_id_aws
set -E
inp="$@"
sec1="${@:1:1}"

certman() {

certy1=`kubectl get po -n cert-manager`
certy1s="$?"

if [[ ( $certy1s != "0" ) ]]
then

	#c1=`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml`
	c1=`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml`
	c1s="$?"
	if [[ ( "$c1s" -eq 0 ) ]]
	then
	echo " CertManager YAML with ,webhook,injector create successfully"
	fi
else
	echo "cert-manager some version already installed and running"
fi
}

stagsecret() {

secrt1="stag-route53-credentials-secret"
secrt1s=`kubectl get secret $secrt1 -n cert-manager`
if [[ ( $secrt1s != "0" ) ]]
then
	stagsec=`kubectl create secret generic $secrt1 --from-literal=secretkeyid=$sec1 -n cert-manager`

else
	echo "the secret with name $secrt1 is already present in the namespace cert-manager"
fi

}



if [[ ( -z "$1" ) ]]
then
	echo "The script needs aws_secet key"
	echo "usage: : ./cert.sh secret_id_aws"
	exit
fi	

certman
stagsecret
