#!/bin/bash

if [[ -z "$bucket" || -z "$date" ]]; then
    echo "Missing arguments!" 1>&2
    exit 1
fi

git clone https://github.com/whd/telemetry-batch-view.git
cd telemetry-batch-view
git checkout test_longitudinal
sbt assembly
spark-submit --executor-cores 8 \
             --conf spark.memory.useLegacyMode=true \
             --conf spark.storage.memoryFraction=0 \
             --master yarn \
             --deploy-mode client \
             --class com.mozilla.telemetry.views.LongitudinalView \
             target/scala-2.11/telemetry-batch-view-1.1.jar \
             --to 20170111 \
             --bucket net-mozaws-prod-us-west-2-pipeline-analysis
