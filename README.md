# XEN Orchestra As a Container

XOA in XOA Container means `XEN Orchestra As`, do not confuse with the official Vates's XOA meaning `XEN Orchestra Appliance`. Vates is the open source company behind XCP-NG and XEN Orchestra.
We are very grateful for their work and strongly encourage you to support them. Even a github star count as a support.

XOA Container - standing for `XEN Orchestra As Container` - is a containerized XEN Orchestra version inspired by [XEN-Orchestra-Docker](https://github.com/ronivay/xen-orchestra-docker) and [XEN-Orchestra-CE](https://github.com/Ezka77/xen-orchestra-ce).

> Please use this repo's issues for all bugs observed or supports needed related to the xoa-container images.

## Usage (Tested with Docker and Podman, but we prefer podman)

### Get the image

```bash
podman pull ghcr.io/soubinan/xoa-container:latest
```

### Execute

```bash
# You already have Redis running
podman run [-d] --rm -p 8080:80 -v </local/path/config>:/etc/xo-server -v </local/path/data>:/var/lib/xo-server -v </local/path/backup>:/var/lib/xo-backup ghcr.io/soubinan/xoa-container:latest
```

or

```bash
# Use the Compose file with Redis included
podman network create frontnet
podman network create redisnet
podman-compose up [-d]
```

## Known issues

### Memory overcommit disabled

> WARNING Memory overcommit must be enabled! Without it, a background save or replication may fail under low memory condition. Being disabled, it can can also cause failures without low memory condition, see <https://github.com/jemalloc/jemalloc/issues/1328>. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.

If you see a warning like this, you have to enable overcommit on your host machine.

#### Solution 1

Run command below to permanently enable Memory overcommit on reboot, change will take effect after reboot

```bash
echo "vm.overcommit_memory = 1" | sudo tee /etc/sysctl.d/50-memory-overcommit.conf
```

#### Solution 2

Run command below to temporarily enable Memory overcommit on reboot, change will take effect immediately

```bash
sudo sysctl "vm.overcommit_memory=1"
```

Note for Docker Desktop/WSL: See <https://stackoverflow.com/a/69294687> for how to apply sysctl config values.
Background: Due to the fact that (for good reasons) the Redis container does not run in privileged mode, there is no way that Redis can enable this for you, i.e., /proc is read-only for containers.
See Redis documentation, corresponding docker issue and kernel documentation for more info.

## Goals

* Automatic build from sources
* Add all plugins dynamically
* Build as an exclusive nodejs container
* To be OCI compliant (Avoid as much as possible the specific Docker dependencies)
* Follow the container building good practices: One process per container (Redis is separated from the XEN-server)
* Keep it as simple as possible
* Make it working on Docker as well as on podman or any OCI compliant runtime
* Be able to run the best possible XEN-Orchestra in a *lightweight* container with all the need features anywhere without the need of any hypervisor
* Be a quick and easy way to test, learn and experiment XEN-Orchestra

## Non-Goals

* To be built on many linux distributions (It is built using the **Debian image base only**)
* To run all the stack as a unique container. If you are interested about this kind of packaging, please check the very good options from [XEN-Orchestra-Docker](https://github.com/ronivay/xen-orchestra-docker) and [XEN-Orchestra-CE](https://github.com/Ezka77/xen-orchestra-ce)
* To build an image as small as possible (But we try to keep it as optimized as we can)
* Be a replacement or an alternative to the official XEN-Orchestra flavors

## Todo

* Port it to K8S (Add the expected k8s/helm manifest)

## Test and run tools

* Docker (and docker-compose)
* Podman (and podman-compose)

## XEN-Orchestra

XEN-Container exists thanks to [XEN-Ochestra](https://github.com/vatesfr/xen-orchestra) by [VatesFR](https://github.com/vatesfr) team.
Always consider use their supported versions for production purpose.

### Support

This Docker project is not supported by Xen-Orchestra or the parent company Vates.
Xen-Orchestra provides a fully-supported, turn-key appliance from free to paid versions, see: <https://xen-orchestra.com/pricing.html>
