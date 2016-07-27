#!/bin/bash
set -e

TF=/Users/anton/dev/devscape/terraform
ETCD=10.100.14.114

export TF_VAR_environment=dev

$TF destroy --force

ssh $ETCD "etcdctl rm --recursive /registry" || true

$TF apply


