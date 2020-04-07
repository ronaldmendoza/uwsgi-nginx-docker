FROM rontype1/uwsgi-nginx:latest

COPY ./app/app-wsgi.py /app/app-wsgi.py
