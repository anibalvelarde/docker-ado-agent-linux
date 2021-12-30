# docker-ado-agent-linux

## Information

This Docker image was inspired by [cywl/azureagent](https://hub.docker.com/r/cywl/azureagent) image. In that case, it uses a much more secure way of authorizing your docker user.

If you are here, is probably because you want to run a self-hosted ADO Agent in a Docker Container and your ADO instance is on-prem and it does not have an TLS Cert (i.e. you have to reach it over HTTP, as in \_http://my-host-machine:8080/tfs). You probably also found the `cywl/azureagent` image, but that one uses PAT which requires you to use TLS (HTTPS).

With this image, we took `cywl/azureagent` and removed the use of `auth` set to `PAT` tokens and added the `username` and `password` parameters for authetnication with the `auth` set to `Negotiate`. If you compare the

If you'd like to dig deeper and understand what makes this _"tick"_, read this Microsoft article: [_Run a Self-Hosted Agent In Docker_](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops).

We were able to paint and publish a new Docker Image to Docker Hub. We called it `anibalvelarde/httpazureagent`. Find it [here](https://hub.docker.com/r/anibalvelarde/httpazureagent).

**Environment variables:**

- `AZP_URL` - The URL of the Azure DevOps or Azure DevOps Server instance. Like https://dev.azure.com/{organisation}/{project}
- `AZP_USERNAME` - The Active Directory user's account with sufficient Agent Management privileges on ADO
- `AZP_PSWD` - The password of your AD account
- `AZP_AGENT_NAME` - Agent name (default value: the container hostname).
- `AZP_POOL` - Agent pool name (default value: Default).
- `AZP_WORK` - Work directory (default value: \_work).

### Example to pull the image

```
docker pull anibalvelarde/httpazureagent

```

### Example to run the image

```
docker run -d
-e AZP_URL=<on-prem URL>
-e AZP_USERNAME=<username>
-e AZP_PSWD=<pswd>
-e AZP_POOL=<ADOPoolName>
-e AZP_AGENT_NAME=<ADO Agent Name> anibalvelarde/httpazureagent:latest

```

## WARNING:

Only use this approach with Azure DevOps on-prem. The traffic between your Agent's host and the ADO server will be over HTTP not over TLS. THIS IS NOT SECURE. Use at your own risk.

**DO NOT USE OVER THE PUBLIC INTERNET**

If you need a secure way of accessing your hosted agents, please, use [cywl/azureagent](https://hub.docker.com/r/cywl/azureagent).
