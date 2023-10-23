#!/usr/bin/env bash
#usage : ./cert.sh secret_id_aws

source <(curl -s https://raw.githubusercontent.com/rangapv/bash-source/main/s1.sh) >>/dev/null >&1

set -E
inp="$@"
sec1="${@:1:1}"

certman() {

certy1=`kubectl get po -n cert-manager | wc -l`
certy1s="$?"
`cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace 
metadata:
  name: cert-manager
EOF`
if [[ (( $certy1s != 2 )) ]]
then
	

	#c1=`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.yaml`
	c1=`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml`
	c1s="$?"
	if [[ ( "$c1s" -eq 0 ) ]]
	then
	echo " CertManager YAML with ,webhook,injector create successfully"
	fi
else
	echo -e "cert-manager `cmctl version` already installed and running"
fi
}

stagsecret() {

secrt="stag-route53-credentials-secret"
secrt1=`kubectl get secret "$secrt" -n cert-manager`
secrt1s="$?"
if [[ ( $secrt1s != "0" ) ]]
then
	stagsec=`kubectl create secret generic $secrt --from-literal=secretkeyid=$sec1 -n cert-manager`

else
	echo "the secret with name $secrt is already present in the namespace cert-manager"
fi

}


osarch() {

cmct=`which cmctl`
cmcts="$?"
#echo "inside osarch and cmcts is $cmcts"
if [[ ( $cmcts != "0" ) ]]
then
#OS=$(go env GOOS)
#ARCH=$(go env GOARCH)
#THe params os and ARCH have been imported from the script s1.sh from bash-source in my github repo
wge=`which wget`
wges="$?"
cmcflag=0
if [[ ( $wges = "0" ) && ( $cmcflag != 1 ) ]]
then
`wget -P ./ https://github.com/cert-manager/cert-manager/releases/latest/download/cmctl-$os-$ARCH.tar.gz`
tar xzf cmctl-$os-$ARCH.tar.gz
sudo mv cmctl /usr/local/bin
cmcflag=1
fi
cur1=`which curl`
cur1s="$?"
if [[ ( $cur1s = "0" )  && ( $cmcflag != 1 ) ]]
then
`curl -fsSL -o ./cmctl.tar.gz https://github.com/cert-manager/cert-manager/releases/latest/download/cmctl-$os-$ARCH.tar.gz`
tar xzf cmctl.tar.gz
sudo mv cmctl /usr/local/bin
cmcflag=1
fi
if [[ ( $cmcflag = "0" ) ]]
then
	echo "Unable to install cmctl reason could be no curl/wget installed"
fi
fi
}

if [[ ( -z "$1" ) ]]
then
	echo "The script needs aws_secet key"
	echo "usage: : ./cert.sh secret_id_aws"
	exit
fi

osarch
certman
stagsecret
