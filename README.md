# Linux Kernel Extraction & Build Benchmark Dockerfile

This repository provides a minimal Docker setup to benchmark **Linux kernel source extraction** and **kernel compilation** performance. 

Only the compressed kernel source tarball (`linux-6.12.10.tar.xz`) is stored in the Docker image. When the container runs, both extraction and compilation are performed and timed at runtime.

---

## Docker Hub Image

The pre-built benchmark image is available on Docker Hub:
- **`ajitjadhav28/kernel-bench:6.12.10`**
- **`ajitjadhav28/kernel-bench:latest`**

---

## Features

- **Platform Target**: Configurable via `--platform` (defaults to `linux/amd64`).
- **Standardized Build Target**: Uses `vmlinux` as the default build target across all platforms for identical, fair benchmarking.
- **Runtime Tarball Extraction**: Measures the time required to un-tar the Linux kernel source archive (`/usr/src/linux.tar.xz`).
- **Runtime Compilation**: Measures kernel configuration & parallel compilation time.
- **Unrestricted Memory by Default**: Runs without memory restrictions by default (RAM limit can be set via `MEMORY_LIMIT`).
- **Combined Benchmark Summary**: Displays breakdown of:
  1. Extraction Time (seconds)
  2. Compilation Time (seconds)
  3. Total Runtime (Extraction + Compilation)
  4. CPU utilization & Max RAM consumption (RSS)

---

## Quick Start

### 1. Run Benchmark directly from Docker Hub
```bash
docker run --rm --platform=linux/amd64 ajitjadhav28/kernel-bench:6.12.10
```

### 2. Using the Launch Script
```bash
./run_benchmark.sh
```

---

## Customization Options

### Set RAM Limit (e.g., 6GB)
```bash
MEMORY_LIMIT=6g ./run_benchmark.sh
```

### Fast Benchmark (`tinyconfig`)
```bash
KCONFIG=tinyconfig ./run_benchmark.sh
```

### ARM64 Target Platform
```bash
PLATFORM=linux/arm64 ./run_benchmark.sh
```

### Build Image Locally
```bash
docker build --platform=linux/amd64 -t ajitjadhav28/kernel-bench:6.12.10 .
```
