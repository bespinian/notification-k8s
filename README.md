# Kubernetes example app

## Network policies

Ensure the definitions in `05-network-policies` are not applied.

Run a shell in a busybox pod

```
kubectl run -it --rm --restart=Never busybox --image=busybox sh
```

At the prompt run

```
nc -v notification-api 80

GET /
```

Deploy network policies.

```
kubectl apply -f 05-network-policies
```

Repeat the experiment

```
kubectl run -it --rm --restart=Never busybox --image=busybox sh
```

At the prompt run

```
nc -v notification-api 80
```

Observe that the connection can no longer be established.

Now run a correctly labelled pod

```
kubectl run -it --rm --restart=Never busybox --labels="component=notification-ui" --image=busybox sh
```

At the prompt run

```
nc -v notification-api 80
```

Observe that the connection works again.

## Istio mTLS

Check mTLS status between `notification-ui` pod and `notification-api` service.

```
istioctl authn tls-check notification-ui-deployment-<id> notification-api.notification-istio.svc.cluster.local
```

Observe that mTLS is not enabled.

Apply a destination rule for `notification-api`

```
kubectl apply -f 07-istio/notification-api-dr.yaml
```

Check mTLS status between `notification-ui` pod and `notification-api` service.

```
istioctl authn tls-check notification-ui-deployment-<id> notification-api.notification-istio.svc.cluster.local
```

Observe that the mTLS is now enabled but the server-side of the communication is still in permissive mode.

Apply a Policy to put the server in strict mode.

```
kubectl apply -f 07-istio/notification-api-policy.yaml
```

Check mTLS status between `notification-ui` pod and `notification-api` service.

```
istioctl authn tls-check notification-ui-deployment-<id> notification-api.notification-istio.svc.cluster.local
```

Observe that the mTLS is now enabled and the server-side of the communication is still in strict mode.

Open a shell in the `istio-proxy` container of a `notification-ui` pod.

```
kubectl exec -it notification-ui-deployment-<id> -c istio-proxy -- /bin/bash
```

Test access to `notification-api` via `http`

```
curl http://notification-api:80 -k
```

Observe that this does not work.

Test access to `notfication-api` via `https`

```
curl https://notification-api:80 -k

```

Observe that this does not work.

Test access using the client certificates.

```
curl https://notification-api:80 --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem --cacert /etc/certs/root-cert.pem -k
```

Observe that this works.
