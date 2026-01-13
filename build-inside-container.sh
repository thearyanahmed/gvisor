#!/bin/bash
set -e

echo "installing dependencies..."
apt-get update -qq
apt-get install -y -qq curl clang llvm linux-headers-generic libc6-dev libc6-dev-i386 libbpf-dev gcc-aarch64-linux-gnu g++-aarch64-linux-gnu > /dev/null

echo "installing bazel..."
BAZEL_VERSION=$(cat .bazelversion)
curl -fsSL "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-x86_64" -o /usr/local/bin/bazel
chmod +x /usr/local/bin/bazel

echo "building runsc..."
bazel build //runsc:runsc

echo "copying binary..."
# copy to /tmp first, then move with proper ownership
cp bazel-bin/runsc/runsc_/runsc /tmp/runsc-patched
chmod +x /tmp/runsc-patched
# get the uid/gid of the mounted source directory
SRC_UID=$(stat -c %u /src)
SRC_GID=$(stat -c %g /src)
chown "$SRC_UID:$SRC_GID" /tmp/runsc-patched
mv /tmp/runsc-patched /src/runsc-patched
