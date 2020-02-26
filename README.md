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
