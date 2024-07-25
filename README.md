


# Flux


## Flux cli installation

```shell
curl -s https://fluxcd.io/install.sh | sudo bash
```


## Flux Bootstrap

```shell
flux bootstrap github \
		--token-auth \
		--owner=ricsanfre \
		--repository=fluxcd-test \
		--branch=master \
		--path=kubernetes/clusters/dev \
		--personal
```

The GitHub PAT will be requested when executing this command.


### PAT secret
Note that the GitHub PAT is stored in the cluster as a Kubernetes Secret named flux-system inside the flux-system namespace.

The following secret is automatic created by flux bootstrap command

```yaml
apiVersion: v1
data:
  password: <echo $GitHub_PAT | base64>
  username: <echo "git" | base64 >
kind: Secret
metadata:
  name: flux-system
  namespace: flux-system
type: Opaque



```

## References

- https://fluxcd.io/flux/installation/bootstrap/github/