#!/usr/bin/make
COMPOSE_RUN = -f docker-compose.yml
COMPOSE_DEBUG = -f docker-compose.yml -f docker-compose-debug.yml
PR = ${pr}

clone:
	git clone --depth 1 https://github.com/OpusVL/Open-eObs-Modules.git odoo/addon-bundles

test:
	git clone --depth 1 https://github.com/OpusVL/Open-eObs-Modules.git odoo/addon-bundles
	git -C odoo/addon-bundles fetch origin pull/${PR}/head:pr-${pr}
	git -C odoo/addon-bundles checkout pr-${pr}

run:
	docker-compose ${COMPOSE_RUN} up -d

stop:
	docker-compose ${COMPOSE_RUN} stop

clean:
	docker-compose ${COMPOSE_RUN} down -v
	rm -rf odoo/addon-bundles

debug:
	docker-compose ${COMPOSE_DEBUG} up -d

destroy:
	docker-compose ${COMPOSE_DEBUG} down -v

logs:
	docker-compose ${COMPOSE_DEBUG} logs -f

.PHONY: run stop clean debug destroy logs test clone
