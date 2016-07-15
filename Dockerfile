FROM resin/raspberrypi2-alpine:3.4
MAINTAINER MTRNord <mtrnord1@gmail.com>

# Hangoutsbot version
ENV HOB_VERSION 2.7.9

# Create Hangoutsbot directories
RUN mkdir -p /opt/hangoutsbot /etc/hangoutsbot
VOLUME /etc/hangoutsbot
# Set Hangoutsbot archive URL
ENV TARBALL_URL https://api.github.com/repos/hangoutsbot/hangoutsbot/tarball/${HOB_VERSION}

# Download and extract Hangoutsbot archive and install dependencies
RUN apk add --update ca-certificates gcc git python3-dev tar wget dropbear\
    && wget -qO- ${TARBALL_URL} | tar -xz --strip-components=1 -C /opt/hangoutsbot \
    && wget -qO- https://bootstrap.pypa.io/get-pip.py | python3 \
    && pip3 install --no-cache-dir -r /opt/hangoutsbot/requirements.txt \
    && apk del --purge gcc git tar wget && rm -rf /var/cache/apk/*

RUN mkdir /etc/dropbear
RUN touch /var/log/lastlog

COPY . /app
WORKDIR /app
CMD ["/bin/sh", "/app/start"]
