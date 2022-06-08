ARG python_version=3.6-slim
FROM python:${python_version}

ARG pkg
ARG pkg_extra
ARG pkg_version
ARG pkg_full="${pkg}[${pkg_extra}]==${pkg_version}"
ARG pkg_main=run_server
ARG pkg_app=application
ARG nexus_password
ARG nexus_pypi=https://nexus:${nexus_password}@nexus.project.com:8443/repository/pypi-all
ARG pip_index_url_="--index-url ${nexus_pypi}/pypi"
ARG pip_extra_url_="--extra-index-url ${nexus_pypi}/simple"
ARG pip_cert_="--cert /build/ca-bundle.crt"

ADD ca-bundle.crt /build/ca-bundle.crt
ADD wrapper/requirements.txt /build/requirements.txt
ADD wrapper/conf /app_conf

RUN apt-get -qqy update &&\
    apt-get install -qqy python3-dev build-essential &&\
    pip install -r build/requirements.txt
RUN pip install ${pkg_full} ${pip_cert_} ${pip_index_url_} ${pip_extra_url_} &&\
    rm -rf /build

ENV WSGI_APP=${pkg}.${pkg_main}:${pkg_app}

CMD gunicorn --config /app_conf/gunicorn_config.py ${WSGI_APP}


