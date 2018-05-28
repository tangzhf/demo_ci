FROM centos:7.4.1708
ADD gogs_0.11.43_linux_amd64.tar.gz /root
RUN yum -y install git && useradd -g root git && chown -R git.root /root/gogs && yum clean all && rm -rf /tmp/*
CMD su - git -c "/root/gogs/gogs web"