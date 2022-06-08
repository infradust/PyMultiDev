ARG node_version=latest
FROM node:${node_version}
ARG ng_cli_version=latest
ENV NG_CLI_VERSION=${ng_cli_version}
RUN yarn global add @angular/cli@$NG_CLI_VERSION -T && rm -rf $(yarn cache dir)