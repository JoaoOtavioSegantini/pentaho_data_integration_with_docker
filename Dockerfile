FROM openjdk:11-slim

# set pentaho data integration version (PDI)
ENV PENTAHO_VERSION 9.4.0.0-343
ENV PENTAHO_HOME /opt/pentaho

# set pentaho environment variables
ENV PENTAHO_JAVA_HOME $JAVA_HOME
ENV PENTAHO_JAVA_HOME /usr/local/openjdk-11
ENV JAVA_HOME=/usr/local/openjdk-11
ENV DISPLAY host.docker.internal:0.0
ENV KETTLE_HOME=$PENTAHO_HOME/pdi

# install necessary dependencies and clear cache
RUN apt-get update \
    && apt-get install -y \
    zip \
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

# install libwebkitgtk package, essencial for PDI running, 
# according to pentaho data integration README.txt
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 \
    && add-apt-repository 'deb [trusted=yes] http://cz.archive.ubuntu.com/ubuntu bionic main universe' \
    && apt-get update \
    && apt-get install -y libwebkitgtk-1.0-0 \
    && apt-get clean

# adds a non-root user to run the system
RUN addgroup --system pentaho && adduser --system pentaho --ingroup pentaho

# adds permission to user pentaho to run the system 
# in the folders where Pentaho will be installed
RUN mkdir -p ${PENTAHO_HOME} && chown -R pentaho:pentaho ${PENTAHO_HOME}

USER pentaho

# download and unzip PDI community edition
RUN sh -c "$(wget --progress=dot:giga- \
    https://privatefilesbucket-community-edition.s3.us-west-2.amazonaws.com/${PENTAHO_VERSION}/ce/client-tools/pdi-ce-${PENTAHO_VERSION}.zip \
    -O /tmp/pentaho-server-ce-${PENTAHO_VERSION}.zip)" \
    && unzip /tmp/pentaho-server-ce-${PENTAHO_VERSION}.zip -d ${PENTAHO_HOME} \
    && rm -f /tmp/pentaho-server-ce-${PENTAHO_VERSION}.zip \
    && chmod +x ${PENTAHO_HOME}/data-integration/spoon.sh

WORKDIR /opt/pentaho

EXPOSE 8080

CMD ["sh", "/opt/pentaho/data-integration/spoon.sh"]
