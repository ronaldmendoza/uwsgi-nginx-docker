FROM rontype1/uwsgi-nginx:latest

COPY ./application /application
COPY ./prestart.sh /app/prestart.sh
WORKDIR /application

EXPOSE 8080
