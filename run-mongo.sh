#!/bin/bash

docker run -d --name=test_mongodb \
	-p 27017:27017 \
	-e TZ=Asia/Bishkek \
	-e PGTZ=Asia/Bishkek \
	-e MONGO_INITDB_ROOT_USERNAME=admin \
	-e MONGO_INITDB_ROOT_PASSWORD=password \
	mongo

	#	-v "$(pwd)/../../msdata/mongo-db/data/":/data/db \
	#	--network test_bridge \
