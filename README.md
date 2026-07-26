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

- **Platform Target**: Enforces `--platform=linux/amd64` architecture target.
- **Runtime Tarball Extraction**: Measures the time required to un-tar the Linux kernel source archive (`/usr/src/linux.tar.xz`).
- **Runtime Compilation**: Measures kernel configuration & parallel compilation time (`bzImage`).
- **RAM Constraint**: Includes a launch script (`run_benchmark.sh`) configured with a **6 GB RAM limit** (`--memory="6g"`).
- **Combined Benchmark Summary**: Displays breakdown of:
  1. Extraction Time (seconds)
  2. Compilation Time (seconds)
  3. Total Runtime (Extraction + Compilation)
  4. CPU utilization & Max RAM consumption (RSS)

---

## Quick Start

### 1. Run Benchmark directly from Docker Hub (6GB RAM Limit)
```bash
docker run --rm --platform=linux/amd64 --memory="6g" ajitjadhav28/kernel-bench:6.12.10
```

### 2. Using the Launch Script
```bash
./run_benchmark.sh
```

---

## Customization Options

### Fast Benchmark (`tinyconfig` with 6GB RAM Limit)
```bash
KCONFIG=tinyconfig ./run_benchmark.sh
```

### Build Image Locally
```bash
docker build --platform=linux/amd64 -t ajitjadhav28/kernel-bench:6.12.10 .
```
