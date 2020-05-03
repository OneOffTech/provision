FROM gliderlabs/alpine:3.9

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="OneOffTech <info@oneofftech.xyz>" \
  org.label-schema.name="oneofftech/ansible-keepass" \
  org.label-schema.description="Opinionated Ansible Docker image with Keepass to manage provision and deployments" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://github.com/OneOffTech/docker-ansible-keepass"

RUN apk-install --no-cache \
    bash \
    curl \
    build-base \
    openssl-dev \
    libffi-dev \
    python-dev \
    openssh-client \
    libxml2 \
    libxml2-dev \
    libxslt-dev \
    python \
    py-boto \
    py-dateutil \
    py-httplib2 \
    py-jinja2 \
    py-paramiko \
    py-pip \
    py-setuptools \
    py-yaml \
    tar \
    && pip install --upgrade python-keyczar pykeepass \
    && rm -rf /var/cache/apk/* \
    # While we wait for Pip 20.1 with cache purge command to be available https://github.com/pypa/pip/issues/4685
    && rm -rf ~/.cache/pip/* /root/.cache/pip/*

RUN mkdir /etc/ansible/ /ansible /ansible/playbooks && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

ENV ANSIBLE_VERSION=2.9.7

RUN \
  curl -fsSL https://github.com/ansible/ansible/archive/v${ANSIBLE_VERSION}.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging /ansible/changelogs /ansible/test

WORKDIR /ansible/playbooks

ADD ./files /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_LOOKUP_PLUGINS /ansible/playbooks/lookup_plugins
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib


LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF

ENTRYPOINT ["/bin/bash", "./ansible-playbook-wrapper"]
