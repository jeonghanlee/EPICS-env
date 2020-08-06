#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1
##
## BuildEnv docker image size : 
FROM debian:buster-slim AS builder

ENV WorkPath /home/EPICS
ARG INSTALL_LOCATION=/epics

RUN apt update -y && apt install -y  git sudo build-essential coreutils libtool automake re2c darcs libreadline-dev libxt-dev libxmu-headers libxmu-dev libxpm-dev libxmuu-dev libxmuu1 libpcre++-dev python-dev libxml2-dev libudev-dev libboost-dev libboost-regex-dev libboost-filesystem-dev libtirpc-dev 

WORKDIR $WorkPath
COPY . .
RUN echo "INSTALL_LOCATION:=${INSTALL_LOCATION}" > configure/CONFIG_SITE.local
RUN make distclean && \
    make init && \
    make vars && \
    make conf && \
    make build && \
    make install

## Multi-Stages build
## Running docker image size : 
FROM debian:buster-slim
LABEL maintainer="Jeong Han Lee <jeonghan.lee@gmail.com>"

ARG BUILD_DATE
ARG BUILD_VERSION
ARG INSTALL_LOCATION=/epics
ARG TZ=America/Los_Angeles

# Labels.
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="jeonghanlee/epics"
LABEL org.label-schema.description="EPICS base and modules Docker Image"
LABEL org.label-schema.url="https://github.com/jeonghanlee/EPICS-env/"
LABEL org.label-schema.version=$BUILD_VERSION
LABEL org.label-schema.docker.cmd="docker run -it --rm --name=epics jeonghanlee/epics:latest"

### YOUR TIME ZONE
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt update -y && apt install -y tzdata libreadline7 tree nano git

WORKDIR ${INSTALL_LOCATION}
COPY --from=builder ${INSTALL_LOCATION} .
##
ENTRYPOINT ["/bin/bash"]
