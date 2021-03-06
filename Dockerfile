FROM qnib/alplain-init

## Copied from: https://github.com/anapsix/docker-alpine-java/blob/master/8/jdk/Dockerfile
# Java Version and other ENV
ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=131
ARG JAVA_VERSION_BUILD=11
ARG JAVA_URL=http://download.oracle.com/otn-pub/java/jdk
ARG JAVA_HASH=d54c1d3a095b4ff2b6607d096fa80163
ARG JAVA_PACKAGE=server-jre
ARG GLIBC_VER=2.23-r2
#8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jre-8u131-linux-x64.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    LANG=C.UTF-8 \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-8-oracle/bin

RUN apk add --no-cache wget ca-certificates curl \
 && export URL="${JAVA_URL}/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_HASH}/jre-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz" \
 && echo $URL \
 && mkdir -p /usr/lib/jvm/java-8-oracle \
 && cd /tmp \
 && wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$URL" \
 && tar zxf /tmp/jre-*-linux-x64.tar.gz --strip-components=1 -C /usr/lib/jvm/java-8-oracle/ \
 && mkdir -p /opt/ \
 && curl -sLo /tmp/glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-${GLIBC_VER}.apk" \
 && apk --no-cache add --allow-untrusted /tmp/glibc.apk \
 && curl -sLo /tmp/glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk" \
 && apk --no-cache add --allow-untrusted /tmp/glibc-bin.apk \
 && ldconfig /lib /usr/glibc/usr/lib \
 && apk --no-cache del curl \
 && rm -rf ${JAVA_HOME}/plugin \
           ${JAVA_HOME}/bin/javaws \
           ${JAVA_HOME}/bin/jjs \
           ${JAVA_HOME}/bin/keytool \
           ${JAVA_HOME}/bin/orbd \
           ${JAVA_HOME}/bin/pack200 \
           ${JAVA_HOME}/bin/policytool \
           ${JAVA_HOME}/bin/rmid \
           ${JAVA_HOME}/bin/rmiregistry \
           ${JAVA_HOME}/bin/servertool \
           ${JAVA_HOME}/bin/tnameserv \
           ${JAVA_HOME}/bin/unpack200 \
           ${JAVA_HOME}/lib/javaws.jar \
           ${JAVA_HOME}/lib/deploy* \
           ${JAVA_HOME}/lib/desktop \
           ${JAVA_HOME}/lib/*javafx* \
           ${JAVA_HOME}/lib/*jfx* \
           ${JAVA_HOME}/lib/jfr* \
           ${JAVA_HOME}/lib/amd64/libdecora_sse.so \
           ${JAVA_HOME}/lib/amd64/libprism_*.so \
           ${JAVA_HOME}/lib/amd64/libfxplugins.so \
           ${JAVA_HOME}/lib/amd64/libglass.so \
           ${JAVA_HOME}/lib/amd64/libgstreamer-lite.so \
           ${JAVA_HOME}/lib/amd64/libjavafx*.so \
           ${JAVA_HOME}/lib/amd64/libjfx*.so \
           ${JAVA_HOME}/lib/ext/jfxrt.jar \
           ${JAVA_HOME}/lib/ext/nashorn.jar \
           ${JAVA_HOME}/lib/oblique-fonts \
           ${JAVA_HOME}/lib/plugin.jar \
           /tmp/* /var/cache/apk/* \
 && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
 && java -version
