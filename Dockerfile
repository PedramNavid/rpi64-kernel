FROM debian:stretch

WORKDIR /workdir
ENV LINUX=/workdir/rpi64-linux \
    RPI_KERNEL_REPO=https://www.github.com/raspberrypi/linux \
    RPI_KERNEL_BRANCH=rpi-5.10.y \
    TIMESTAMP_OUTPUT=true \
    LINARO=gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu \
    LINARO_ROOT=https://releases.linaro.org/components/toolchain/binaries/latest-7/aarch64-linux-gnu
# Install build dependencies
RUN apt-get update && \
  apt-get install -y \
    bc \
    build-essential \
    curl \
    git-core \
    libncurses5-dev \
    kmod \
    flex \
    bison \
    libssl-dev

# Install crosscompile toolchain for ARM64/aarch64
RUN mkdir -p /opt/linaro && \
    curl -sSL $LINARO_ROOT/$LINARO.tar.xz | tar xfJ - -C /opt/linaro

ENV CROSS_COMPILE=/opt/linaro/$LINARO/bin/aarch64-linux-gnu-

RUN git clone --single-branch --branch $RPI_KERNEL_BRANCH --depth 1 $RPI_KERNEL_REPO $LINUX

COPY defconfigs/ /defconfigs/
COPY build-kernel.sh get-kernel-version.sh refresh-repo.sh /
CMD ["/build-kernel.sh"]
