#! /usr/bin/env bash

set -ex

sudo mkdir -p public
sudo gsutil cp gs://climate-data-files/climate_data_aggregate_graph.html public/

IMAGE_NAME=climate-data-graph

sudo docker build -t $IMAGE_NAME .
sudo docker run --name $IMAGE_NAME-container -d -p 8080:80 $IMAGE_NAME
