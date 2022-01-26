#!/usr/bin/env bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ "$#" -lt 3 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

REVISION_NAME=$1; shift
CHANNEL=$1; shift
ENABLE_CNI=$1; shift

cat <<EOF | kubectl apply -f -
apiVersion: mesh.cloud.google.com/v1beta1
kind: ControlPlaneRevision
metadata:
  name: "${REVISION_NAME}"
  namespace: istio-system
  labels:
    mesh.cloud.google.com/managed-cni-enabled: "${ENABLE_CNI}"
spec:
  type: managed_service
  channel: "${CHANNEL}"
EOF

kubectl wait --for=condition=Reconciled controlplanerevision/asm-managed --timeout 30s
