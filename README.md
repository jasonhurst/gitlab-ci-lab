# java-servlet-hello
Hello world web application with Maven + Java + Servlets + Tomcat

## Compile app 
```
mvn clean install
```
The compiled file will been stored in `target` folder as `hello.war`

## Run app 
```
mvn tomcat7:run
```
The servlet can be executed in browser by path `http://localhost:8081/hello`

## Run in docker
After compile app just run next
```
docker run -i --rm --name hello-app -p 8081:8080 \
  -v ${PWD}/target/hello.war:/usr/local/tomcat/webapps/hello.war \
  tomcat:9.0-jre8-alpine
```
And for opening the Servlet run in browser `http://localhost:8081/hello/hello`

## Gitlab CI Yaml File
This file can be used in conjunction with Gitlab in order to automate a build, then a deploy to staging along with a deploy to production with a shell executor running Docker.
```
stages:
  - build
  - deploy
 
build_app:
  stage: build
  dependencies: []
  script:
  - docker run -i --rm --name hello-maven --user $(id -u gitlab-runner):$(id -g gitlab-runner) -v ${PWD}:/hello -w /hello maven
      mvn clean install
  - cp target/hello.war hello.war
  - docker run -i --rm --name hello-maven -v ${PWD}:/hello -w /hello maven
      mvn clean
  artifacts:
    paths:
    - hello.war
    expire_in: 1 week

deploy:stage:
  stage: deploy
  dependencies:
  - build_app
  script:
  - if [[ $(docker ps -a | grep hello-tomcat-staging) ]]; then docker stop hello-tomcat-staging; fi
  - docker run -p 84:8080 -d --rm --name hello-tomcat-staging -P 
      -v ${PWD}/hello.war:/usr/local/tomcat/webapps/hello.war  
      tomcat:9.0-jre8-alpine
  - docker ps -f "name=hello-tomcat-staging" --format '{{.Ports}}'
 
deploy:prod:
  stage: deploy
  when: manual
  dependencies:
  - build_app
  script:
  - if [[ $(docker ps -a | grep hello-tomcat-production) ]]; then docker stop hello-tomcat-production; fi
  - docker run -p 80:8080 -d --rm --name hello-tomcat-production -P
      -v ${PWD}/hello.war:/usr/local/tomcat/webapps/hello.war  
      tomcat:9.0-jre8-alpine
  - docker ps -f "name=hello-tomcat-production" --format '{{.Ports}}'
```
