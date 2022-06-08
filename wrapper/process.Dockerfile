ARG python_version=3.7-slim
FROM python:${python_version}

ARG pkg
ARG pkg_extra
ARG pkg_version
ARG pkg_dir
ARG pkg_full="${pkg}[${pkg_extra}]==${pkg_version}"
ARG pkg_main=run_process

RUN apt-get -qqy update &&\
    apt-get install -qqy python3-dev build-essential

ADD ${pkg_dir} /build/pkgs

RUN pip install --find-links=file:///build/pkgs ${pkg_full} &&\
    rm -rf /build

ENV PYTHONUNBUFFERED=1

ENV WSGI_APP=${pkg}.${pkg_main}:${pkg_app}
ENV MAIN_APP=${pkg_main}
CMD ${MAIN_APP}
