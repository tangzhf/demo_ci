# demo_ci
 环境：
    centos7.4  minmimal安装
    docker CE
    
所需软件包：
    链接：https://pan.baidu.com/s/1nJt-rLG4WzK2mrwEzjbz7Q
    密码：tu7o

1、docker 配置 jenkins：
在 /root/ci_pkg 目录下编写dockerfile文件，内容为：

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

    在当前目录下构建docker镜像：
 [root@cen74 ci-pkg]# docker build -t  jenkins_docker:1.0 .
 
     启动构建的 docker 镜像：
[root@cen74 ci-pkg]# docker run --name jenkins_docker -p 8080:8080 -d jenkins_docker:1.0

配置 jenkins：
    在浏览器中打开 http://docker宿主机的IP:8080
    
    然后在记住页面中的密码文件路径，执行如下命令：
[root@cen74 ci-pkg]# docker exec ac5705ba5381 cat /root/.jenkins/secrets/initialAdminPassword 

7045f1264f714534822ccb006668ec51
容器ID 需用 docker ps 命令自行确认.

2、docker 配置 gogs
    构建mysql镜像：
    
[root@cen74 ci-pkg]# docker run --name mysql5.7 -e MYSQL_ROOT_PASSWORD=111111 -d mysql:5.7.22

    构建gogs镜像，编辑 dockerfile 文件，在文件中添加：
    
FROM centos:7.4.1708

ADD gogs_0.11.43_linux_amd64.tar.gz /root

RUN yum -y install git && useradd -g root git && chown -R git.root /root/gogs && yum clean all && rm -rf /tmp/*

CMD su - git -c "/root/gogs/gogs web"
 
    执行镜像构建命令：
[root@cen74 ci-pkg]# docker build -t gogs:1.0 .

    启动镜像文件：
[root@cen74 ci-pkg]# docker run --name gogs  --link mysql5.7:mysql -p 3000:3000 -d  gogs:1.0
注意： gogs运行需要 mysql 数据库。
    初始化mysql：
    
[root@cen74 ci-pkg]# docker cp gogs:/root/gogs/scripts/mysql.sql .

[root@cen74 ci-pkg]# docker exec -i mysql5.7 mysql -uroot -p111111 <mysql.sql

配置gogs：
    在浏览器中输入：http://docker宿主机IP:3000 ，在弹出页面中：
    
数据库设置=》数据库用户密码：111111

            数据库主机：172.0.0.2
                        
应用基本设置=》运行系统用户：root

              域名：docker宿主机IP
                            
              应用URL：把localhost 换成 docker宿主机IP
