FROM sandbox-hdp

# https://stackoverflow.com/questions/46286326/cannot-retrieve-repository-metadata-repomd-xml-for-repository-sandbox-please
# Fixed http://dev2.hortonworks.com.s3.amazonaws.com/repo/dev/master/utils/repodata/repomd.xml: [Errno 14] PYCURL ERROR 22 - "The requested URL returned error: 403 Forbidden"
RUN mv /etc/yum.repos.d/sandbox.repo /tmp

# Install wget
RUN sudo yum install wget -y
RUN mv /tmp/sandbox.repo /etc/yum.repos.d

# Download and Install Apache Kylin 
RUN wget https://archive.apache.org/dist/kylin/apache-kylin-2.1.0/apache-kylin-2.1.0-bin-hbase1x.tar.gz 
RUN tar -xf apache-kylin-2.1.0-bin-hbase1x.tar.gz
RUN mv apache-kylin-2.1.0-bin-hbase1x /usr/local
RUN cd /usr/local && ln -s ./apache-kylin-2.1.0-bin-hbase1x kylin
ENV KYLIN_HOME /usr/local/kylin

