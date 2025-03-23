FROM ubuntu:20.04

# install packages
RUN echo 'APT::Acquire::Retries "10";' >> /etc/apt/apt.conf.d/80-retries \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        software-properties-common \
    && add-apt-repository ppa:jonathonf/vim \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tzdata \
        language-pack-ja manpages-ja manpages-ja-dev \
        nano less vim \
        git curl wget zip unzip zstd \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

# install docker
RUN curl -fsSL https://get.docker.com | sh

# python (miniconda)
ARG conda_root=/conda
RUN mkdir -p "$conda_root" \
    && cd "$conda_root" \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-py39_23.5.2-0-Linux-x86_64.sh \
        -O miniconda.sh \
    && bash miniconda.sh -b -u -p "$conda_root" \
    && rm miniconda.sh \
    && chmod -R 777 "$conda_root"
ENV PATH="${conda_root}/bin:${PATH}"
COPY docker/requirements.txt "$conda_root"
RUN pip install --upgrade pip \
    && pip install -r "${conda_root}/requirements.txt"

# install latest neovim
RUN mkdir -p /usr/src/neovim \
    && cd /usr/src/neovim \
    && curl -LO https://github.com/neovim/neovim/releases/download/v0.9.1/nvim.appimage \
    && chmod +x nvim.appimage \
    && ./nvim.appimage --appimage-extract \
    && ln -s /usr/src/neovim/squashfs-root/AppRun /usr/bin/nvim

# add user
ARG USER_NAME=user
ARG GROUP_NAME=user
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g "$GROUP_ID" "$GROUP_NAME" \
    && useradd -m -s /bin/bash -u "$USER_ID" -g "$GROUP_ID" "$USER_NAME" \
    && echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER "$USER_NAME"
WORKDIR "/home/$USER_NAME"
RUN mkdir -p "/home/${USER_NAME}/.local/bin"
ENV PATH="${PATH}:/home/${USER_NAME}/.local/bin"
