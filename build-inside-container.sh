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
cp bazel-bin/runsc/runsc_/runsc /src/runsc-patched
chmod +x /src/runsc-patched
