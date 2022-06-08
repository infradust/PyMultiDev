# Description
development wrapper for multiple python packages with dependencies from different repositories.

# Prerequisites:
* ssh clone permissions from your repository
* docker-compose
* go over '.env' file for default environment variables values
* to upload to nexus:
    * you must have a nexus certificate file:<br>
        * default path is: '~/nexus/ca-bundle.crt'
        * you can point to a different location by setting:<br>
            ```bash
            export NEXUS_CERT=<path_to_cert_file>
            ```
    * expose nexus user name and password:
        ```bash
        export NEXUS_USER=<user>
        export NEXUS_PASSWORD=<password>
        ```

# How to use:
1. clone your repositories:  
    ```bash
    ./clone repo1:0.0.1 repo2 repo3 repo4
    ```
    the version will clone the repository from that tag in the repository, so changes should be done with care<br>
    
    this will clone the repositories into ./repos folder:
    * .env file : useful environment variables (like PYTHONPATH) to use in the development container
2. create the development container (**optional**):  
    ```bash
     docker-compose build
    ```
    by default, ./repos, ./dist, ~/data will be mounted to the development container
4. make changes, debug and test (use of PyCharm is preferable) (**optional**)<br>
    * in PyCharm, define the remote interpreter to point to the docker-compose.yaml file and use 'multidev' service
    * set environment variables for the interpreter
        * DEV_PKG_NAME (PyCharm default is random)
        * DOCKER_NETWORK (PyCharm default is 'bridge')
    * add directory mapping from '.repos/' to '/repos' in the container
    * if needed, set the internal port of your development container (default is 80):
        ```bash
        export SERVICE_INTERNAL_PORT=<internal_port>
        ```
    * if needed, set the host port of your development container (default is 8088):
        ```bash
        export SERVICE_PORT=<host_port>
        ```
    * if needed, set the docker network to run the development container in:<br>
        ```bash
        export DOCKER_NETWORK=<your_dev_network>
        ```
5. build distribution and upload to nexus:<br>
    ```bash
    ./make_and_upload.sh [--clean, to remove all existing distributions]
    ```
    * make sure *NEXUS_CERT*, *NEXUS_USER* and *NEXUS_PASSWORD* are set properly in your environment
    * note: the packages will be created with the current version specified in the setup.py file
    * see concepts_api repository setup.py for example on using versions in setup py
6. distribution files will be present under ./dist directory
7. if working on a WSGI application, clone the WSGIWrapper repository and follow instructions to produce a REST service image.
        
    
