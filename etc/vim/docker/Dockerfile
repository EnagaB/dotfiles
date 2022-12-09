FROM ubuntu:20.04

# add repository
RUN apt-get update && apt-get install -y software-properties-common \
    && add-apt-repository ppa:jonathonf/vim \
    && add-apt-repository ppa:neovim-ppa/stable

# install packages and set JST
RUN apt-get update && apt-get install -y \
    tzdata \
    vim \
    neovim \
    curl \
    wget \
    git \
    && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# create docker home and neovim config directory
ARG docker_home=/dkrhome
RUN mkdir -p "$docker_home" \
    && chmod 777 "$docker_home" \
ENV HOME=$docker_home

# install deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
ENV DENO_INSTALL="${HOME}/.deno"
ENV PATH="$DENO_INSTALL/bin:$PATH"

# make directory
ARG config_dir="${HOME}/.config"
ARG vim_tmp_dir="${HOME}/.local/tmp"
ARG nvim_share_dir="${HOME_DIR}/.local/share/nvim"
RUN mkdir -p "$config_dir" && chmod 777 "$config_dir" \
    && mkdir -p "$vim_tmp_dir" && chmod 777 "$vim_tmp_dir" \
    && mkdir -p "$nvim_share_dir" && chmod 777 "$nvim_share_dir"

# EOF
