# Camunda 8 with ingress tls using oidc authentication 

Sample of how to configure 8.9 with nginx ingress and tls certificates. Keycloak is used for oidc authentication.

## Features

This profile provides:
- **Keycloak and Keycloak Postgresql**
- **Management Identity**
- **Orchestration Cluster**: Configured to use nginx ingress with TLS
- **Connectors**

## Prerequisites

- An existing Kubernetes cluster using Kind, Google, AWS or Azure, etc
- `kubectl` configured to connect to your cluster
- `helm` version 3.7.0 or later
- GNU `make`

## Helm values file

See [sample-camunda-values.yaml](./sample-camunda-values.yaml)