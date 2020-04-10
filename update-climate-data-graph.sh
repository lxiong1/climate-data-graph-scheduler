#! /usr/bin/env bash

set -ex

mkdir -p public
gsutil cp gs://climate-data-files/climate_data_aggregate_graph.html public/index.html

IMAGE_NAME=climate-data-graph
CONTAINER_NAME=$IMAGE_NAME-container
LIST_CONTAINERS=$(docker container ls -a)

docker build -t $IMAGE_NAME .

if grep "$CONTAINER_NAME" <<< $LIST_CONTAINERS; then
    docker container stop $CONTAINER_NAME
    docker container rm $CONTAINER_NAME
fi

docker run --name $CONTAINER_NAME -d -p 8080:80 $IMAGE_NAME

TEMP_CRONJOB_FILE=cronjob

echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" > $TEMP_CRONJOB_FILE
echo "30 21 * * * cd climate-data-graph-scheduler && ./update-climate-data-graph.sh >/dev/null 2>&1" >> $TEMP_CRONJOB_FILE
crontab $TEMP_CRONJOB_FILE
rm $TEMP_CRONJOB_FILE
