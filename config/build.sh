#!/bin/sh
set -e
cd "$(dirname "$(readlink -f "$0")")"
ksCORE="ks-core"
cat <<EOF >aio.yaml
$(cat "$ksCORE"/charts/ks-crds/crds/*.yaml | grep -v controller-gen)
---
apiVersion: v1
kind: Namespace
metadata:
  creationTimestamp: null
  name: kubesphere-system
spec: {}
status: {}
---
$(
  for f in builtinroles clusterroles globalroles globalrolebindings roletemplates roletemplate-categories; do
    echo
    echo ---
    cat "$ksCORE/templates/$f.yaml"
  done
)
---
$(
  ksCORE="ks-deploy"
  for f in customresourcefilters ks-console-config kubesphere-config oauthclient-config \
    serviceaccount services user webhook workspace \
    ks-apiserver ks-console ks-controller-manager; do
    echo
    echo ---
    cat "$ksCORE/templates/$f.yaml"
  done
)
EOF
