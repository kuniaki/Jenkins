FROM jenkins/jenkins:2.263.1-lts-slim
USER root
RUN apt-get update && apt-get install -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose \
&& chmod +x /usr/local/bin/docker-compose \
&& curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl
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
