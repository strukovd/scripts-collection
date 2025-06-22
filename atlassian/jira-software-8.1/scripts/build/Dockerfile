FROM atlassian/jira-software:8.1
ARG PATCHER

COPY $PATCHER /tmp
RUN cd /tmp

RUN echo $(java -jar /tmp/$PATCHER /opt/atlassian/)
RUN echo $(java -jar /tmp/$PATCHER /var/atlassian/)
