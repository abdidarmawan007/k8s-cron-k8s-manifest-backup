#!/bin/bash

TIME=$(date '+%Y-%m-%d')
DIR='k8s-yaml/namespaces'

mkdir -p $DIR

for NAMESPACE in $(kubectl get -o=name namespaces | cut -d '/' -f2)
do
    for TYPE in $(kubectl get -n $NAMESPACE -o=name pvc,configmap,serviceaccount,secret,ingress,service,deployment,statefulset,hpa,job,cronjob,destinationrule,virtualservice,gateway,serviceentry)
    do
        mkdir -p $(dirname $DIR/$NAMESPACE/$TYPE)
        kubectl get -n $NAMESPACE -o=yaml $TYPE > $DIR/$NAMESPACE/$TYPE.yaml
    done
done

tar -czvf "$TIME-k8s-backup.tar.gz" k8s-yaml/
gsutil cp $TIME-k8s-backup.tar.gz gs://zeus-k8s-backup/$1/
