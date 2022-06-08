ARG dev_image
FROM $dev_image
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV ACCEPT_EULA=Y
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qqy update && \
    apt-get install -qqy python3-dev build-essential gcc g++ && \
    apt-get -qqy update && \
    python3 -m pip install --upgrade pip

#install code-server
#RUN curl -fsSL https://code-server.dev/install.sh | sh

ADD odbcinst.ini /etc/odbcinst.ini
ADD scripts /scripts
ADD pip_pre_install /build/tmp/pre_install

RUN touch /build/tmp/pre_install/initial.txt &&\
    pip install ${pip_flags} -r /build/tmp/pre_install/initial.txt

ARG install_msodbc="no"
RUN /scripts/install_mssql.sh $install_msodbc

ARG pip_flags
RUN touch /build/tmp/pre_install/requirements.txt &&\
    touch /build/tmp/pre_install/secondary.txt &&\
    pip install ${pip_flags} -r /build/tmp/pre_install/requirements.txt &&\
    pip install ${pip_flags} -r /build/tmp/pre_install/secondary.txt

ADD repos /repos
ENV PIP_FIND_LINKS=/repos
ARG legacy_resolver
ARG install_spark
ADD pip_override /pip_override
RUN /scripts/dev_install.sh $legacy_resolver $install_spark

RUN rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*
