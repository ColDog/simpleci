#!/usr/bin/env bash

docker network create simpleci-net
docker build -t simpleci .

docker run -i -d \
    -e MYSQL_USER=dbuser \
    -e MYSQL_PASSWORD=pass \
    -e MYSQL_ROOT_PASSWORD=pass \
    -e MYSQL_DATABASE=simpleci \
    --net simpleci-net \
    --net-alias simpleci_db \
    --name simpleci_db \
    mysql:5.7

#sleep 45

docker stop simpleci
docker rm simpleci
docker run -i \
    -e DB_HOST=simpleci_db \
    -e RAILS_ENV=production \
    -e SECRET_KEY_BASE=secret \
    -e DB_USER=dbuser \
    -e DB_PASS=pass \
    -e PORT=3000 \
    -e GITHUB_KEY=$GITHUB_KEY \
    -e GITHUB_SECRET=$GITHUB_SECRET \
    --name simpleci \
    --net simpleci-net \
    --net-alias simpleci \
    -p 3000:3000 \
    simpleci

docker run -i -d \
    -e DB_HOST=simpleci_db \
    -e RAILS_ENV=production \
    -e SECRET_KEY_BASE=secret \
    -e DB_USER=dbuser \
    -e DB_PASS=pass \
    -e PORT=3000 \
    -e GITHUB_KEY=$GITHUB_KEY \
    -e GITHUB_SECRET=$GITHUB_SECRET \
    --name simpleci-worker \
    --net simpleci-net \
    --net-alias simpleci-worker \
    simpleci \
    rails worker:events

sleep 5

docker stop minion1
docker rm minion1
docker run -i \
    -e MINION_AWS_ACCESS_KEY=$AWS_ACCESS_KEY_ID \
    -e MINION_AWS_SECRET_KEY=$AWS_SECRET_KEY_ID \
    -e SIMPLECI_API=http://simpleci:3000 \
    -e MINION_API=http://localhost:8000 \
    -e SIMPLECI_SECRET=secret \
    -e SIMPLECI_KEY=minion \
    -e MINION_S3_BUCKET=simplecistorage \
    -e MINION_S3_REGION=us-west-2 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --net simpleci-net \
    --net-alias minion1 \
    --name minion1 \
    -p 8000:8000 \
    coldog/simpleci-runner:latest
