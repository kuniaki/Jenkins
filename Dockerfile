FROM jenkins/jenkins:2.263.1-lts-slim

#install Plugin
COPY plugin.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugin.txt

USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common

COPY ./jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod 0775 /usr/local/bin/jenkins.sh

ENV PATH $PATH:/usr/local/bin

USER jenkins
ENV JAVA_OPTS -Djava.awt.headless=true -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Tokyo -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8
Expose 8080 50000
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
