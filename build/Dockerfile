FROM gliderlabs/alpine

RUN \
  apk-install \
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
    tar

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/host
RUN mkdir -p /ansible/playbooks
ADD ./files /ansible/playbooks
WORKDIR /ansible/playbooks

RUN pip install --upgrade python-keyczar pykeepass ansible
RUN rm -rf /var/cache/apk/*

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_LOOKUP_PLUGINS /ansible/playbooks/lookup_plugins
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["/bin/bash", "./ansible-playbook-wrapper"]
