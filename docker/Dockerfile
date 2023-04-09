FROM ubuntu:20.04

# install packages
RUN apt-get -o Acquire::Retries=10 update \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=10 install -y --no-install-recommends \
    software-properties-common \
    && add-apt-repository ppa:jonathonf/vim \
    && add-apt-repository ppa:neovim-ppa/stable \
    && apt-get -o Acquire::Retries=10 update \
    && DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::Retries=10 install -y --no-install-recommends \
    tzdata \
    tmux \
    vim \
    neovim \
    curl \
    wget \
    git \
    unzip \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

# create docker home and neovim config directory
ARG docker_home=/dkrhome
RUN mkdir -p "$docker_home" \
    && chmod 777 "$docker_home"
ENV HOME=$docker_home

# install deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
ENV DENO_INSTALL="${HOME}/.deno"
ENV PATH="${DENO_INSTALL}/bin:${PATH}"

# make directory
ARG config_dir="${HOME}/.config"
ARG tmp_dir="${HOME}/.local/tmp"
ARG share_dir="${HOME}/.local/share"
RUN mkdir -p "$config_dir" && chmod 777 "$config_dir" \
    && mkdir -p "$tmp_dir" && chmod 777 "$tmp_dir" \
    && mkdir -p "$share_dir" && chmod 777 "$share_dir"
