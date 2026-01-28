# Jenkins LTS base (Debian)
FROM jenkins/jenkins:lts

# You need root to apt-get in this image
USER root

# Install Docker CLI (not the daemon) the modern way
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/debian/gpg \
      | gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
    chmod a+r /etc/apt/keyrings/docker.gpg; \
    . /etc/os-release; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian ${VERSION_CODENAME} stable" \
      > /etc/apt/sources.list.d/docker.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin; \
    rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI (gcloud)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends ca-certificates curl gnupg; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
      | gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg; \
    chmod a+r /etc/apt/keyrings/cloud.google.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
      > /etc/apt/sources.list.d/google-cloud-sdk.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends google-cloud-cli; \
    rm -rf /var/lib/apt/lists/*

# Allow Jenkins user to use Docker CLI (expects docker.sock mounted with docker group)
RUN set -eux; \
    groupadd -f docker; \
    usermod -aG docker jenkins

# Allow Jenkins user to run root commands (sudo without password)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends sudo; \
    rm -rf /var/lib/apt/lists/*; \
    echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins; \
    chmod 0440 /etc/sudoers.d/jenkins

# Align docker group to host socket GID at runtime, then start Jenkins
COPY custom_jenkins/entrypoint.sh /usr/local/bin/jenkins-entrypoint.sh
RUN chmod +x /usr/local/bin/jenkins-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/jenkins-entrypoint.sh"]



#docker run -d --name jenkins-dind ^ 
#--privileged ^ 
#-p 8080:8080 -p 5000:5000 ^ 
# -v //var/run/docker.sock:/var/run/docker.sock ^ 
# -v jenkins_home:/var/jenkins_home ^ 
# jenkins-dind -
