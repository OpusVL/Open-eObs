FROM quay.io/opusvl/odoo-custom:8.0
MAINTAINER James Curtis <james.curtis@opusvl.com>

USER root
ENV PG_MAJOR 10
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
RUN apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            gcc \
            g++ \
            libxslt-dev \
            python-dev \
            libxml2-dev \
            libxslt1-dev \
            libxslt-dev \
            build-essential \
            python-lxml \
            postgresql-client-10

RUN chown -R odoo: /var/lib/odoo
RUN mkdir -p /bcp/out
RUN chown -R odoo: /bcp

# pip install concatenated requirements.txt from generate_requirements_txt.sh
COPY ./requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

RUN mkdir -p /mnt/extra-addons-bundles
RUN chmod -R 755 /mnt/extra-addons-bundles
COPY ./addon-bundles/ /mnt/extra-addons-bundles/

RUN apt -y purge \
            gcc \
            g++ \
            libxslt-dev \
            python-dev \
            libxml2-dev \
            libxslt1-dev \
            libxslt-dev \
            build-essential

USER odoo

