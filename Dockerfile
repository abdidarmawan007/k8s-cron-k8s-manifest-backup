FROM ubuntu:20.04

ENV TZ=Asia/Jakarta
ENV DEBIAN_FRONTEND=noninteractive
ARG GKE_CLUSTER=production-zeus
ARG GCP_PROJECT=zeus-14235464232132

COPY gcp.json /gcp.json
COPY k8s-backup.sh /k8s-backup.sh

RUN apt-get update \
 && apt-get install -y apt-transport-https ca-certificates \
 && apt-get install -y language-pack-en-base software-properties-common apt-utils gnupg curl \
 && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
 && apt-get update && apt-get install google-cloud-sdk kubectl -y

RUN gcloud auth activate-service-account --key-file /gcp.json \
    && gcloud container clusters get-credentials $GKE_CLUSTER --zone asia-southeast1-b --project $GCP_PROJECT

RUN kubectl get deployment -n production    
