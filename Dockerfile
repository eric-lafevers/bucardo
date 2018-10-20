FROM ubuntu:xenial

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update
RUN apt-get install -y libdbi-perl libdbd-pg-perl libboolean-perl wget build-essential libreadline-dev libz-dev autoconf bison libtool libproj-dev libgdal-dev libxml2-dev libxml2-utils libjson0-dev xsltproc docbook-xsl docbook-mathml libossp-uuid-dev libperl-dev libdbix-safe-perl git postgresql-9.5 postgresql-plperl-9.5 libencode-locale-perl libcgi-fast-perl libcgi-pm-perl

ENV PATH="/usr/lib/postgresql/9.5/bin:${PATH}"

RUN mkdir -p /var/run/bucardo
RUN mkdir -p /var/log/bucardo/bucardo
RUN chown postgres.postgres /var/run/bucardo
RUN chown postgres.postgres /var/log/bucardo

USER postgres 
ENV USER="postgres"

WORKDIR /tmp
RUN git clone https://github.com/aks/bucardo.git
RUN chown -R postgres bucardo
WORKDIR /tmp/bucardo
RUN PATH=${PATH} perl Makefile.PL
RUN PATH=${PATH} make
RUN PATH=${PATH} make test
RUN make install
