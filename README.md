# PiShrink Docker Wrapper

A lightweight Docker-based tool for shrinking and optionally compressing Raspberry Pi `.img` files using [PiShrink](https://github.com/Drewsif/PiShrink).

This wrapper allows you to shrink and compress Raspberry Pi OS images **without needing to install Linux tools directly on your macOS or Windows system**.

* On macOS and Windows, Docker Desktop uses a virtualized Linux kernel. The `--privileged` and `/dev:/dev` mount allow access to loop devices required by PiShrink.
* This is not recommended for general-purpose containers, but safe for this one-off tool.
* `run-pishrink.sh` — CLI wrapper for shrinking/compressing `.img` files ([see usage](#-usage))


## 🛠 Requirements

* [Docker](https://www.docker.com/) installed

## 🚀 Setup

1. **Clone this repo** or copy the `Dockerfile` and `run-pishrink.sh` script to your working directory.

2. **Build the Docker image**:

```bash
   docker build -t pishrink .
```

## 🔧 Usage

### 🔹 Shrink only (no compression)

```bash
./run-pishrink.sh path/to/image.img
```

This runs PiShrink and modifies the image in-place.

### 🔹 Shrink and compress with `xz`

```bash
./run-pishrink.sh path/to/image.img --xz
```

This runs PiShrink and compresses the output with `xz`. The result will be:

```
image.img.xz
```

### 📋 Direct Docker usage (without wrapper script)

You can also run PiShrink directly using `docker run`:

#### Shrink only (no compression):

```bash
docker run --rm --privileged -v /dev:/dev -v "$PWD:/data" pishrink image.img
```

#### Shrink and compress with `xz`:

```bash
docker run --rm --privileged -v /dev:/dev -v "$PWD:/data" pishrink -Z -a image.img
```

This will shrink and compress the image using `xz` with multithreading. The output will be `image.img.xz` in the same directory.

## 📆 Output Example

| Input          | Command                               | Output File             |
| -------------- | ------------------------------------- | ----------------------- |
| `raspbian.img` | `./run-pishrink.sh raspbian.img`      | `raspbian.img` (shrunk) |
| `raspbian.img` | `./run-pishrink.sh raspbian.img --xz` | `raspbian.img.xz`       |

## 📝 Notes

* This wrapper runs PiShrink in a one-off container (`docker run --rm`) and mounts your current directory for in-place processing.
* The Docker image pulls the latest PiShrink script at build time, so there's no need to check for updates at runtime.

## 📂 Files Included

* `Dockerfile` — builds a lightweight Debian image with PiShrink installed
* `run-pishrink.sh` — CLI wrapper for shrinking and compressing `.img` files

## 🧼 Optional Cleanup

To remove the built Docker image:

```bash
docker rmi pishrink
```

## 🙌 Credits

* [PiShrink by Drewsif](https://github.com/Drewsif/PiShrink)
