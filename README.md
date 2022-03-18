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
      --name your-release \
      --values your-values.yaml \
      privatebin/privatebin
    ```

## Configuration

See values.yaml for full documentation

|              Parameter       |                    Description                     |                     Default                      |
| ---------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `replicaCount`               | Number of replicas                                 | `1`                                              |
| `image.repository`           | Container image name                               | `privatebin/nginx-fpm-alpine`                    |
| `image.tag`                  | Container image tag                                | ``                                               |
| `image.pullPolicy`           | Container image pull policy                        | `IfNotPresent`                                   |
| `nameOverride`               | Name Override                                      | `""`                                             |
| `fullnameOverride`           | FullName Override                                  | `""`                                             |
| `datapath`                   | Datapath for persistent data                       | `/srv/data`                                      |
| `controller.kind`            | Controller kind (StatefulSet, Deployment, Both)    | `Deployment`                                     |
| `controller.pvc.accessModes` | Access Mode for PVC (only with StatefulSet)        | `ReadWriteOnce`                                  |
| `controller.pvc.requests`    | Requests for PVC (only with StatefulSet)           | `1Gi`                                            |
| `controller.pvc.storageClass`| StorageClass to use for PVC (only with StatefulSet)| `""`                                             |
| `controller.emptyDir`        | EmptyDir for storage (only for Deployment)         | `false`                                          |
| `service.type`               | Service type (ClusterIP, NodePort or LoadBalancer) | `ClusterIP`                                      |
| `service.port`               | Ports exposed by service                           | `80`                                             |
| `service.portName`           | Name of exposed port, becomes LB protocol on ELB   | `http`                                           |
| `service.annotations`        | Service annotations                                | `{}`                                             |
| `ingress.enabled`            | Enables Ingress                                    | `false`                                          |
| `ingress.annotations`        | Ingress annotations                                | `{}`                                             |
| `ingress.hosts.host`         | Ingress accepted hostnames                         | `privatebin.local`                               |
| `ingress.hosts.paths`        | Ingress paths                                      | `[]`                                             |
| `ingress.hosts.paths.0.path` | Ingress path                                       | `/`                                              |
| `ingress.hosts.paths.0.type` | Ingress path type                                  | `Prefix`                                         |
| `ingress.tls`                | Ingress TLS configuration                          | `[]`                                             |
| `resources`                  | Pod resource requests & limits                     | `{}`                                             |
| `nodeSelector`               | Node selector                                      | `{}`                                             |
| `tolerations`                | Tolerations                                        | `[]`                                             |
| `affinity`                   | Affinity or Anti-Affinity                          | `{}`                                             |
| `configs`                    | Optional Privatebin configuration file             | `{}`                                             |
| `podAnnotations`             | Additional annotations to add to the pods          | `{}`                                             |
| `additionalLabels`           | Additional labels to add to resources              | `{}`                                             |

## Upgrades

Standard helm upgrade process applies.

Chart release 0.3.0+ defaults to the [image](https://github.com/PrivateBin/docker-nginx-fpm-alpine/releases/tag/1.3.0-alpine3.10) for to PrivateBin 1.3.0. You can find the release notes at https://github.com/PrivateBin/PrivateBin/releases/tag/1.3.
