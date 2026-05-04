FROM clover/base AS base

RUN groupadd \
        --gid 50 \
        --system \
        chromium \
 && useradd \
        --home-dir /tmp \
        --no-create-home \
        --system \
        --shell /bin/false \
        --uid 50 \
        --gid 50 \
        chromium

FROM library/debian:stable-slim AS build

ENV LANG=C.UTF-8

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update

RUN mkdir -p /build
WORKDIR /build
RUN apt-get download \
    libatomic1 \
    libudev1 \
    libx11-xcb1 \
    libasound2t64 \
    libatk1.0-0t64 \
    libatk-bridge2.0-0t64 \
    libatspi2.0-0t64 \
    libcairo2 \
    libcups2t64 \
    libdav1d7 \
    libdouble-conversion3 \
    libdbus-1-3 \
    libexpat1 \
    libgdk-pixbuf-2.0-0 \
    libglib2.0-0t64 \
    libgtk-3-0t64 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libuuid1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libxau6 \
    libxdmcp6 \
    libffi8 \
    libgssapi-krb5-2 \
    libgnutls30t64 \
    libgmp10 \
    libharfbuzz-subset0 \
    libhogweed6t64 \
    libjpeg62-turbo \
    libp11-kit0 \
    libtasn1-6 \
    libunistring5 \
    libcom-err2 \
    libk5crypto3 \
    libkrb5-3 \
    libkrb5support0 \
    libidn2-0 \
    liblcms2-2 \
    libldap2 \
    libgssapi3t64-heimdal \
    libasn1-8t64-heimdal \
    libhcrypto5t64-heimdal \
    libheimbase1t64-heimdal \
    libheimntlm0t64-heimdal \
    libwind0t64-heimdal \
    libkrb5-26t64-heimdal \
    libhx509-5t64-heimdal \
    libsqlite3-0 \
    libroken19t64-heimdal \
    libsasl2-2 \
    libsasl2-modules-db \
    libldap-common \
    libnettle8t64 \
    libavahi-common3 \
    libavahi-client3 \
    libsystemd0 \
    libmount1 \
    libminizip1t64 \
    libmp3lame0 \
    libmpg123-0t64 \
    libfontconfig1 \
    libpangoft2-1.0-0 \
    libfreetype6 \
    libthai0 \
    libpixman-1-0 \
    libpng16-16t64 \
    libxcb-shm0 \
    libxcb-render0 \
    libcairo-gobject2 \
    libepoxy0 \
    libxinerama1 \
    libxkbcommon0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    libwayland-client0 \
    libbsd0 \
    liblzma5 \
    liblz4-1 \
    libgcrypt20 \
    libblkid1 \
    libharfbuzz0b \
    libdatrie1 \
    libkeyutils1 \
    libgpg-error0 \
    libgraphite2-3 \
    libpulse0 \
    libwrap0 \
    libsndfile1 \
    libasyncns0 \
    libflac14 \
    libogg0 \
    libopenh264-8 \
    libopenjp2-7 \
    libopus0 \
    libvorbis0a \
    libvorbisenc2 \
    libmd0 \
    libdrm2 \
    libgbm1 \
    libwayland-server0 \
    libfribidi0 \
    libzstd1 \
    libbrotli1 \
    libcurl4t64 \
    libnghttp2-14 \
    librtmp1 \
    libssh2-1t64 \
    libpsl5t64 \
    fontconfig-config \
    libunwind8 \
    libx11-data \
    libxnvctrl0 \
    fonts-liberation \
    chromium \
    chromium-common \
    chromium-driver

RUN find *.deb | xargs -I % dpkg-deb -x % /rootfs \
 && rm -Rf *.deb

WORKDIR /rootfs

RUN rm -rf \
    etc/chromium* \
    etc/cron* \
    etc/fonts/conf.d/README \
    usr/share/X11 \
    usr/share/appdata \
    usr/share/applications \
    usr/share/bug \
    usr/share/chromium \
    usr/share/doc \
    usr/share/doc-base \
    usr/share/gnome-control-center \
    usr/share/icons \
    usr/share/libgcrypt20 \
    usr/share/lintian \
    usr/share/locale \
    usr/share/man \
    usr/share/menu \
    usr/share/pixmaps \
 && echo > etc/ldap/ldap.conf \
 && echo > etc/pulse/client.conf

COPY --from=base /etc/group /etc/gshadow /etc/passwd /etc/shadow etc/

COPY etc/ etc/
COPY usr/ usr/

WORKDIR /

FROM clover/common

ENV LANG=C.UTF-8
ENV CHROMIUM_ARGUMENTS="--disable-dev-shm-usage --disable-crash-reporter"

COPY --from=build /rootfs /

EXPOSE ${CHROMEDRIVER_PORT:-9515}
