# Kubernetes example app

## Network policies

1. Ensure the definitions in `05-network-policies` are not applied.

2. Test access to `notification-api` from an arbitrary pod

Run a shell in a busybox pod

```
kubectl run -it --rm --restart=Never busybox --image=busybox sh
```

At the prompt run

```
nc -v notification-api 80

GET /
```

3. Deploy network policies.

```
kubectl apply -f 05-network-policies
```

4. Repeat the experiment

```
kubectl run -it --rm --restart=Never busybox --image=busybox sh
```

At the prompt run

```
nc -v notification-api 80
```

Observe that the connection can no longer be established.

5. Run a correctly labelled pod

```
kubectl run -it --rm --restart=Never busybox --labels="component=notification-ui" --image=busybox sh
```

At the prompt run

```
nc -v notification-api 80
```

Observe that the connection work again.
