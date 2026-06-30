FROM ubuntu:18.04 as base

MAINTAINER salmon.maintainer@gmail.com

ENV PACKAGES git gcc make g++ libboost-all-dev liblzma-dev libbz2-dev \
    ca-certificates zlib1g-dev libcurl4-openssl-dev curl unzip autoconf \
    apt-transport-https gnupg software-properties-common wget

ENV SALMON_VERSION 1.10.3

WORKDIR /home

RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean && \
    wget https://apt.kitware.com/keys/kitware-archive-latest.asc -O - | apt-key add - && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && \
    apt-get update && \
    apt-get install -y cmake && \
    curl -k -L https://github.com/COMBINE-lab/salmon/archive/v${SALMON_VERSION}.tar.gz -o salmon-v${SALMON_VERSION}.tar.gz && \
    tar xzf salmon-v${SALMON_VERSION}.tar.gz && \
    cd salmon-${SALMON_VERSION} && \
    mkdir build && cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local/salmon && \
    make && make install

FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends libhwloc5 && rm -rf /var/lib/apt/lists/*

COPY --from=base /usr/local/salmon/ /usr/local/

ENV PATH /usr/local/salmon/bin:${PATH}
ENV LD_LIBRARY_PATH "/usr/local/lib:${LD_LIBRARY_PATH}"

# Use bash to run the script from the mounted directory
ENTRYPOINT ["bash", "/mnt/salmon_quant/salmon_quant.sh"]

# command for saving image as tar file: 
# docker save -o './salmon_quant_docker.tar' salmon_quant_docker

# command for running:
# docker run -v /cellfile/ahyseni/cryption/c.elegans/data/:/mnt/input_data salmon_quant_docker
