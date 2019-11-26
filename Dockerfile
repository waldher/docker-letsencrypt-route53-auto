FROM alpine:3.10

RUN apk add --no-cache python3 bash curl
RUN apk add --no-cache --virtual .build-dependencies alpine-sdk libffi-dev python3-dev openssl-dev && pip3 install dns-lexicon[route53] && apk del .build-dependencies

WORKDIR /work

RUN apk add --no-cache openssl
RUN wget -q https://github.com/lukas2511/dehydrated/raw/v0.6.5/dehydrated
RUN chmod +x dehydrated
RUN wget -q https://github.com/AnalogJ/lexicon/raw/v3.3.10/examples/dehydrated.default.sh
RUN chmod +x dehydrated.default.sh
ADD entrypoint.sh .

VOLUME "/work/certs"
VOLUME "/work/accounts"

ENTRYPOINT ["./entrypoint.sh"]
