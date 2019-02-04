#!/usr/bin/make
COMPOSE_FILE := -f docker-compose.yml
COMPOSE_DEBUG := -f docker-compose.yml -f docker-compose-debug.yml
VERSION := local-build
GIT_URL := https://github.com
GIT_ORG ?= OpusVL
GIT_REPO ?= Open-eObs-Modules
GIT_PATH := ${GIT_URL}/${GIT_ORG}/${GIT_REPO}
GIT_BRANCH ?= remove-custom-frequency
GIT_PR = ${pr}

all: clean repo branch build run

repo:
	@echo -n "Setting up repo ${GIT_PATH} ... "
	@git init -q odoo/addon-bundles/${GIT_REPO} || true
	@git -C odoo/addon-bundles/${GIT_REPO} remote add origin ${GIT_PATH}.git || true
	@echo

branch:
	@echo -n "Checking out ${GIT_BRANCH} ... "
	@git -C odoo/addon-bundles/${GIT_REPO} fetch origin ${GIT_BRANCH}
	@git -C odoo/addon-bundles/${GIT_REPO} checkout -q ${GIT_BRANCH}
	@echo

clean:
	@echo -n "Removing odoo/addon-bundles/${GIT_REPO} ... "
	@rm -rf odoo/addon-bundles/${GIT_REPO}
	@echo

build:
	docker pull quay.io/opusvl/odoo-custom:8.0
	docker-compose ${COMPOSE_FILE} build --pull

run:
	docker-compose ${COMPOSE_FILE} up -d

stop:
	docker-compose ${COMPOSE_FILE} stop

logs:
	@docker-compose ${COMPOSE_FILE} logs -f

debug-run:
	@docker-compose ${COMPOSE_DEBUG} up -d

debug-build:
	@docker rmi open-eobs-odoo:local-build || true
	@docker rmi open-eobs-odoo:latest || true
	@docker pull quay.io/opusvl/odoo-custom:8.0
	@docker-compose ${COMPOSE_DEBUG} up --quiet-pull --build --no-start

debug-down:
	@docker-compose ${COMPOSE_DEBUG} down -v

debug-pr: debug-down clean repo
	@echo -n "Checking out PR ${PR} ... "
	@echo
	@git -C odoo/addon-bundles/${GIT_REPO} fetch -q origin pull/${GIT_PR}/head:PR-${GIT_PR}
	@git -C odoo/addon-bundles/${GIT_REPO} checkout PR-${GIT_PR}

debug-branch: debug-down clean repo branch

debug-logs:
	docker-compose ${COMPOSE_DEBUG} logs -f

debug-pgdump:
	docker-compose ${COMPOSE_DEBUG} exec postgresql /usr/bin/pg_dump -U postgres nhclinical > nhclinical.sql
	docker-compose ${COMPOSE_DEBUG} exec postgresql /usr/bin/pg_dumpall -U postgres > all-db.sql

debug-test:
	@docker build -t open-eobs-rspec:${VERSION} -f tests/Dockerfile .
	@cd tests && bundle install
	cd tests && VERSION=${VERSION} bundle exec rake spec
	@rm -rf tests/vendor
	@docker rmi open-eobs-rspec:${VERSION}

# .PHONY: build clean clone logs run stop
