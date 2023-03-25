FROM ubuntu

### Install openssh, java and its dependencies
RUN apt-get update \
 && apt-get -y install --no-install-recommends openssh-server git curl ca-certificates default-jre default-jdk sudo vim \
 && mkdir -p /var/run/sshd

### Create and configure 'jenkins' user
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins \
 && mkdir -p /home/jenkins/.ssh \
 && chmod 700 /home/jenkins/.ssh

RUN ssh-keygen -b 2048 -t rsa -f /home/jenkins/.ssh/id_rsa -q -N "" \
 && cat /home/jenkins/.ssh/id_rsa.pub >> /home/jenkins/.ssh/authorized_keys \
 && chmod 600 /home/jenkins/.ssh/authorized_keys \
 && chown -R jenkins:jenkins /home/jenkins/.ssh

### Install openCV requirements
RUN apt install -y cmake g++ wget unzip

### SSH port
EXPOSE 22

### Default command
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
