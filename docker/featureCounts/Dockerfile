FROM ubuntu:20.04

# Disable prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    zlib1g-dev \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev \
    ca-certificates \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Download and install subread (includes featureCounts)
RUN wget https://sourceforge.net/projects/subread/files/subread-2.0.3/subread-2.0.3-Linux-x86_64.tar.gz && \
    tar -xzf subread-2.0.3-Linux-x86_64.tar.gz && \
    mv subread-2.0.3-Linux-x86_64 /opt/subread && \
    ln -s /opt/subread/bin/featureCounts /usr/local/bin/featureCounts

# Set the default working directory
WORKDIR /mnt

# Specify the default command
CMD ["bash"]
