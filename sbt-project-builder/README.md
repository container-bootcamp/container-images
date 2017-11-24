# sbt-project-builder

Provides build environment for sbt projects. It contains java, sbt, scala and docker, so
to build a docker image or other sbt targets of a sbt project no local installation is required. To
use the docker in docker feature the mount of ```/var/run/docker.sock``` is required
as in the example below.

To avoid always download the sbt and project dependencies use a docker data image. How to setup take a look at
the ausleihen-scs ```Makefile```
 

## Simplified use example from ```Makefile``` ausleihen-scs

```bash
docker run --rm \
    -v [PATH]/container-bootcamp/ausleihen/ausleihen-scs:/sbt-project \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -w /sbt-project	\
    --volumes-from sbt-cache \
	--name ausleihen-scs-builder \
    quay.io/containerbootcamp/sbt-project-builder:latest sbt docker:publishLocal
```