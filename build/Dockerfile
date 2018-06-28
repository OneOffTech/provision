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

RUN pip install --upgrade python-keyczar pykeepass
RUN rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN \
  curl -fsSL https://github.com/ansible/ansible/archive/v2.3.1.0-1.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

RUN mkdir -p /ansible/playbooks
ADD ./files /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["/bin/bash", "./ansible-playbook-wrapper"]
