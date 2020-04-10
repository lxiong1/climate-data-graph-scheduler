#! /usr/bin/env bash

set -ex

mkdir -p public
gsutil cp gs://climate-data-files/climate_data_aggregate_graph.html public/index.html

IMAGE_NAME=climate-data-graph

docker build -t $IMAGE_NAME .
docker run --name $IMAGE_NAME-container -d -p 8080:80 $IMAGE_NAME
