#
# MongoDB Dockerfile
#
# https://github.com/dockerfile/mariadb
#

# Pull base image.
FROM resin/rpi-raspbian:wheezy

# Creating mongodb user
RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

# Installing mongo to /opt/mongo
RUN apt-get update \
    && apt-get install -y curl \
    && sudo apt-get install -y p7zip-full \
    && curl -O http://facat.github.io/mongodb-2.6.4-arm.7z \
    && 7z x mongodb-2.6.4-arm.7z \
    && mv mongodb /opt/mongodb \
    && rm -f mongodb-2.6.4-arm.7z \
    && sudo chown -R mongodb /opt/mongodb \
    && apt-get purge -y --auto-remove curl p7zip-full \
    && rm -rf /var/lib/apt/lists/*

# Create the mongo data dirs
RUN sudo mkdir -p /data/db && \
    sudo chown mongodb /data/db

# Creating runtime directories under /var
RUN install -o mongodb -g mongodb -d /var/log/mongodb/ && \
    install -o mongodb -g mongodb -d /var/lib/mongodb/

# Installing config scripts
ADD mongodb.conf .
RUN install mongodb.conf /etc

VOLUME /data/db

EXPOSE 27017
CMD ["/opt/mongodb/bin/mongod"]
