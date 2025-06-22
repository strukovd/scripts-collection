docker run -d \
	--name mssql \
	-e 'ACCEPT_EULA=Y' \
	-e 'SA_PASSWORD=yourStrong(!)Password' \
	-e 'MSSQL_PID=Express' \
	-e TZ=GMT-6 \
	-e PGTZ=GMT-6 \
	-v /home/docker/mssql-data:/var/opt/mssql \
	-p 1433:1433 \
	mcr.microsoft.com/mssql/server:2017-latest-ubuntu
