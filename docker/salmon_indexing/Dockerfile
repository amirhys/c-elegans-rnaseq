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

WORKDIR /mnt/data/reference_omes/


# command for running:
# docker run -it --rm -v /cellfile/datapublic/ahyseni/cryption/c.elegans/data/reference_omes/:/mnt/data/reference_omes salmon_index_docker
# inside container shell:
    # grep "^>" Caenorhabditis_elegans.WBcel235.dna.toplevel.fa | cut -d " " -f 1 > decoys.txt
    # sed -i.bak -e 's/>//g' decoys.txt
    # cat Caenorhabditis_elegans.WBcel235.cdna.all.fa Caenorhabditis_elegans.WBcel235.dna.toplevel.fa > gentrome.fa.gz
    # salmon index -t gentrome.fa.gz -d decoys.txt -p 12 -i salmon_index --gencode