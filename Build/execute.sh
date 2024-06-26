#!/bin/bash
export PATH="$PATH:/usr/local/bin"
export USERID=$(id -u)
export GROUPID=$(id -g)

# Navigate to the script directory
cd "$(dirname "$0")"

echo "REGION=${REGION}"
echo "AMI_NAME=${AMI_NAME}"
echo "DESCRIPTION=${DESCRIPTION}"
echo "DESCRIPTION=${WORKSPACE}"
echo "DESCRIPTION=${JOB_NAME}"

# Set environment variables
CONTAINER_NAME="vijay-$(echo "${JOB_NAME}" | tr '/ ' '._').${BRANCH_NAME}"
[ -n "${CHANGE_ID}" ] && CONTAINER_NAME="${CONTAINER_NAME}-PR${CHANGE_ID}"
CONTAINER_NAME="${CONTAINER_NAME}-${BUILD_ID}"

# Run the Packer build
docker-compose -f execute.yml run \
    --rm \
    -w "$WORKSPACE" \
    --name "${CONTAINER_NAME}" \
    packer_service build \
        -var "region=${REGION}" \
        -var "ami_name=${AMI_NAME}" \
        -var "description=${DESCRIPTION}" \
        "${WORKSPACE}"/jenkins-packer-ami.pkr.hcl

