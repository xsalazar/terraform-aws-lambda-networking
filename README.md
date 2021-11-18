# Terraform/AWS Lambda Networking Boilerplate

This project is aimed at outlining a small AWS project in which a simple NodeJS application is deployed to a Lambda function.
An API Gateway will forward requests to the Lambda, which will then do a sanity check that it can access a Redis database in the private subnet. Additionally, it will check that it can initiate an HTTP request out to the public internet to verify the networking is correctly configured.

## Getting Started

- Clone this repo
- Ensure you have filled out the required [inputs](#inputs) below in the environment files
  - [Getting a Giphy API key](#Giphy-API-Key)
- Go to the `/app` directory and run `npm install`
- Go to the `/terraform` directory and run the following
  - `terraform init`
  - `terraform apply`

## Output

After running a successful `terraform apply`, the process will output the endpoint URL which can be used to access the sample application as well as the name of the underlying Lambda function.

```bash
api_endpoint = "https://hv72yq7w9h.execute-api.us-west-2.amazonaws.com"
lambda_function = "lambda-function"
```

## Architecture

![](assets/architecture.svg)
