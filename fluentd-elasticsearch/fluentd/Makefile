.PHONY:	build push

PREFIX = quay.io/containerbootcamp
IMAGE = fluentd-kubernetes-daemonset
TAG = latest

build:
	docker build --pull -t $(PREFIX)/$(IMAGE):$(TAG) .

push:
	docker push $(PREFIX)/$(IMAGE):$(TAG)
