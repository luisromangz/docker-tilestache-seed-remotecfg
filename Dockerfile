#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM python:2.7
MAINTAINER Luis Román<luisromangz@gmail.om>

RUN apt-get -y update

#-------------Application Specific Stuff ----------------------------------------------------

ENV LAYER_NAME layer-name

RUN apt-get install -y \
    python-imaging \
    python-yaml \
    libproj0 \
    libgeos-dev \
    python-lxml \
    libgdal-dev \
    build-essential \
    python-dev \
    libjpeg-dev \
    zlib1g-dev \
    libfreetype6-dev \
    python-virtualenv \
    unzip
RUN pip install shapely eventlet pillow mapnik python-memcached boto tilestache pyproj gunicorn 

EXPOSE 8080

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
