FROM backstopjs/backstopjs
RUN apk update
RUN apk add --no-cache --update \
    openssh \
    git

ADD . /build-tools-ci
