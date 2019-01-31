#!/usr/bin/make
COMPOSE_RUN = -f docker-compose.yml
COMPOSE_DEBUG = -f docker-compose.yml -f docker-compose-debug.yml

run:
	docker-compose $COMPOSE_RUN up -d

stop:
	docker-compose $COMPOSE_RUN stop

down:
	docker-compose $COMPOSE_RUN down

debug-run:
	docker-compose ${COMPOSE_DEBUG} up -d

debug-destroy:
	docker-compose ${COMPOSE_DEBUG} down -v

debug-logs:
	docker-compose ${COMPOSE_DEBUG} logs -f

.PHONY: clean login build test publish
