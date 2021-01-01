FROM jenkins/jenkins:2.263.1-lts-slim
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common

COPY --chown=jenkins:jenkins ./id_rsa /tmp/id_rsa
COPY --chown=jenkins:jenkins ./id_rsa.pub /tmp/id_rsa.pub
COPY ./jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod 0600 /tmp/id_rsa && chmod 0600 /tmp/id_rsa.pub \
    && chmod 0775 /usr/local/bin/jenkins.sh

ENV PATH $PATH:/usr/local/bin

USER jenkins
ENV JAVA_OPTS -Djava.awt.headless=true -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Tokyo -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8
Expose 8080 50000
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
