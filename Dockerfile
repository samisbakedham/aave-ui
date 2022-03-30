FROM node:16 as build-deps
WORKDIR /app

ADD package.json package-lock.json /app/
RUN npm ci

# general ETH config
ARG REACT_APP_SUPPORTED_ETHEREUM_NETWORKS
ARG REACT_APP_DEFAULT_ETHEREUM_NETWORK
ARG REACT_APP_RATES_HISTORY_ENDPOINT

# gitlab integration
ARG REACT_APP_CI_PROJECT_ID
ARG REACT_APP_CI_MERGE_REQUEST_IID
ARG REACT_APP_CI_PROJECT_PATH
ARG REACT_APP_CI_COMMIT_REF_NAME

# analitics and metrics
ARG REACT_APP_GTM_ID
ARG REACT_APP_SENTRY_DSN

# Payments
ARG REACT_APP_TRANSAK_API_KEY
ARG REACT_APP_ONRAMP_API_KEY

# Wallets
ARG REACT_APP_FORTMATIC_KEY_MAINNET
ARG REACT_APP_FORTMATIC_KEY_TESTNET
ARG REACT_APP_AUTHEREUM_API_KEY
ARG REACT_APP_PORTIS_DAPP_ID

ADD ./ /app

FROM nginx:1.21-alpine

COPY default.conf /etc/nginx/conf.d/
COPY --from=build-deps /app/build/ /server_root/

ARG NGINX_MODE=prod
COPY robots.txt.$NGINX_MODE /server_root/robots.txt
