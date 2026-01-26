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

# Drop back to the Jenkins user
USER jenkins



#docker run -d --name jenkins-dind ^ 
#--privileged ^ 
#-p 8080:8080 -p 5000:5000 ^ 
# -v //var/run/docker.sock:/var/run/docker.sock ^ 
# -v jenkins_home:/var/jenkins_home ^ 
# jenkins-dind -