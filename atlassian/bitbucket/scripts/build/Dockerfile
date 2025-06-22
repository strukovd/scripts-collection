FROM atlassian/bitbucket-server:latest

COPY patcher.jar /tmp
RUN cd /tmp
RUN echo $(java -jar /tmp/patcher.jar /opt/atlassian/)
RUN echo $(java -jar /tmp/patcher.jar /var/atlassian/)

