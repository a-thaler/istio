# Install Istio
- [Install Istio](#install-istio)
  - [Prerequisites](#prerequisites)
  - [Install Kyma Istio Operator manually](#install-kyma-istio-operator-manually)
    - [Use Kyma Istio Operator to install or uninstall Istio](#use-kyma-istio-operator-to-install-or-uninstall-istio)
  - [Install the Istio module with Lifecycle Manager locally on k3d](#install-the-istio-module-with-lifecycle-manager-locally-on-k3d)
    - [Install using the ModuleTemplate generated by the local build](#install-using-the-moduletemplate-generated-by-the-local-build)
    - [Install with artifacts built for the `main` branch of the Istio repository](#install-with-artifacts-built-for-the-main-branch-of-the-istio-repository)

## Prerequisites

- Access to a Kubernetes cluster (you can use [k3d](https://k3d.io/v5.5.1/))
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [kubebuilder](https://book.kubebuilder.io/)
- [Docker](https://www.docker.com)
- [Kyma CLI](https://kyma-project.io/#/04-operation-guides/operations/01-install-kyma-CLI)

## Install Kyma Istio Operator manually

1. Clone the project.

```bash
git clone https://github.com/kyma-project/istio.git && cd istio
```

1. Set the Istio Operator image name.

```bash
export IMG=istio-operator:0.0.1
export K3D_CLUSTER_NAME=kyma
```

3. Provision the k3d cluster.

```bash
kyma provision k3d
```
>**TIP:** To verify the correctness of the project, build it using the `make build` command.

4. Build the image.

```bash
make docker-build
```

5. Push the image to the registry.

<div tabs name="Push image" group="istio-operator-installation">
  <details>
  <summary label="k3d">
  k3d
  </summary>

   ```bash
   k3d image import $IMG -c $K3D_CLUSTER_NAME
   ```

  </details>
  <details>
  <summary label="Docker registry">
  Globally available Docker registry
  </summary>

   ```bash
   make docker-push
   ```

  </details>
</div>

6. Deploy Istio Operator.

```bash
make deploy
```

### Use Kyma Istio Operator to install or uninstall Istio

- Install Istio in your cluster.

```bash
kubectl apply -f config/samples/operator_v1alpha2_istio.yaml
```

- Delete Istio from your cluster.

```bash
kubectl delete -f config/samples/operator_v1alpha2_istio.yaml
```

## Install the Istio module with Lifecycle Manager locally on k3d

To install the Istio module with Lifecycle Manager locally, use make or use the artifacts that are created by `post-istio-module-build` job.

### Install using the ModuleTemplate generated by the local build

1. Run the following command to provision a k3d cluster, deploy Lifecycle Manager, build the module, and deploy it.

```bash
make local-run
```

2. Delete the k3d cluster.

```bash
make local-stop
```

### Install with artifacts built for the `main` branch of the Istio repository

1. Provision the k3d cluster.

```bash
kyma provision k3d
```

2. Install Lifecycle Manager in the target cluster.

```bash
kyma alpha deploy
```

3. Apply the ModuleTemplate generated by the [post-istio-module-build Prow job](https://status.build.kyma-project.io/job-history/gs/kyma-prow-logs/logs/post-istio-module-build). You can find it in the job artifacts.

```bash
kubectl apply -f template-regular.yaml
```

4. Enable the Istio module.

```bash
kyma alpha enable module istio -c regular
```
