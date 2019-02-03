#!/usr/bin/make
COMPOSE_FILE = -f docker-compose.yml
COMPOSE_DEBUG = -f docker-compose.yml -f docker-compose-debug.yml
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
	@docker-compose ${COMPOSE_DEBUG} up --quiet-pull --build --no-start
	@docker-compose ${COMPOSE_DEBUG} up -d

debug-clean:
	@docker-compose ${COMPOSE_DEBUG} down -v

debug-pr: debug-clean clean repo
	@echo -n "Checking out PR ${PR} ... "
	@echo
	@git -C odoo/addon-bundles/Open-eObs-Modules fetch -q origin pull/${PR}/head:PR-${PR}
	@git -C odoo/addon-bundles/Open-eObs-Modules checkout PR-${PR}

debug-branch: debug-clean clean repo
	@echo -n "Checking out ${BRANCH} ... "
	@echo
	@git -C odoo/addon-bundles/Open-eObs-Modules fetch origin ${BRANCH}
	@git -C odoo/addon-bundles/Open-eObs-Modules checkout -q ${BRANCH}

debug-down:
	docker-compose ${COMPOSE_DEBUG} down -v

debug-logs:
	docker-compose ${COMPOSE_DEBUG} logs -f

# .PHONY: build clean clone logs run stop
