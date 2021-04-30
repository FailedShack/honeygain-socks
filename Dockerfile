FROM debian:buster-slim

RUN addgroup --gid 10001 app \
&& adduser --system --home /app --uid 10001 --gid 10001 app

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
build-essential ca-certificates cmake git iproute2 supervisor \
&& git clone https://github.com/ambrop72/badvpn \
&& mkdir badvpn/build \
&& (cd badvpn/build \
&& cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1 \
&& make install) \
&& rm -r badvpn

COPY entrypoint.sh /app
COPY supervisord.conf /app
COPY --from=honeygain/honeygain:latest /app /app

RUN chown -R app:app /app

WORKDIR /app
ENV DNS_SERVER=1.1.1.1
ENV SOCKS_HOST=
ENV SOCKS_PORT=1080
ENV HG_USER=
ENV HG_PASS=
ENV HG_NAME=

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "supervisord.conf"]
