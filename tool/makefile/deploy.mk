.PHONY: build-web-container push-web-container

build-web-container:
	@echo "Build release docker image with flutter web and nginx"
	docker-compose -f ./deploy/app.compose.yml build --no-cache --force-rm --compress --parallel

push-web-container:
	@echo "Push docker image with flutter web and nginx"
	docker-compose -f ./deploy/app.compose.yml push
