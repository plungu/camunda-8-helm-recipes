# Camunda 8 Helm Recipe: Self Signed TLS Certificates 

This folder contains a [Makefile](Makefile) that demonstrates how to create certificates and keystores

## Features

This recipe provides:
- **Certificate Authority CA**: Create a self signed certificate authority
- **TLS Certificate**: create a self signed tls certificate
- **Keystore and Truststore**: create java keystore and truststores

## Prerequisites

- The java `keytool` cli installed
- GNU `make`

## Create and use a custom CA and self-signed TLS certificate

Edit `config.mk` and set your `CERT_NAME` and other settings.

Open a terminal and run `make`. This will do the following: 
- create a `certs` directory for holding related files
- generate `<CERT_NAME>CA.key` and `<CERT_NAME>CA.pem` representing a custom Certificate Authority
- generate `<CERT_NAME>Server.crt` and `<CERT_NAME>Server.crt` files representing a tls certificate and private key
- create 2 kubernetes secrets, one named `<TLS_SECRET_NAME>` and another named `grpc-<TLS_SECRET_NAME>`. Both of these secrets will contain the server crt and key files.

The camunda values.yaml files use `tls-secret` and `grpc-tls-secret` secrets inside the ingress rules. So, once the k8s secrets are created, the ingress should start to use your self signed certificate. 

Here's a recorded demo: 

<video src="./docs/create-and-configure-tls.mp4" controls title="How to create and use CA and tls certs" style="max-width: 100%;">
</video>

## Trust the Certificate Authority (CA)

Here's a video showing how to trust the CA on Mac OS:

<video src="./docs/trust-tls-cert.mp4" controls title="Trust self-signed cert on Mac OS" style="max-width: 100%;">
</video>

For convenience, it's also possible to use this make target to add the CA pem file to Mac OS System KeyChain: `make add-ca-cert-to-ios`

![Screenshot 2026-03-25 at 2.40.28 PM.png](docs/Screenshot%202026-03-25%20at%202.40.28%E2%80%AFPM.png)

## Java SSL Connection issues

Watch this demo to understand how to use the `truststore.jks` file created by `make create-truststore` to allow a jvm to establish tls/ssl connection to a domain using a certificate that has been issued by the CA: 

<video src="./docs/trust-tls-cert-from-java.mp4" controls title="Trust self-signed cert from java" style="max-width: 100%;">
</video>

If the jvm doesn't trust the CA, then you'll see exceptions like this:

```
Caused by: javax.net.ssl.SSLHandshakeException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
```

Look at the command for `make create-keystore` to understand ho to create a truststore that includes a CA certificate. You DO NOT need the private key. You only need to convince JAVA to trust the non-standard CA certificate. Add jvm properties like this to your java command: 

```
-Djavax.net.ssl.trustStore=/Users/dave/code/camunda-8-helm-recipes/recipes/tls-self-signed-certs/certs/truststore.jks
-Djavax.net.ssl.trustStorePassword=camunda
```

## Clean up
Run `make clean` to remove the tls secrets and delete the `certs` directory along with all certificate related generated files