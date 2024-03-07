include ../../../make.inc
include .env

#!make

build_docker_image:
	docker build -t ${DOCKER_IMAGE_NAME} -f Dockerfile  .
run_docker_image:
	docker run --rm -it -p 8000:8000 -e PORT=$(PORT) ${DOCKER_IMAGE_NAME}:latest
push_docker_image:
	docker tag "${DOCKER_IMAGE_NAME}:${IMAGE_TAG}" \
		&& "${HOSTNAME}/${PROJECT_ID}/${REPOSITORY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
	docker push "${HOSTNAME}/${PROJECT_ID}/${REPOSITORY}/${DOCKER_IMAGE_NAME}:${IMAGE_TAG}"
deploy_docker_image:
	gcloud run deploy my-first-docker --allow-unauthenticated --image="${HOSTNAME}/${PROJECT_ID}/docker-hub/${DOCKER_IMAGE_NAME}"
