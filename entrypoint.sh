#!/usr/bin/env bash
set -e

# Detect architecture and select appropriate default target if not specified
ARCH=$(uname -m)
if [ -z "${TARGET}" ]; then
    if [ "${ARCH}" = "x86_64" ]; then
        TARGET="bzImage"
    elif [ "${ARCH}" = "aarch64" ]; then
        TARGET="Image"
    else
        TARGET="vmlinux"
    fi
fi

JOBS="${JOBS:-$(nproc)}"
KCONFIG="${KCONFIG:-defconfig}"

echo "=========================================================="
echo "          LINUX KERNEL EXTRACT & BUILD BENCHMARK          "
echo "=========================================================="
echo " Kernel Version : ${KERNEL_VERSION:-6.12.10}"
echo " CPU Cores      : $(nproc) available (${JOBS} parallel jobs)"
echo " Kernel Config  : ${KCONFIG}"
echo " Build Target   : ${TARGET}"
echo " Host Arch      : ${ARCH}"
echo "=========================================================="
echo ""

BUILD_DIR="/tmp/linux_build"
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"

echo "[1/3] Extracting kernel tarball (/usr/src/linux.tar.xz)..."
EXTRACT_START=$(date +%s%N)
/usr/bin/time -f "Extraction Memory Peak: %M KB | CPU: %P" tar -xf /usr/src/linux.tar.xz -C "${BUILD_DIR}" --strip-components=1
EXTRACT_END=$(date +%s%N)

EXTRACT_TIME_MS=$(( (EXTRACT_END - EXTRACT_START) / 1000000 ))
EXTRACT_TIME_SEC=$(awk "BEGIN {printf \"%.2f\", ${EXTRACT_TIME_MS}/1000}")
echo "--> Extraction finished in ${EXTRACT_TIME_SEC} seconds."
echo ""

cd "${BUILD_DIR}"

echo "[2/3] Generating kernel configuration (${KCONFIG})..."
make ${KCONFIG} > /dev/null

echo "[3/3] Compiling kernel (${JOBS} parallel jobs)..."
echo "----------------------------------------------------------"

COMPILE_START=$(date +%s%N)

TIME_FORMAT="
----------------------------------------------------------
Compilation Wall Time : %E (%e seconds)
Compilation CPU Time  : %U sec (user) / %S sec (sys)
Compilation CPU Util  : %P
Max RAM Usage (RSS)   : %M KB"

/usr/bin/time -f "${TIME_FORMAT}" make -j"${JOBS}" "${TARGET}"
COMPILE_END=$(date +%s%N)

COMPILE_TIME_MS=$(( (COMPILE_END - COMPILE_START) / 1000000 ))
COMPILE_TIME_SEC=$(awk "BEGIN {printf \"%.2f\", ${COMPILE_TIME_MS}/1000}")

TOTAL_TIME_MS=$(( EXTRACT_TIME_MS + COMPILE_TIME_MS ))
TOTAL_TIME_SEC=$(awk "BEGIN {printf \"%.2f\", ${TOTAL_TIME_MS}/1000}")

echo ""
echo "=========================================================="
echo "               BENCHMARK RESULTS SUMMARY                  "
echo "=========================================================="
echo " Build Target         : ${TARGET} (${KCONFIG})"
echo " Parallel Jobs (-j)   : ${JOBS} / $(nproc) CPUs"
echo " Host Arch            : ${ARCH}"
echo "----------------------------------------------------------"
echo " 1. Extraction Time   : ${EXTRACT_TIME_SEC} seconds"
echo " 2. Compilation Time  : ${COMPILE_TIME_SEC} seconds"
echo " --------------------------------------------------------"
echo " TOTAL RUNTIME        : ${TOTAL_TIME_SEC} seconds"
echo "=========================================================="
echo "Benchmark finished successfully."
