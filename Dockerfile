ARG IMAGE

FROM ${IMAGE}

ARG ZWAVE_VERSION
ARG NODE_RED_VERSION

RUN set -x \    
    && apk add --no-cache eudev \
    && apk add --no-cache --virtual .build-deps \
        coreutils \
        g++ \        
        linux-headers \
        eudev-dev \
        make \
    # get open zwave
    && curl -SL "https://github.com/OpenZWave/open-zwave/archive/V$ZWAVE_VERSION.tar.gz" | tar -xz \
    # make & install
    && cd "open-zwave-$ZWAVE_VERSION" \
    && make \
    && make install \
    # clean
    && cd .. \
    && rm -rf "open-zwave-$ZWAVE_VERSION" \
    # clean apk deps
    && apk del .build-deps

WORKDIR /opt/node-red/data

RUN set -x \    
    && apk add --no-cache --virtual .gyp-build-deps \
        make \
        g++ \
        python \
    # install node-red & modules
    && yarn global add node-red@$NODE_RED_VERSION \    
    && yarn global add node-red-contrib-openzwave \
    && yarn global add node-red-contrib-bigtimer \
    # clean apk deps
    && apk del .gyp-build-deps

WORKDIR /opt/node-red
RUN chown -R 1000:1000 .

USER 1000:uucp

ENV HOME="/opt/node-red/data"

ENTRYPOINT ["node-red", "--userDir", "/opt/node-red/data", "--flowFile", "iot-flow.json"]
