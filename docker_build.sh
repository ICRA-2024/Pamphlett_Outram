#!/usr/bin/env bash

# https://github.com/pythonprofilers/memory_profiler
# https://forums.docker.com/t/capture-ouput-of-docker-build-into-a-log-file/123178

#mprof run --include-children --multiprocess \
#  docker build -t pamphlett_outram --no-cache --progress=plain . &> docker_build.log

docker build -t pamphlett_outram .

