# XEN-Orchestainer

A containerized XEN-Orchestra version inspired by [xen-orchestra-docker](https://github.com/ronivay/xen-orchestra-docker) and [xen-orchestra-ce](https://github.com/Ezka77/xen-orchestra-ce)

> Please use this repo's issues for all bugs observed or supports needed related to the created containers images

## How to use

If you have a `EMFILE: too many open files` error while building your image (or on runtime), consider to use the option `--ulimit=nofile=131070:131070`

If the OCI standard filenames are not recognized by you container runtime, consider user the option `-f Containerfile` or `-f compose.yaml` in your docker/cocker-compose commands

### As a simple container image

The same command is working with podman as well

```bash
# To be executed in the repo root directory
docker build ./build -t xen-orchestainer:latest -t xen-orchestainer:1
```

### Compose

```compose
# To be executed in the repo root directory
docker-compose up -d
```

## Goals

- Automatic build from sources
- Add all plugins dynamically
- Build as a nodejs container
- To be OCI compliant (Avoid as much as possible the specific Docker dependencies)
- Follow the container building good practices: One process per container (Redis is separated from the XEN-server)
- Keep it as simple as possible
- Make it working on Docker as well as on podman or any OCI compliant runtime
- Be able to run the best possible XEN-Orchestra in a *lightweight* container with all the need features anywhere without the need of any hypervisor
- Be a quick and easy way to test, learn and experiment XEN-Orchestra

## Non-Goals

- To be built on many image base (It is built using the **ubuntu image base only**)
- To run all the dependencies as a unique container. If you are interested about this kind of packaging, please check the very good options from [xen-orchestra-docker](https://github.com/ronivay/xen-orchestra-docker) and [xen-orchestra-ce](https://github.com/Ezka77/xen-orchestra-ce)
- To build an image as small as possible (But we try to keep it as optimized as we can)
- Make it configurable after the initial build
- Be a replacement or an alternative to the official XEN-Orchestra flavors

## Todo

- Github action for a periodic build and push to a container registry
- Multi-arch build
- Port it to K8S (Add the expected k8s manifest)

## Tests and run tools

- Docker (and docker-compose)
- Podman (and podman-compose)

## XEN-Orchestra

XEN-Orchestainer exists thanks to XEN-Ochestra team, [vatesfr](https://github.com/vatesfr). Always consider use their supported versions for production purpose
