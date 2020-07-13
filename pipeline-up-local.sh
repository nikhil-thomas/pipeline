#!/usr/bin/env bash

export SYSTEM_NAMESPACE="tekton-pipelines"

# Create tekton-pipelines namespace
oc apply -f config/100-namespace.yaml

# Add CRDs
ls config/300* | xargs -I $ -- oc apply -f $

# Add necessary config resources
oc apply -f config/config-artifact-bucket.yaml
#oc apply -f config/config-artifact-pvc.yaml
oc apply -f config/config-defaults.yaml
oc apply -f config/config-feature-flags.yaml
#oc apply -f config/config-leader-election.yaml
oc apply -f config/config-logging.yaml
#oc apply -f config/config-observability.yaml

# operaotr-sdk by convention runs cmd/manager entry point
# so add a symbolic link to cmd/controller
ln -s $(pwd)/cmd/controller cmd/manager

# This is how operator-sdk decides that
# the pwd is an operator project
mkdir "build"
touch build/Dockerfile

# run controller using operator-sdk run local
# operator-sdk version: v0.17.1
operator-sdk run --local
