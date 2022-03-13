#!/bin/bash
# Script to start running an ADO Linux Agent on Docker
# Must have an Azure DevOps PAT token for your account

# Do not do anything if the image is already running
clear; targetImageName="cywl/azureagent"
targetContainerId=$(docker ps -a -q  --filter ancestor=$targetImageName)
if [ ! -z $targetContainerId ]
then
    echo "Stopping ADO Linux Agent - cywl/azureagent"
    # Ensure we stop the container
    docker container stop $targetContainerId
    # Ensure we remove the container
    docker container rm $targetContainerId
    echo "Stoped & Removed container [$targetContainerId] running with Image Name: " $targetImageName
else
    echo "Agent is not running, use script to start it, start-ado-linux.agent.sh"
fi