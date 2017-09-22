ARG IMAGE

FROM ${IMAGE}

ARG VERSION

RUN npm install node-red@$VERSION --global --unsafe-perm

WORKDIR /opt/node-red
RUN chown 1000:1000 .

USER 1000:1000

RUN set -x \
	&& mkdir -p /opt/node-red/data

ENTRYPOINT ["node-red", "--userDir", "/opt/node-red/data"]