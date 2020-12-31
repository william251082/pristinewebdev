#!/usr/bin/env bash
docker build -t pristinewebdev/multi-client:latest -t pristinewebdev/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t pristinewebdev/multi-server:latest -t pristinewebdev/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t pristinewebdev/multi-worker:latest -t pristinewebdev/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push pristinewebdev/multi-client:latest
docker push pristinewebdev/multi-server:latest
docker push pristinewebdev/multi-worker:latest

docker push pristinewebdev/multi-client:$SHA
docker push pristinewebdev/multi-server:$SHA
docker push pristinewebdev/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=pristinewebdev/multi-server:$SHA
kubectl set image deployments/client-deployment client=pristinewebdev/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=pristinewebdev/multi-worker:$SHA