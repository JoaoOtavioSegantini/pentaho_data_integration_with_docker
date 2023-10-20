FROM openjdk:11-slim

ENV PENTAHO_VERSION 9.4.0.0-343
ENV PENTAHO_HOME /opt/pentaho

ENV PENTAHO_JAVA_HOME $JAVA_HOME
ENV PENTAHO_JAVA_HOME /usr/local/openjdk-11
ENV JAVA_HOME=/usr/local/openjdk-11
ENV DISPLAY host.docker.internal:0.0

RUN apt-get update \
    && apt-get install -y zip \
    wget \
    unzip \
    git \
    vim \
    libwebkit2gtk-4.0-37 \
    gnupg \
    gnupg2 \
    gnupg1 \
    libgtk2.0-0 \
    libswt-gtk-4-java \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN apt-get update \
    && apt-get install -qq software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
    && add-apt-repository 'deb [trusted=yes] http://cz.archive.ubuntu.com/ubuntu bionic main universe' \
    && apt-get update \
    && apt-get install -qq libwebkitgtk-1.0-0


RUN /usr/bin/wget --progress=dot:giga \
    "https://privatefilesbucket-community-edition.s3.us-west-2.amazonaws.com/${PENTAHO_VERSION}/ce/client-tools/pdi-ce-${PENTAHO_VERSION}.zip" \
    -O /tmp/pentaho-server-ce-${PENTAHO_VERSION}.zip; \
    /usr/bin/unzip -q /tmp/pentaho-server-ce-${PENTAHO_VERSION}.zip -d ${PENTAHO_HOME}; \
    rm -f /tmp/pentaho-server-ce-${PENTAHO_VERSION}.zip; \
    chmod +x /opt/pentaho/data-integration/spoon.sh;

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown -R pentaho:pentaho ${PENTAHO_HOME}/data-integration;

#USER pentaho

WORKDIR /opt/pentaho

EXPOSE 8080 8009

CMD ["sh", "/opt/pentaho/data-integration/spoon.sh"]
