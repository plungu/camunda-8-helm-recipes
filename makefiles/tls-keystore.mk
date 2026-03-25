.PHONY: create-keystore
create-keystore: delete-keystore
	openssl pkcs12 -export -in ./certs/$(CERT_NAME)Server.crt -inkey ./certs/$(CERT_NAME)Server.key \
               -out ./certs/$(CERT_NAME)Server.p12 -name $(CERT_NAME)-p12 \
               -CAfile ./certs/$(CERT_NAME)CA.pem -caname $(CERT_NAME)-ca
	keytool -importkeystore -deststorepass camunda -destkeypass camunda -destkeystore ./certs/keystore.jks -srckeystore ./certs/$(CERT_NAME)Server.p12 -srcstoretype PKCS12 -srcstorepass $(TRUST_STORE_PASS)

.PHONY: delete-keystore
delete-keystore:
	rm -rf ./certs/keystore.jks
	rm -rf ./certs/$(CERT_NAME)Server.p12

.PHONY: list-keystore
list-keystore:
	keytool -list -v -keystore ./certs/keystore.jks -storepass $(TRUST_STORE_PASS)

.PHONY: create-truststore
create-truststore: delete-truststore
	keytool -import -keystore ./certs/truststore.jks -storepass camunda -noprompt -file ./certs/$(CERT_NAME)CA.pem -alias $(CERT_NAME)-ca-cert

.PHONY: delete-truststore
delete-truststore:
	rm -rf ./certs/truststore.jks

.PHONY: list-truststore
list-truststore:
	keytool -list -v -keystore ./certs/truststore.jks -storepass $(TRUST_STORE_PASS)

.PHONY: create-keystore-secret
create-keystore-secret:
	kubectl create secret generic camunda-keystore-secret --from-file=./certs/keystore.jks -n $(CAMUNDA_NAMESPACE)

.PHONY: create-truststore-secret
create-truststore-secret:
	kubectl create secret generic camunda-truststore-secret --from-file=./certs/truststore.jks -n $(CAMUNDA_NAMESPACE)

.PHONY: create-keycloak-secret
create-keycloak-secret:
	-kubectl -n $(CAMUNDA_NAMESPACE) delete secret "keycloak-secret"
	kubectl -n $(CAMUNDA_NAMESPACE) create secret generic keycloak-secret --from-file=./certs/keystore.jks --from-file=./certs/truststore.jks
