ARG base_image
FROM $base_image

RUN apt -qqy update && apt -qqy upgrade && apt install -qqy nodejs npm

ARG dev_requirements_file=jupyter.requirements.txt
ARG pip_flags
ADD $dev_requirements_file /build/tmp/jupyter.requirements.txt

RUN pip install --upgrade pip &&\
    pip install ${pip_flags} -r /build/tmp/jupyter.requirements.txt

