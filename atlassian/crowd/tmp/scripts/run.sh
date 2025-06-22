docker run -d \
	--network=jiraBridge \
	-v $(pwd)/../data:/var/atlassian/application-data/crowd \
	--name="crowd" \
	-p 8095:8095 \
	atlassian/crowd
