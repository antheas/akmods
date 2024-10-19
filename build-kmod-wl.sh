#!/bin/sh

set -oeux pipefail


ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "${KERNEL_NAME}" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"


### BUILD wl (succeed or fail-fast with debug output)
dnf download -y --destdir /var/cache/rpms/akmods \
    akmod-wl-*.fc${RELEASE}.${ARCH}
dnf install -y \
    /var/cache/rpms/akmods/akmod-wl-*.rpm
akmods --force --kernels "${KERNEL}" --kmod wl
modinfo /usr/lib/modules/${KERNEL}/extra/wl/wl.ko.xz > /dev/null \
|| (find /var/cache/akmods/wl/ -name \*.log -print -exec cat {} \; && exit 1)
