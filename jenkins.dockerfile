FROM centos:7.4.1708
ADD apache-maven-3.5.3-bin.tar.gz /usr/local
ADD jdk-8u161-linux-x64.tar.gz /usr/local
COPY jenkins.war /root
ENV JAVA_HOME /usr/local/jdk1.8.0_161
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV MAVEN_HOME /usr/local/apache-maven-3.5.3
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin
RUN yum -y install git && yum clean all && rm -rf /tmp/* 
CMD java -jar /root/jenkins.war 