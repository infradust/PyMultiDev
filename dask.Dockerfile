ARG dev_version=dev
FROM multidev:$dev_version
RUN python3 -m pip install --upgrade pip
RUN pip install -U \
    dask[complete]==2021.9.0 \
    gcsfs==2021.8.1 \
    s3fs==2021.8.1 \
    fsspec==2021.8.1 \
    pyarrow==5.0.0
