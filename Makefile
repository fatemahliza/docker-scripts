# make appropriate changes before running the scripts
# START OF CONFIG =====================================================================================================
IMAGE=azmfaridee/dl:latest
CONTAINER=yourname_projectname
AVAILABLE_GPUS='0'
LOCAL_JUPYTER_PORT=48888
LOCAL_TENSORBOARD_PORT=46006
VSCODE_PORT=48443
PASSWORD=your_vscode_and_jupyter_pass
# END OF CONFIG  ======================================================================================================

docker-resume:
	nvidia-docker start -ai $(CONTAINER)

docker-run:
	NV_GPU=$(AVAILABLE_GPUS) nvidia-docker run -it -e PASSWORD=$(PASSWORD) -e JUPYTER_TOKEN=$(PASSWORD) -p $(VSCODE_PORT):8443 -p $(LOCAL_JUPYTER_PORT):8888 -p \
		$(LOCAL_TENSORBOARD_PORT):6006 -v $(shell pwd):/notebooks --name $(CONTAINER) $(IMAGE)

docker-shell:
	nvidia-docker exec -it $(CONTAINER) bash

docker-clean:
	nvidia-docker rm $(CONTAINER)

docker-build:
	docker build -t $(IMAGE) .
	
docker-rebuild:
	docker build -t $(IMAGE) --no-cache --pull .

docker-push:
	docker push $(IMAGE)

docker-tensorboard:
	nvidia-docker exec -it $(CONTAINER) tensorboard --logdir=logs

docker-vscode:
	nvidia-docker exec -it $(CONTAINER) code-server --port 8443 --auth password --disable-telemetry /notebooks
