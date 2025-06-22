docker run -d \
	--link=postgres:postgres \
	-e TZ=Asia/Bishkek \
	-v $(pwd)/../data:/var/atlassian/application-data/crowd \
	-v /etc/localtime:/etc/localtime \
	--name="crowd" \
	-p 8095:8095 \
	atlassian/crowd

# -v $(pwd)/../tomcat-conf:/opt/atlassian/crowd/apache-tomcat/conf \

