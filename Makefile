IMAGE=suderman/apache-php7.3

all:
	@echo "image shell push"

image:
	docker build --tag $(IMAGE) .

shell: 
	docker run --rm -it --cap-add SYS_ADMIN --security-opt apparmor:unconfined --device /dev/fuse $(IMAGE) /bin/bash

push: 
	docker push $(IMAGE)
