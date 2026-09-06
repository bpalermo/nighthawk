#!/bin/bash
#
# Runs inside the Envoy build container (via ci/run_envoy_docker.sh): builds the
# optimized Nighthawk binaries and copies the stripped results to /build, which
# is bind-mounted from the host so the image build step can pick them up.
#
# This exists because docker-compose's entrypoint `exec`s DOCKER_COMMAND, so a
# shell chain like `do_ci.sh opt_build && cp ...` never runs the cp.

set -eo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

./ci/do_ci.sh opt_build

OUT_DIR="${BUILD_DIR:-/build}"
mkdir -p "${OUT_DIR}"
for b in nighthawk_client nighthawk_test_server nighthawk_service \
         nighthawk_output_transform nighthawk_adaptive_load_client; do
  cp -v "bazel-bin/${b}.stripped" "${OUT_DIR}/${b}.stripped"
done
ls -la "${OUT_DIR}"/nighthawk_*.stripped
