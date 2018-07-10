FROM node:8.9.4 AS build-container
ENV DISTR='linux_amd64'
ENV P_VER='1.1.3'
ENV T_VER='0.11.1'
ENV G_VER='2.9.5'


RUN [ "/bin/bash", "-c", "mkdir -p /root/{packer,git}" ]

WORKDIR /root/packer
RUN  wget https://releases.hashicorp.com/packer/${P_VER}/packer_${P_VER}_${DISTR}.zip       \
  && wget https://releases.hashicorp.com/terraform/${T_VER}/terraform_${T_VER}_${DISTR}.zip \
  && wget https://github.com/git/git/archive/v${G_VER}.zip

RUN  apt-get update                                                             \
  && apt-get install -y unzip build-essential libssl-dev libcurl4-gnutls-dev    \
                        libexpat1-dev gettext                                   \
  && rm -rf /var/lib/apt/lists/*

RUN  unzip packer_${P_VER}_${DISTR}.zip                                         \
  && unzip terraform_${T_VER}_${DISTR}.zip                                      \
  && unzip v${G_VER}.zip                                                        \
  && rm *.zip

RUN  mv packer        /usr/local/bin/packer                                     \
  && mv terraform     /usr/local/bin/terraform                                  \
  && mv git-${G_VER}  /root/git


WORKDIR /root/git/git-${G_VER}
RUN  make configure                                                             \
  && ./configure --prefix=/usr                                                  \
  && make all                                                                   \
  && make install


## Oikology
RUN [ "/bin/bash", "-c", "rm -fr /root/{packer,git}" ]
