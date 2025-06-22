FROM atlassian/crowd:latest
ARG PATCHER

COPY $PATCHER /tmp
RUN cd /tmp

RUN echo $(java -jar /tmp/$PATCHER /opt/atlassian/)
RUN echo $(java -jar /tmp/$PATCHER /var/atlassian/)
