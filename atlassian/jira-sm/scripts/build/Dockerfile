FROM atlassian/jira-servicemanagement:11.0.1

COPY patcher.jar /tmp
RUN cd /tmp && echo $(java -jar /tmp/patcher.jar /opt/atlassian/) && echo $(java -jar /tmp/patcher.jar /var/atlassian/)
