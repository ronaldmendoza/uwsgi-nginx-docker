
* [`python3.7`, `latest` _(Dockerfile)_](https://github.com/ronaldmendoza/uwsgi-nginx-docker/blob/master/python3.7/Dockerfile)

# uwsgi-nginx

**Docker** image with **uWSGI** and **Nginx** for web applications in **Python 3.7**, 

## Description

This [**Docker**](https://www.docker.com/) image allows you to create [**Python**](https://www.python.org/) web applications that run with [**uWSGI**](https://uwsgi-docs.readthedocs.org/en/latest/) and [**Nginx**](http://nginx.org/en/) in a single container.

The combination of uWSGI with Nginx is a [common way to deploy Python web applications like Flask and Django](http://flask.pocoo.org/docs/1.0/deploying/uwsgi/). It is widely used in the industry and would give you decent performance. (*)

This image was created to be the base image for [**tiangolo/uwsgi-nginx-flask**](https://hub.docker.com/r/rontype1/uwsgi-nginx-flask/) but could be used as the base image for any other (WSGI-based) Python web application, like Django.

---

**GitHub repo**: [https://github.com/ronaldmendoza/uwsgi-nginx-docker](https://github.com/ronaldmendoza/uwsgi-nginx-docker)

**Docker Hub image**: [https://hub.docker.com/r/rontype1/uwsgi-nginx/](https://hub.docker.com/r/rontype1/uwsgi-nginx/)
