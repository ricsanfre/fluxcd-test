


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
	- if configMap content is changed, name is also changed forcing the re-deploy of all resources using that configMap.

### Scaffold a new flux-cd application


For scaffolding automatically out a new application from a template defined in a set of files and folders, a tool like [boilerplate](https://github.com/gruntwork-io/boilerplate) from gruntwork-io can be used.

The basic idea behind Boilerplate is that you create a template folder that contains:

- A `boilerplate.yml` file that configures the template, such as the input variables to gather from the user.
- Any number of other files and folders that generate the code you want, using Go templating syntax to fill in those input variables where necessary, do loops, do conditionals, and so on.


Install [boilerplate](https://github.com/gruntwork-io/boilerplate) from gruntwork-io


Template in `kubernetes/boilerplate/template` (result of command `tree -n -q --charset utf-8` .)


#### Template flux-cd application:

```shell
📁 <application>         
├── 📁 app                 # base app (helm installation)
│   ├── 📁 base                    # kustomization base
│   │   ├── helm.yaml                  # flux helm resources
│   │   ├── kustomization.yaml         # kustomization file (base)
│   │   ├── kustomizeconfig.yaml       # confiMap generator config
│   │   ├── ns.yaml                    # namespace manifest
│   │   └── values.yaml                # helm values file (base)
│   └── 📁 overlays                # kustomization overalys
│       ├── 📁 dev
│       │   ├── kustomization.yaml     # kustomization file (overlay)
│       │   └── values.yaml            # helm values file (overlay)
│       └── 📁 prod
│           ├── kustomization.yaml
│           └── values.yaml
├── 📁 config               # config app (additional configuration)
│   ├── 📁 base
│   └── 📁 overlays
│       ├── 📁 dev
│       └── 📁 prod
```

To build a new application from the template. User will be prompted to provide values for all variables included in the `boilerplate.yml`

```shell
boilerplate --template-url <template-folder> --output-folder <output-folder>
```

To use variables defined in yaml file instead, define a `vars.yaml` file, containing values for all variables in `boilerplate.yml`

```shell
boilerplate \
  --template-url <template-folder> \
  --output-folder <output-folder> \
  --var-file vars.yml \
  --non-interactive 
```

## Helmfile

[helmfile](https://github.com/helmfile/helmfile) is a declarative spec for deploying helm charts. It uses `helm` command 

```yaml
helmDefaults:
  wait: true
  waitForJobs: true
  timeout: 600
  recreatePods: true
  force: true

repositories:
  - name: cilium
    url: https://helm.cilium.io

releases:
  - name: cilium
    namespace: kube-system
    chart: cilium/cilium
    version: 1.16.0
    values:
      - ./kubernetes/infrastructure/cilium/app/base/values.yaml
      - ./kubernetes/infrastructure/cilium/app/overlays/dev/values.yaml
```

```shell
helmfile --quiet --file helmfile.yaml apply --skip-diff-on-install --suppress-diff
```


## References

- https://fluxcd.io/flux/installation/bootstrap/github/

- [Academeez K8s and fluxcd course](https://www.academeez.com/en/course/kubernetes/flux)
  - [Repo and videos](https://github.com/ywarezk/academeez-k8s-flux)

- Managing Kubernetes the GitOps way with Flux
  - [Repo](https://github.com/moonswitch-workshops/terraform-eks-flux)
  - [Video](https://youtu.be/1DuxTlvmaNM?si=SaFfQ30Z1fLAo-Tp)

- [Introducing boilerplate](https://blog.gruntwork.io/introducing-boilerplate-6d796444ecf6)

- [Generators [Practical Examples]](https://devopscube.com/kuztomize-configmap-generators/)