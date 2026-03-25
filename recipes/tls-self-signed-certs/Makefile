# Determine the root directory
ifeq ($(OS),Windows_NT)
    root ?= $(CURDIR)/../..
else
    root ?= $(shell pwd)/../..
endif

# Create a config.mk file in the root directory of this project to override defaults included below
-include $(root)/config.mk

# Theses are the default values used by this recipe
include ./config.mk

.PHONY: all
all: create-custom-certs list-sans create-keystore create-truststore create-tls-secrets
	
.PHONY: clean
clean: delete-tls-secrets delete-custom-certs

include $(root)/makefiles/tls-self-signed-cert.mk
include $(root)/makefiles/tls-keystore.mk
include $(root)/makefiles/ingress-nginx.mk