


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

### Helm Chart

- Provide values.yaml files from configMaps, using Kustomize's configMap generator.
- Base and Overlay values.yaml file
- Config Maps are suffixed with a hashe code over its content.
	- if configMap content is changed, name is also changed forcing the re-deploy of all resources using that configMap 

### Boilerplate



For generating automatically a a structure for a new application automatically from a structure application

Install [boilerplate](https://github.com/gruntwork-io/boilerplate) from gruntwork-io


Template in `kubernetes/boilerplate/template` (result of command `tree -n -q --charset utf-8` .)


Application structure

```shell
📁 <application>         
├── 📁 app                 # base app (helm installation)
│   ├── 📁 base   									# kustomization base
│   │   ├── helm.yaml									 # flux helm resources
│   │   ├── kustomization.yaml         # kustomization file (base)
│   │   ├── kustomizeconfig.yaml       # confiMap generator config
│   │   ├── ns.yaml										 # namespace manifest
│   │   └── values.yaml								 # helm values file (base)
│   └── 📁 overlays									# kustomization overalys
│       ├── 📁 dev
│       │   ├── kustomization.yaml     # kustomization file (overlay)
│       │   └── values.yaml            # helm values file (overlay)
│       └── 📁 prod
│           ├── kustomization.yaml
│           └── values.yaml
├── 📁 config 							# config app (additional configuration)
│   ├── 📁 base
│   └── 📁 overlays
│       ├── 📁 dev
│       └── 📁 prod
```



```shell
boilerplate --template-url kubernetes/boilerplate/template --output-folder <output-folder>

```


## References

- https://fluxcd.io/flux/installation/bootstrap/github/

- https://devopscube.com/kuztomize-configmap-generators/