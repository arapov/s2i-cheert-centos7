FROM openshift/base-centos7
LABEL maintainer="Anton Arapov <aarapov@redhat.com>"

ENV GOPATH=$HOME/go \
    CHEERT=$HOME/go/src/github.com/arapov/cheert \
    APP_NAME=cheert \
    GO111MODULE=off \
    PATH=$PATH:$HOME/go/bin

ENV JAYCONFIG=$CHEERT/env.json

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="S2I builder image for Cheert" \
    io.k8s.display-name="s2i-cheert-centos7" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,golang" \
    # this label tells s2i where to find its mandatory scripts
    # (run, assemble, save-artifacts)
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# Install the nginx web server package and clean the yum cache
RUN yum install -y epel-release && \
    PKGS="golang openssl npm" && \
    yum install -y --setopt=tsflags=nodocs $PKGS && \
    yum clean all

# Copy the S2I scripts to /usr/libexec/s2i since we set the label that way
COPY ./s2i/bin/ /usr/libexec/s2i

USER 1001
EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
