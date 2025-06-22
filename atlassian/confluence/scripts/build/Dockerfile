FROM atlassian/confluence-server:latest
ARG PATCHER

COPY $PATCHER /tmp
RUN cd /tmp

RUN echo $(java -jar /tmp/patcher.jar /opt/atlassian/)
RUN echo $(java -jar /tmp/patcher.jar /var/atlassian/)
