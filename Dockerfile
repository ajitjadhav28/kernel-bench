# Dockerfile for Linux Kernel Build & Extraction Benchmarking
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential compilation tools and kernel build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    bison \
    flex \
    libssl-dev \
    libelf-dev \
    bc \
    kmod \
    cpio \
    rsync \
    curl \
    ca-certificates \
    xz-utils \
    time \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Define kernel version to benchmark
ARG KERNEL_VERSION=6.12.10
ENV KERNEL_VERSION=${KERNEL_VERSION}

# Download and store ONLY the raw kernel tarball in the image
WORKDIR /usr/src
RUN curl -sSL https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz -o /usr/src/linux.tar.xz

# Copy entrypoint benchmark script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set default entrypoint
ENTRYPOINT ["/entrypoint.sh"]
