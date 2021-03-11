# AS.Public.DevopsTest

This repository contains simple dummy `.NET Core` application that will be used for simple knowledge test for DevOps candidates. 

## About Application
This is dummy application that write and read some keys to/from Redis. The application is written using `dotnet 3.1 sdk`  The application has one simple Unit test. We need to use this test in our CI. We also can configure connection string to Redis using EnvironmentVariable.
Application has one endpoint `http(s)://url:port/WeatherForecast`. It accepts `POST` and `GET`. POST will add some random forecast to Redis, GET - will display all results from Redis. No additional parameters are needed in requests.

## Test Tasks
1. Dockerfile
2. docker-compose.yaml
3. CI spec file
4. Kubernetes yaml files

All tasks above are optional. Pay attention that writing Dockerfile is essential task other ones depend on it. You can complete all or several steps and then demonstrate results or it will be even enough to write some code or concept from your mind and explain it on the interview. 

Some exclusions: 

* You might not have public/private docker repository to push your image in.
* You may not have MiniKube on your local environment nor kubernetes cluster to test your k8s yaml specs.

That's totally fine. You can write in your code comments like: 

> \# Here we push image to docker hub or ECR
> \# echo "docker push \<something\>"
    
### 1. Dockerfile
We need to have our application containerized. It is preferable to use multi-stage docker build. The target docker image should not have source codes, only an executable artifact. 

### 2. Docker compose
It will be good to have docker-compose.yaml for smoke test our application. Docker-compose should be based on Dockerfile from previous step.  `docker-compose up` should spin containers up with application and Redis. Application should be configured to communicate with Redis. Expose some port to request application via HTTP.

### 3. CI spec
It is preferable to use buildspec.yml (AWS CodeBuild), but not mandatory. You can use any familiar or available for you CI specification files (e.g. Github Action, bamboo spec, Gitlab spec, etc). We need several simple steps for CI: 

1. test
2. build/pack/publish
3. push artifact
 
Running Unit test can be as step in CI spec or as RUN command in Dockerfile, if you use multi-stage docker build.

### 4. Kubernetes specs
Please write yaml files to deploy current application to Kubernetes. 
We need to have next configured resources:

* ingress
* deployment
* service
* HPA (from 2 to 3 replicas)
* service-account

You do not need to think about HTTPS. You can use HTTP for ingress.