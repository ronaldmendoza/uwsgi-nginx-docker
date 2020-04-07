FROM python:3.7.7-slim-buster

LABEL maintainer="Ronald Mendoza <rontype1@gmail.com>"
## Updated to use debian Buster, python 3.7.7. nginx 1.17.9 & njs module versions
## Based on work by Sebastian Ramirez <tiangolo@gmail.com>"
## https://github.com/tiangolo/uwsgi-nginx-docker

# Standard set up Nginx
ENV NGINX_VERSION 1.17.9-1~buster
ENV NJS_VERSION   1.17.9.0.3.9-1~buster

RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y gnupg2 apt-transport-https ca-certificates \
        && \
	NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
	found=''; \
	for server in \
		ha.pool.sks-keyservers.net \
		hkp://keyserver.ubuntu.com:80 \
	; do \
		echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
		apt-key adv --no-tty --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
	done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
	apt-get remove --purge --auto-remove -y gnupg2 \
	&& dpkgArch="$(dpkg --print-architecture)" \
	&& nginxPackages=" \
		nginx=${NGINX_VERSION} \
		nginx-module-xslt=${NGINX_VERSION} \
		nginx-module-geoip=${NGINX_VERSION} \
		nginx-module-image-filter=${NGINX_VERSION} \
		nginx-module-njs=${NJS_VERSION} \
	" \
# arches amd64|i386 officialy built by upstream
	&& echo "deb https://nginx.org/packages/mainline/debian/ buster nginx" >> /etc/apt/sources.list.d/nginx.list \
        && apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						$nginxPackages \
						gettext-base \
	\
# Install C compiler for uWSGI since we used python-slim
	&& apt-get install --no-install-recommends --no-install-suggests -y build-essential python3-dev \

# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)
	&& rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/nginx.list \
	&& if [ -n "$tempDir" ]; then \
		apt-get purge -y --auto-remove \
		&& rm -rf "$tempDir" /etc/apt/sources.list.d/temp.list; \
	fi

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80
# Removed the section that breaks pip installations
# && apt-get remove --purge --auto-remove -y apt-transport-https ca-certificates
# added --no-tty to apt-key adv as without it it breaks (even though it works in official Nginx)
# apt-key adv --no-tty
# Standard set up Nginx finished

# Expose 443, in case of LTS / HTTPS
# EXPOSE 443

# Install uWSGI
RUN pip3 install uwsgi

# Remove default configuration from Nginx
RUN rm /etc/nginx/conf.d/default.conf
# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
COPY uwsgi.ini /etc/uwsgi/

# Install Supervisord
RUN apt-get update && apt-get install -y supervisor \
&& rm -rf /var/lib/apt/lists/*
# Custom Supervisord config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Which uWSGI .ini file should be used, to make it customizable
ENV UWSGI_INI /app/uwsgi.ini

# By default, run 2 processes
ENV UWSGI_CHEAPER 2

# By default, when on demand, run up to 16 processes
ENV UWSGI_PROCESSES 16

# By default, allow unlimited file sizes, modify it to limit the file sizes
# To have a maximum of 1 MB (Nginx's default) change the line to:
ENV NGINX_MAX_UPLOAD 1m
# ENV NGINX_MAX_UPLOAD 0

# By default, Nginx will run a single worker process, setting it to auto
# will create a worker for each CPU core
ENV NGINX_WORKER_PROCESSES 1

# By default, Nginx listens on port 80.
# To modify this, change LISTEN_PORT environment variable.
# (in a Dockerfile or with an option for `docker run`)
ENV LISTEN_PORT 80

# Copy start.sh script that will check for a /app/prestart.sh script and run it before starting the app
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Copy the entrypoint that will generate Nginx additional configs
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Add demo app
COPY ./app /app
WORKDIR /app

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Supervisor, which in turn will start Nginx and uWSGI
CMD ["/start.sh"]
