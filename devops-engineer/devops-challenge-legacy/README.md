## DevOps Challenge

The team is trying to deploy a simple "hello world" app on AWS ECS (elastic container service),
but they're having some issues. Write a script (Makefile, bash, etc. - any language you choose)
that will build the application image, push the image to an ECR repo, deploy the application,
and check that the application is running correctly. The script should contain the steps below.

You'll be given credentials to our [sandbox AWS account](https://oddball-interviews.signin.aws.amazon.com/console),
which will be valid only during the interview.

- API key id and secret
- console username and password

### Prerequisites
1. [Terraform](https://www.terraform.io/downloads) - v0.13 or greater (direct install or via [tfenv](https://github.com/tfutils/tfenv/blob/master/README.md))
2. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3. [Docker](https://docs.docker.com/get-docker/)

### Steps

1. Deploy the ECR from `terraform/bootstrap` to have a place to push images to. You may want to
add outputs here to reference the repo name in your script.
1. Build the image in `app`. An engineer was trying to create a file "version.txt" that is exposed
via an endpoint, it worked for them locally, when they created the file, but they are struggling
to make it work when the Docker image is built.
1. Push images to the new ECR repos. You'll need to do a docker login for this, which should also
be part of the script.
1. Deploy the ECS from `terraform/app`, debugging as necessary.
1. Check that `/version` endpoint returns the current Git commit SHA

### Stretch goal

The team would like to use scheduled Application AutoScaling to have higher capacity (8 instances
of the task definition instead of 1) during peak hours (5:00 to 11:00 UTC). Add this ability via
Terraform.
