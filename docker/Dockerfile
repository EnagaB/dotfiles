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

# create docker home
ARG docker_home=/dkrhome
RUN mkdir -p "$docker_home" \
    && mkdir -p "${docker_home}/.config" \
    && mkdir -p "${docker_home}/.local/tmp" \
    && mkdir -p "${docker_home}/.local/share" \
    && chmod -R 777 "$docker_home"
ENV HOME="$docker_home"

# python (miniconda)
RUN mkdir /conda \
    && cd /conda \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-py39_23.5.2-0-Linux-x86_64.sh \
        -O miniconda.sh \
    && bash miniconda.sh -b -u -p /conda \
    && rm miniconda.sh \
    && chmod -R 777 /conda
ENV PATH="/conda/bin:${PATH}"
COPY docker/requirements.txt /conda
RUN pip install --upgrade pip \
    && pip install -r /conda/requirements.txt

# install deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh
ENV DENO_INSTALL="${HOME}/.deno"
ENV PATH="${DENO_INSTALL}/bin:${PATH}"
