IMAGE_VERSION = latest
IMAGE_NAME = quay.io/containerbootcamp/sbt-project-builder:$(IMAGE_VERSION)

all: image

image:
	docker build -t $(IMAGE_NAME) .

image-publish: image
	docker push $(IMAGE_NAME)