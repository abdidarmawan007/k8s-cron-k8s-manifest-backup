# backup gke manifest to gcp storage bucket with k8s cron 

## build docker images (zeus is dummy project)
```
docker build --no-cache -t production-k8s-backup .
docker tag production-k8s-backup asia.gcr.io/zeus-14235464232132/production-k8s-backup:v1
docker push asia.gcr.io/zeus-14235464232132/production-k8s-backup:v1
```

## create k8s cron
```
kubectl apply -f cron-backup.yaml
```
