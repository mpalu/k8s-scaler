#!/bin/bash

aws_profile="replace-me"

if [[ "$(aws sts get-caller-identity)" ]]; then 
  if [[ "$(echo $AWS_PROFILE)" == "$aws_profile" ]]; then
  echo -e "
  - Already logged in AWS with the profile $aws_profile
  "
  fi
else
  echo -e "
  - Loggin in AWS
  "

  export AWS_PROFILE="$aws_profile" && \
  otp="$(oathtool --totp -b replace-me)" && \
  gimme-aws-creds -p "$aws_profile" --mfa-code "$otp" && \
  echo -e "
  - Successfully logged in AWS with the profile $aws_profile
  "
fi

kube_context="replace-me"
current_kube_context="$(kubectl config current-context)"

if [[ "$current_kube_context" != "$kube_context" ]]; then
  echo -e "
  - Setting Kubernetes context to $kube_context
  "

  kubectl config use-context "$kube_context"
fi

replace-me_deployments="$(kubectl get deployments --namespace replace-me --no-headers -o custom-columns=':metadata.name')"

if [[ "$1" == "down" ]]; then
  for deployment in $replace-me_deployments; do
    echo -e "
    - Scaling down $deployment
    "

    kubectl scale deployment $deployment --namespace replace-me --replicas=0
  done
elif [[ "$1" == "up" ]]; then
  for deployment in $oreplace-me_deployments; do
    echo -e "
    - Scaling up $deployment
    "

    kubectl scale deployment $deployment --namespace replace-me --replicas=10
  done
else
    echo -e "
    - Accepted parameters are 'up' and 'down' only
    "
fi


