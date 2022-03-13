#!/bin/bash
# Script to start running an ADO Linux Agent on Docker
# Must have an Azure DevOps PAT token for your account

# Extract the PAT token
clear; my_pat_token=$(head -n 1 ../.user/my_pat_token | sed 's/^[ ]*//')
echo "My PAT: " $my_pat_token

# Do not do anything if the image is already running
IsTargetImageRunning=$(docker inspect --format='{{.Config.Image}}' $(docker ps -q && echo "image-list") | grep cywl/azureagent | wc -l)
if [ $IsTargetImageRunning == '0' ] && [ -n $patToken ]
then
    echo "Starting ADO Linux Agent - cywl/azureagent"
    # Ensure we have the latest image
    docker pull cywl/azureagent
    # Run cywl/azure-agent docker image
    docker run -d \
      -e "AZP_URL=https://dev.azure.com/anibalcincovelarde" \
      -e "AZP_TOKEN=$my_pat_token" \
      -e "AZP_AGENT_NAME=homebrewedagent" \
      -e "AZP_POOL=a5vAgentPool" \
      -e "AZP_WORK=_work" \
      cywl/azureagent
    echo "Running in the background..."
else
    echo "Agent is not running, use script to stop it, stop-ado-linux.agent.sh"
fi