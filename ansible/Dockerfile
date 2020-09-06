FROM python:3.8.3-alpine3.10

RUN \
  apk update && \ 
  apk add --no-cache \
  build-base \
  libxml2-dev \
  libxslt-dev \
  python3-dev \
  gcc \
  openssl-dev \
  musl-dev \
  libffi-dev \
  ca-certificates && \
  update-ca-certificates && \
  rm -rf /var/cache/apk/*

#RUN \
#  addgroup -S ansible && \
#  adduser -S ansible -G ansible

#USER ansible

COPY ./ /home/ansible
WORKDIR /home/ansible

RUN \
  pip install -r requirements.txt && \
  ansible-galaxy collection install juniper.device && \
  chmod +x inventory/inventory.py

ENTRYPOINT ["ansible-playbook"]