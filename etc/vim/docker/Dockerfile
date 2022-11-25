FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:jonathonf/vim \
    && add-apt-repository -y ppa:neovim-ppa/stable

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y \
    vim \
    neovim \
    curl \
    wget \
    git

ARG docker_home=/dkrhome
RUN mkdir -p "$docker_home" \
    && chmod 777 "$docker_home" \
    && mkdir -p "${docker_home}/.config/nvim"
ENV HOME=$docker_home