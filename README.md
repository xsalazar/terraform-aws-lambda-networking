# Terraform/AWS Lambda Networking Boilerplate

This project is aimed at outlining a small AWS project in which a simple NodeJS application is deployed to a Lambda function.
An API Gateway will forward requests to the Lambda, which will then do a sanity check that it can access a Redis database in the private subnet. Additionally, it will check that it can initiate an HTTP request out to the public internet to verify the networking is correctly configured.

## Getting Started

### Updating Application Code

The application code that is deployed to Lambda lives in the [./app](./app) directory in the `index.js` file. Currently, this code does two checks:

- Test whether connections over the private AWS subnet are successful to talk to the Redis database
- Test whether public HTTP requests on the public internet can be initiated from the Lambda successfully

This repository is configured to use [VSCode's devcontainer support](https://code.visualstudio.com/docs/remote/containers) to allow for local, containerized testing a development. Once VSCode has started the container, exectute the following commands on the container CLI to start Redis:

```bash
apt-get update
apt-get install redis
redis-server
```

In VSCode, you can now press `F5` to launch the application or run `cd app && npm start` from a separate CLI window.

### Updating Infrastructure

The infrastructure that manages the AWS Cloud Resources lives in the [./terraform](./terraform) directory. This infrastructure can be deployed in the Actions tab of the repository. If it is the first time the infrastructure is being provisioned, a dummy Hello World application will be deployed to AWS as a placeholder.

All subsequent infrastructure changes can be deployed in the same way.

## CI/CD

This repository has two main ways to facilitate CI/CD built-in to GitHub-native workflows:

- Deploy Application: this workflow will package up the application code into a `.zip` file and deploy it to the running Lambda function via the AWS CLI
- Deploy Infrastructure: this workflow will utilize Terraform to apply the latest version of the infrastructure to the AWS Cloud

## Architecture

![](assets/architecture.svg)
