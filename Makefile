#!/usr/bin/make
COMPOSE_FILE = -f docker-compose.yml
COMPOSE_DEBUG = -f docker-compose.yml -f docker-compose-debug.yml
VERSION = local-build
BRANCH = remove-custom-frequency
PR = ${pr}

all: clean repo branch build run

repo:
	@echo -n "Setting up repo https://github.com/OpusVL/Open-eObs-Modules ... "
	@git init -q odoo/addon-bundles/Open-eObs-Modules || true
	@git -C odoo/addon-bundles/Open-eObs-Modules remote add origin https://github.com/OpusVL/Open-eObs-Modules.git || true
	@echo

branch:
	@echo -n "Checking out ${BRANCH} ... "
	@git -C odoo/addon-bundles/Open-eObs-Modules fetch origin ${BRANCH}
	@git -C odoo/addon-bundles/Open-eObs-Modules checkout -q ${BRANCH}
	@echo

clean:
	@echo -n "Removing odoo/addon-bundles/Open-eObs-Modules ... "
	@rm -rf odoo/addon-bundles/Open-eObs-Modules
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
	@git -C odoo/addon-bundles/Open-eObs-Modules fetch -q origin pull/${PR}/head:PR-${PR}
	@git -C odoo/addon-bundles/Open-eObs-Modules checkout PR-${PR}

debug-branch: debug-down clean repo branch

debug-logs:
	docker-compose ${COMPOSE_DEBUG} logs -f

debug-pgdump:
	docker-compose ${COMPOSE_DEBUG} exec postgresql /usr/bin/pg_dump -U postgres nhclinical > nhclinical.sql
	docker-compose ${COMPOSE_DEBUG} exec postgresql /usr/bin/pg_dumpall -U postgres > all-db.sql

test:
	@docker build -t open-eobs-rspec:${VERSION} -f odoo/Dockerfile-rspec .
	@bundle install
	VERSION=${VERSION} bundle exec rake spec
	@rm -rf vendor
	@docker rmi open-eobs-rspec:${VERSION}

# .PHONY: build clean clone logs run stop
