FROM sandbox-hdp

# Download and Install Apache Kylin 
RUN sudo yum install wget -y
RUN wget https://archive.apache.org/dist/kylin/apache-kylin-2.1.0/apache-kylin-2.1.0-bin-hbase1x.tar.gz 
RUN tar -xf apache-kylin-2.1.0-bin-hbase1x.tar.gz
RUN mv apache-kylin-2.1.0-bin-hbase1x /usr/local
RUN cd /usr/local && ln -s ./apache-kylin-2.1.0-bin-hbase1x kylin
ENV KYLIN_HOME /usr/local/kylin

