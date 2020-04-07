FROM rontype1/uwsgi-nginx:latest

COPY ./app/app/app-wsgi.py /app/app/app-wsgi.py
