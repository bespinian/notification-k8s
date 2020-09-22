#!/bin/sh

kubectl apply -f 00-notification-db
kubectl apply -f 01-notification-mq
kubectl apply -f 02-notification-api
kubectl apply -f 03-notification-mailer
kubectl apply -f 04-notification-ui
