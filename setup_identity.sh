#!/bin/bash
juju destroy-model jenkins --destroy-storage --force
juju add-model jenkins

juju deploy ./jenkins-k8s_ubuntu-22.04-amd64.charm --resource jenkins-image=jenkins-image:1.0
juju deploy oathkeeper --channel=edge --trust
juju deploy ./tests/integration/files/identity-bundle-edge-patched.yaml --trust

juju config kratos-external-idp-integrator \
    client_id=client_id \
    client_secret=client_secret \
    provider=generic \
    issuer_url=http://10.9.2.100:5556 \
    scope="profile email" \
    provider_id=Dex
read -r -n 1 -p "Wait for idle:"

juju relate oathkeeper:certificates self-signed-certificates
juju relate traefik-public:receive-ca-cert self-signed-certificates
juju config traefik-public enable_experimental_forward_auth=True
juju relate oathkeeper traefik-public:experimental-forward-auth
juju relate oathkeeper:kratos-info kratos
juju config kratos dev=True
juju relate jenkins-k8s:ingress traefik-public
juju relate jenkins-k8s:auth-proxy oathkeeper

read -r -n 1 -p "Wait for active:"
juju run kratos-external-idp-integrator/0 get-redirect-uri
