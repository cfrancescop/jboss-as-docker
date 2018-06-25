# This is the Dockerfile for JBOSS AS 7.1.1.Final
#
# IMPORTANT
# ---------
# The resulting image of this Dockerfile DOES NOT contain a JBOSS Domain.
# You will need to create a domain on a new inherited image.
#
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) jdk-7u79-linux-x64.rpm.bin
#     Download from http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm

FROM openjdk:7-jre
LABEL maintainer "c.francesco.p@gmail.com"

# define working directory
ENV JBOSS_HOME /usr/local/jboss
WORKDIR $JBOSS_HOME
# User root user to install  & run software
USER root

ENV JBOSS_URL http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz
RUN set -x && mkdir -p "$JBOSS_HOME" \
&& wget -O jboss.tar.gz "$JBOSS_URL" \
&& tar -xvf jboss.tar.gz \
&& cp -r jboss-as-7.1.1.Final/* ./ \
&& rm -r jboss-as-7.1.1.Final \
&& rm jboss.tar.gz* 


# Expose ports for AJP,HTTP and Web Console
EXPOSE 8009
EXPOSE 8080
EXPOSE 9990
# we create a persistence volume for deployments and for configuration so we can store local changes
VOLUME /usr/local/jboss/standalone/deployments
VOLUME /usr/local/jboss/standalone/configuration
ENTRYPOINT exec bin/standalone.sh -Djava.security.egd=file:/dev/./urandom -b=0.0.0.0 -bmanagement=0.0.0.0
