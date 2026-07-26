#!/usr/bin/env bash
set -e

# Default settings
IMAGE_NAME="${IMAGE_NAME:-ajitjadhav28/kernel-bench:6.12.10}"
MEMORY_LIMIT="${MEMORY_LIMIT:-6g}"
KCONFIG="${KCONFIG:-defconfig}"
PLATFORM="${PLATFORM:-linux/amd64}"
JOBS="${JOBS:-$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)}"

echo "=========================================================="
echo "          LAUNCHING KERNEL BUILD BENCHMARK                "
echo "=========================================================="
echo " Image Name   : ${IMAGE_NAME}"
echo " Platform     : ${PLATFORM}"
echo " RAM Limit    : ${MEMORY_LIMIT}"
echo " Kernel Config: ${KCONFIG}"
echo " Parallel Jobs: ${JOBS}"
echo "=========================================================="
echo ""

# Check if Docker image exists for requested platform, build if missing or architecture mismatch
LOCAL_PLATFORM="$(docker image inspect --format '{{.Os}}/{{.Architecture}}{{if .Variant}}/{{.Variant}}{{end}}' "${IMAGE_NAME}" 2>/dev/null || true)"
if [ "${LOCAL_PLATFORM}" != "${PLATFORM}" ]; then
    if [ -z "${LOCAL_PLATFORM}" ]; then
        echo "Image '${IMAGE_NAME}' not found locally. Building image for platform ${PLATFORM}..."
    else
        echo "Image '${IMAGE_NAME}' found locally for platform '${LOCAL_PLATFORM}', but target platform is '${PLATFORM}'. Rebuilding image..."
    fi
    docker build --platform="${PLATFORM}" -t "${IMAGE_NAME}" .
    echo ""
fi

echo "Running Docker container restricted to ${MEMORY_LIMIT} RAM on ${PLATFORM}..."
echo "----------------------------------------------------------"

# Execute Docker container with RAM limit of 6GB and explicit platform tag
docker run --rm \
    --platform="${PLATFORM}" \
    --memory="${MEMORY_LIMIT}" \
    -e KCONFIG="${KCONFIG}" \
    -e JOBS="${JOBS}" \
    "${IMAGE_NAME}" "$@"
