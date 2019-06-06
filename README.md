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
  - docker run -i --rm --name hello-maven -v ${PWD}:/hello -w /hello maven
      mvn clean install
  - cp target/hello.war hello.war
  - docker run -i --rm --name hello-maven -v ${PWD}:/hello -w /hello maven
      mvn clean
  artifacts:
    paths:
    - hello.war
    expire_in: 1 week
 
deploy:stand:
  stage: deploy
  dependencies:
  - build_app
  script:
  - docker run -d --rm --name hello-tomcat-staging-${CI_COMMIT_SHA:0:8} -P
      -v ${PWD}/hello.war:/usr/local/tomcat/webapps/hello.war  
      tomcat:9.0-jre8-alpine
  - docker ps -f "name=hello-tomcat-staging-${CI_COMMIT_SHA:0:8}" --format '{{.Ports}}'
 
deploy:prod:
  stage: deploy
  when: manual
  dependencies:
  - build_app
  script:
  - docker run -d --rm --name hello-tomcat-production-${CI_COMMIT_SHA:0:8} -P
      -v ${PWD}/hello.war:/usr/local/tomcat/webapps/hello.war  
      tomcat:9.0-jre8-alpine
  - docker ps -f "name=hello-tomcat-production-${CI_COMMIT_SHA:0:8}" --format '{{.Ports}}'
```
