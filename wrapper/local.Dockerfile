ARG python_version=3.7-slim
FROM python:${python_version}

ARG pkg
ARG pkg_extra
ARG pkg_version
ARG pkg_dir
ARG pkg_full="${pkg}[${pkg_extra}]==${pkg_version}"
ARG pkg_main=main
ARG pkg_app=application


ADD wrapper/requirements.txt /build/requirements.txt
ADD wrapper/conf /app_conf

ADD ${pkg_dir} /build/pkgs

RUN apt-get -qqy update &&\
    apt-get install -qqy python3-dev build-essential &&\
    pip install -r /build/requirements.txt &&\
    pip install --find-links=file:///build/pkgs ${pkg_full} &&\
    rm -rf /build


ENV WSGI_APP=${pkg}.${pkg_main}:${pkg_app}

CMD gunicorn --config /app_conf/gunicorn_config.py ${WSGI_APP}
