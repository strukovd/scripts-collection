FROM atlassian/jira-servicedesk:latest

#USER root:root
COPY patcher.jar /tmp
RUN cd /tmp
RUN echo $(java -jar /tmp/patcher.jar /opt/atlassian/)
RUN echo $(java -jar /tmp/patcher.jar /var/atlassian/)
#USER daemon:daemon
