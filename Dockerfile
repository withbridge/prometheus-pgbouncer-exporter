FROM python:3.6.10-alpine

RUN apk update && \
    apk add postgresql-libs && \
    apk add --virtual .build-deps gcc musl-dev postgresql-dev && \
    python3 -m pip install prometheus-pgbouncer-exporter==2.1.1 --no-cache-dir && \
    apk --purge del .build-deps

ENV PGBOUNCER_EXPORTER_HOST="127.0.0.1" \
    PGBOUNCER_EXPORTER_PORT=9127 \
    STATS_DATABASE_URL=postgresql://pgbouncer:pgbouncer@localhost:6432/pgbouncer \
    STACK=${STACK}

EXPOSE 9127

COPY config.docker.yml /etc/pgbouncer-exporter/config.yml

ENTRYPOINT ["pgbouncer-exporter"]
CMD ["--config", "/etc/pgbouncer-exporter/config.yml"]
