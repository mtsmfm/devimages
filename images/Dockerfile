ARG FROM_IMAGE
FROM ${FROM_IMAGE}

RUN apt-get update && apt-get install -y sudo

RUN sed -i -E "s/%sudo.*/%sudo ALL=\(root\) NOPASSWD:ALL/" /etc/sudoers

COPY --chown=0:0 entrypoint.sh /
RUN mkdir -p /home/user && \
  chgrp -R 0 /home /etc/passwd /etc/group /etc/shadow /etc/sudoers.d && \
  chmod -R g=u /home /etc/passwd /etc/group /etc/shadow /etc/sudoers.d && \
  chmod +x /entrypoint.sh

ENV HOME /home/user
WORKDIR /projects

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
