# Udagram
The Udagram application monorepo

[![Build Status](https://travis-ci.org/Drew-Kimberly/Udagram.svg?branch=master)](https://travis-ci.org/Drew-Kimberly/Udagram)
[![lerna](https://img.shields.io/badge/maintained%20with-lerna-cc00ff.svg)](https://lerna.js.org/)

## Table of Contents
 - [Packages](#packages)
 - [Development](#development)
 - [Deployment](#deployment)

## Packages
The Udagram source code is maintained using the "[monorepo](https://en.wikipedia.org/wiki/Monorepo)"
 strategy with [Lerna](https://github.com/lerna/lerna). Therefore, each component of the application
 is split into its own package. The packages are:
 
[Frontend App](https://github.com/Drew-Kimberly/udagram-frontend)

[Feed API Service](https://github.com/Drew-Kimberly/udagram-feed-svc)

[User API Service](https://github.com/Drew-Kimberly/udagram-user-svc)

[Nginx Reverse-Proxy](https://github.com/Drew-Kimberly/udagram-reverse-proxy)

[Authentication Library](https://github.com/Drew-Kimberly/udagram-auth)

While each package is split out into its own repository, the _source-of-truth_ is always
the monorepo.

## Development

### Requirements
__Required__:
- [NodeJS](https://nodejs.org/en/download/) (v10.x or greater)
- [Ionic CLI](https://ionicframework.com/docs/installation/cli)
- [Docker](https://docs.docker.com/get-docker/)

__Recommended__:
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (v2.x)
- [Postman](https://www.postman.com/downloads/)

### Installing Dependencies
Once the repository is cloned and all requirements are installed, run:
```shell script
npm i
```
This will install all project dependencies and bootstrap/hoist packages using Lerna.

### Environment Variables
The following environment variables are required to run the Udagram application locally:

#### `UDAGRAM_AWS_REGION`
The AWS region where Udagram resources are deployed, i.e. `us-east-1`.

#### `UDAGRAM_AWS_PROFILE`
The AWS CLI profile to use. Profiles are configured at `~/.aws/credentials`.

#### `UDAGRAM_DB_USER`
The username to use when connecting to the Udagram RDS database.

#### `UDAGRAM_DB_PASSWORD`
The password to use when connecting to the Udagram RDS database.

#### `UDAGRAM_DB_NAME`
The name of the Udagram RDS database.

#### `UDAGRAM_DB_HOST`
The hostname of the Udagram RDS database.

#### `UDAGRAM_DB_DIALECT`
The dialect of the Udagram RDS database, i.e. `postgres`.

#### `UDAGRAM_S3_BUCKET`
The name of the AWS S3 bucket used for storing Udagram images.

#### `UDAGRAM_JWT_KEY`
The JWT Key secret used for Udagram API auth.

Before starting the application, please request a `.env` file that contains the
default values for these env variables and place this file at the root of this
repository.

### Running the application
[Docker Compose](https://docs.docker.com/compose/) is used to run the application during local development. Run:
```shell script
docker-compose up
```
This will start all containers with local packages mounted into the container so a nice DX
with hot reloading is provided.

#### Accessing the Web Application
Once the application containers are running, you can access the frontend web client in your browser
at `http://localhost:8100`.

#### Accessing the API
Once the application containers are running, you can access the API at `http://localhost:8080/api/{version}/{resource}`.

##### Postman
Postman collections/environments for the API are located in the `postman/` directory at the root of this repo.
You can import these to facilitate development/testing of the API. Use the `udagram_local` environment for local development.

### Application Images
Each application component is packaged into a container image. These images are regularly built and pushed
to the Docker Registry. You can check out each image:
- [uncledrewbie/udagram-frontend](https://hub.docker.com/r/uncledrewbie/udagram-frontend)
- [uncledrewbie/udagram-reverse-proxy](https://hub.docker.com/r/uncledrewbie/udagram-reverse-proxy)
- [uncledrewbie/udagram-feed-svc](https://hub.docker.com/r/uncledrewbie/udagram-feed-svc)
- [uncledrewbie/udagram-user-svc](https://hub.docker.com/r/uncledrewbie/udagram-user-svc)

#### Building Images
To locally build the application images, you can run:
```shell script
npm run build-images ${TAG}
```
where `TAG` is the image tag that will be used. If `TAG` is omitted, the images will
just use the `latest` tag.

### Additional Commands/Tooling
Please consult the `scripts` section of the root `package.json` file for available commands.
There you'll find many helper scripts for linting/testing/building/etc the codebase, as well as
pre-scoped commands for each package maintained by Lerna.


## Deployment
The Udagram app is hosted in AWS using [EKS](https://aws.amazon.com/eks/).
The web application can be accessed at https://udagram-dev.com.
The API can be accessed at https://api.udagram-dev.com.

_Given the cost of EKS and that this is a toy application, those domains are not guaranteed to be available._

### Kubernetes Resources
The Kubernetes resources for each Udagram service are defined in
`./k8s/apps/${APP}`. Notice that the service definitions for the `frontend`
and `reverse-proxy` applications have `type: LoadBalancer`. This results in a
classic load balancer being provisioned in AWS for each service that acts as
the entrypoint for external (public) HTTP traffic.

### Kubernetes Deployment Scripts
Scripts for working with the K8s resources are provided at `./k8s/`:

#### `deploy.sh`
Deploys all K8s resources for all apps using `kubectl`. Accepts a single parameter that is the
application image tag (defaults to `latest`) to deploy.

#### `destroy.sh`
Destroys all K8s resources for all apps using `kubectl`.

___WARNING__: Destroying the service resource in EKS will deprovision the ELBs in AWS.
This will expose the fact that the AWS environment is not truly ephemeral as the 
ELBs are configured in Route53 Record Sets for the udagram-dev.com Hosted Zone!_

### CI/CD
CI/CD is handled by [TravisCI](). The configuration for TravisCI can be found
[here](./.travis.yml), with helper scripts available in the repository [here](./scripts/travisci).

Every push/PR goes through CI, which performs the following stages:

#### Compile
The CI job executes `npm run build:prod` which compiles all Udagram packages.
See `./scripts/travisci/compile.sh`.

#### Test
The CI job executes `npm run ci` which performs validation/tests across all Udagram packages.
See `./scripts/travisci/test.sh`.


When commits are merged into the `master` branch, additional jobs are run in the TravisCI pipeline:

#### Monorepo Split
Packages that have updates are split out into each packages' read-only GitHub repository
using the `git subtree` command.
See `./scripts/travisci/monorepo-split.sh`.

#### Build and Push Images
Each Udagram application image is built and tagged both as `latest` and the most recent git commit SHA.
Each image is then pushed to its respective repository in the Docker Hub registry.
See `./scripts/travisci/build-app-images.sh`.

#### Deploy
Each Udagram application is deployed to the udagram-dev AWS EKS cluster.
This requires/uses `kubectl` and the AWS CLI to configure the `~/.kube/config` file
so that the cluster can be reached via API. The latest commit sha is used as the application
image tag for each K8s deployment resource.

After all K8s resources have been applied to the EKS cluster, the deploy script uses
`kubectl rollout status` to wait for the rollout of each application to complete before
considering the CD stage complete.
See `./scripts/travisci/deploy.sh`. 

#### Integration Test
Postman's Newman CLI tool is used to execute integration tests (live API requests)
against the deployed Udagram application.
