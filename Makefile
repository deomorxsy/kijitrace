.DEFAULT_GOAL := build

SHELL=/bin/bash


deploy:
	kubectl apply -f ./deploy.yml

test:
	docker compose -f ./compose.yml run

images:
	source ./scrits/ccr.sh; checker && \
	docker compose images

# up containers
up: up_imgui up_wasm
	source ./scripts/ccr.sh; checker && \
	docker compose -f ./compose.yml up

up_imgui:
	source ./scripts/ccr.sh; checker && \
	docker compose -f ./compose.yml up imgui
up_wasm:
	source ./scripts/ccr.sh; checker && \
	docker compose -f ./compose.yml up wasm

clean:
	source ./scripts/ccr.sh; checker && \
	docker compose -f ./compose.yml down

build: build_server build_client
build_imgui:
	source ./scripts/ccr.sh; checker && \
	docker compose -f ./compose.yml build imgui
build_wasm:
	source ./scripts/ccr.sh; checker && \
	docker compose -f ./compose.yml build wasm
