#  Whittaker

An AWS Lambda function that returns definitiosn from [Whittaker's Words](https://github.com/mk270/whitakers-words).

## Building the Image

This will create the lambda zip file you need to upload.

- `docker build -t whittaker .`

## Creating a Lambda Function

Run the container (the ENTRYPOINT uses the AWS cli) to upload the function to your account like this:

- `docker run -e AWS_ACCESS_KEY_ID=<access key> -e AWS_SECRET_ACCESS_KEY=<secret key> -e AWS_DEFAULT_REGION=<region> whittaker`