FROM ubuntu:22.04

LABEL \
    maintainer="Gianni" \
    org.opencontainers.image.base.name="ubuntu:22.04" \
    org.opencontainers.image.version="1.0.0" \
    org.opencontainers.image.title="Palworld Dedicated Server" \
    org.opencontainers.image.authors="Gianni, Tobias Trozowski <tobias@trozowski.com>"

ENV TZ=UTC \
    DEBIAN_FRONTEND=noninteractive \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en'

RUN set -eux; \
    \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -qy --no-install-recommends tzdata locales ca-certificates; \
    \
    ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime; \
    echo ${TZ} > /etc/timezone; \
    dpkg-reconfigure --frontend noninteractive tzdata; \
    { \
        echo "en_US.UTF-8 UTF-8"; \
    } | tee /etc/locale.gen; \
    locale-gen; \
    \
    apt-get autoremove -qy && apt-get clean -y && rm -rf /var/cache/debconf/*.dat-old && rm -rf /var/cache/apt/*;

RUN set -eux; \
    \
    echo steam steam/question select "I AGREE" | debconf-set-selections; \
    echo steam steam/license note '' | debconf-set-selections; \
    apt-get update; \
    apt-get install -qy --no-install-recommends steamcmd; \
    ln -sf /usr/games/steamcmd /usr/bin/steamcmd; \
    \
    apt-get autoremove -qy && apt-get clean -y && rm -rf /var/cache/debconf/*.dat-old && rm -rf /var/cache/apt/*;

RUN useradd -ms /bin/bash runner
WORKDIR /home/runner
USER runner

# Fix missing directories and libraries
RUN set -eux; \
    mkdir -p /home/runner/.steam; \
    steamcmd +quit; \
    ln -s /home/runner/.local/share/Steam/steamcmd/linux32 /home/runner/.steam/sdk32; \
    ln -s /home/runner/.local/share/Steam/steamcmd/linux64 /home/runner/.steam/sdk64; \
    ln -s /home/runner/.steam/sdk32/steamclient.so /home/runner/.steam/sdk32/steamservice.so; \
    ln -s /home/runner/.steam/sdk64/steamclient.so /home/runner/.steam/sdk64/steamservice.so;

#RUN steamcmd +force_install_dir /server +login anonymous +app_update 2394010 +quit;

COPY ./docker-entrypoint /docker-entrypoint

# Set default command
ENTRYPOINT ["/docker-entrypoint"]
CMD ["+help", "+quit"]