FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wget \
    e2fsprogs \
    dosfstools \
    parted \
    pigz \
    curl \
    xz-utils \
    udev \
    gzip

WORKDIR /pishrink

# Download latest PiShrink
RUN curl -Lo /usr/local/bin/pishrink https://raw.githubusercontent.com/Drewsif/PiShrink/master/pishrink.sh && chmod +x /usr/local/bin/pishrink

WORKDIR /data
ENTRYPOINT ["bash", "/usr/local/bin/pishrink"]
