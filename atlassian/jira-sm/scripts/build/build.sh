#!/bin/bash

source '../run/.env'

docker build -t atlassian/jsm-patched:$IMAGE_VERSION ./

