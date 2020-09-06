FROM alpine:latest

RUN \
  apk update && \ 
  apk add \
    curl \
    openssh-client \
    python \
    py-pip \
    py-setuptools \
  rm -rf /var/cache/apk/*

RUN \
  addgroup -S ansible && \
  adduser -S ansible -G ansible

USER ansible

COPY ./ /home/ansible
WORKDIR /home/ansible

RUN \
  pip install -r requirements.txt && \
  ansible-galaxy collection install juniper.device && \
  chmod +x inventory/inventory.py

ENTRYPOINT ["ansible-playbook"]