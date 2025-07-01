# PrivateBin Helm Chart

This is a kubernetes chart to deploy [PrivateBin](https://github.com/PrivateBin/PrivateBin).

## Quick Start

To install the privatebin chart with default options:

```bash
helm repo add privatebin https://privatebin.github.io/helm-chart
helm repo update
helm install privatebin/privatebin
```

## Installation

1. Customize your values.yaml for your needs. Add a [custom conf.php](https://github.com/PrivateBin/PrivateBin/blob/master/cfg/conf.sample.php) to change any default settings.

1. Deploy with helm

   ```bash
   helm install \
     your-release \
     --values your-values.yaml \
     privatebin/privatebin
   ```

## Configuration

See values.yaml for full documentation

| Parameter                     | Description                                         | Default                       |
| ----------------------------- | --------------------------------------------------- | ----------------------------- |
| `replicaCount`                | Number of replicas                                  | `1`                           |
| `image.repository`            | Container image name                                | `privatebin/nginx-fpm-alpine` |
| `image.tag`                   | Container image tag                                 | ``                            |
| `image.pullPolicy`            | Container image pull policy                         | `IfNotPresent`                |
| `nameOverride`                | Name Override                                       | `""`                          |
| `fullnameOverride`            | FullName Override                                   | `""`                          |
| `datapath`                    | Datapath for persistent data                        | `/srv/data`                   |
| `controller.kind`             | Controller kind (StatefulSet, Deployment, Both)     | `Deployment`                  |
| `controller.pvc.accessModes`  | Access Mode for PVC (only with StatefulSet)         | `ReadWriteOnce`               |
| `controller.pvc.requests`     | Requests for PVC (only with StatefulSet)            | `1Gi`                         |
| `controller.pvc.storageClass` | StorageClass to use for PVC (only with StatefulSet) | `""`                          |
| `controller.emptyDir`         | EmptyDir for storage (only for Deployment)          | `false`                       |
| `service.type`                | Service type (ClusterIP, NodePort or LoadBalancer)  | `ClusterIP`                   |
| `service.port`                | Ports exposed by service                            | `80`                          |
| `service.portName`            | Name of exposed port, becomes LB protocol on ELB    | `http`                        |
| `service.annotations`         | Service annotations                                 | `{}`                          |
| `ingress.enabled`             | Enables Ingress                                     | `false`                       |
| `ingress.annotations`         | Ingress annotations                                 | `{}`                          |
| `ingress.hosts.host`          | Ingress accepted hostnames                          | `privatebin.local`            |
| `ingress.hosts.paths`         | Ingress paths                                       | `[]`                          |
| `ingress.hosts.paths.0.path`  | Ingress path                                        | `/`                           |
| `ingress.hosts.paths.0.type`  | Ingress path type                                   | `Prefix`                      |
| `ingress.tls`                 | Ingress TLS configuration                           | `[]`                          |
| `resources`                   | Pod resource requests & limits                      | `{}`                          |
| `nodeSelector`                | Node selector                                       | `{}`                          |
| `tolerations`                 | Tolerations                                         | `[]`                          |
| `affinity`                    | Affinity or Anti-Affinity                           | `{}`                          |
| `strategy`                    | Deployment strategy                                 | `{ type: Replace }`           |
| `topologySpreadConstraints`   | Topology Spread Constraints                         | `[]`                          |
| `configs`                     | Optional Privatebin configuration file              | `{}`                          |
| `podAnnotations`              | Additional annotations to add to the pods           | `{}`                          |
| `additionalLabels`            | Additional labels to add to resources               | `{}`                          |
| `extraVolumes`                | Additional volumes to add to the pods               | `[]`                          |
| `extraVolumeMounts`           | Additional volume mounts to add to the pods         | `[]`                          |

## Upgrades

Standard helm upgrade process applies.

Chart releases default to the latest [stable image](https://github.com/PrivateBin/docker-nginx-fpm-alpine/tags) for PrivateBin at the time. You can find the release notes at https://github.com/PrivateBin/PrivateBin/releases.

## Running administrative scripts

The image includes two administrative scripts, which you can use to migrate from one storage backend to another, delete pastes by ID, removing empty directories when using the Filesystem backend, to purge all expired pastes and display statistics. These can be executed within the running image or by running the commands as alternative entrypoints with the same volumes attached as in the running service image, the former option is recommended.

```console
# assuming you named your install "your-release":

$ POD_NAME=$(kubectl get pod -l "app=your-release" -o jsonpath='{.items[0].metadata.name}')
$ kubectl exec "${POD_NAME}" -t -- administration --help
Usage:
  administration [--delete <paste id> | --empty-dirs | --help | --purge | --statistics]

Options:
  -d, --delete      deletes the requested paste ID
  -e, --empty-dirs  removes empty directories (only if Filesystem storage is
                    configured)
  -h, --help        displays this help message
  -p, --purge       purge all expired pastes
  -s, --statistics  reads all stored pastes and comments and reports statistics

$ kubectl exec "${POD_NAME}" -t -- migrate --help
migrate - Copy data between PrivateBin backends

Usage:
  migrate [--delete-after] [--delete-during] [-f] [-n] [-v] srcconfdir
          [<dstconfdir>]
  migrate [-h|--help]

Options:
  --delete-after   delete data from source after all pastes and comments have
                   successfully been copied to the destination
  --delete-during  delete data from source after the current paste and its
                   comments have successfully been copied to the destination
  -f               forcefully overwrite data which already exists at the
                   destination
  -h, --help       displays this help message
  -n               dry run, do not copy data
  -v               be verbose
  <srcconfdir>     use storage backend configuration from conf.php found in
                   this directory as source
  <dstconfdir>     optionally, use storage backend configuration from conf.php
                   found in this directory as destination; defaults to:
                   /srv/bin/../cfg/conf.php
```
