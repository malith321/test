#!/bin/bash
# Copyright 2018 Google LLC
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

is_deployment_ready() {
    kubectl --context $1 -n $2 get deploy $3 &> /dev/null
    export exit_code=$?
    while [ ! " ${exit_code} " -eq 0 ]
        do
            sleep 5
            echo -e "Waiting for deployment $3 in cluster $1 to be created..."
            kubectl --context $1 -n $2 get deploy $3 &> /dev/null
            export exit_code=$?
        done
    echo -e "Deployment $3 in cluster $1 created."

    # Once deployment is created, check for deployment status.availableReplicas is greater than 0
    export availableReplicas=$(kubectl --context $1 -n $2 get deploy $3 -o json | jq -r '.status.availableReplicas')
    while [[ " ${availableReplicas} " == " null " ]]
        do
            sleep 5
            echo -e "Waiting for deployment $3 in cluster $1 to become ready..."
            export availableReplicas=$(kubectl --context $1 -n $2 get deploy $3 -o json | jq -r '.status.availableReplicas')
        done

    echo -e "$3 in cluster $1 is ready with replicas ${availableReplicas}."
    return ${availableReplicas}
}

if [ "$#" -lt 5 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

PROJECT_ID=$1
CLUSTER_NAME=$2
CLUSTER_LOCATION=$3

# Gatekeeper causes issues if not ready
is_deployment_ready gke_"${PROJECT_ID}"_"${CLUSTER_LOCATION}"_"${CLUSTER_NAME}" gatekeeper-system gatekeeper-controller-manager
