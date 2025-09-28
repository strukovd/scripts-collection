FROM atlassian/jira-software:9.12.6-jdk17

COPY patcher.jar /tmp
RUN cd /tmp && echo $(java -jar /tmp/patcher.jar /opt/atlassian/) && echo $(java -jar /tmp/patcher.jar /var/atlassian/)
