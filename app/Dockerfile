##############################
# Builder Stage
##############################

FROM python:3.13-slim AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /install

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install \
        --prefix=/install \
        --no-cache-dir \
        -r requirements.txt


##############################
# Runtime Stage
##############################

FROM python:3.13-slim

LABEL maintainer="Subhasis Karmakar"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN addgroup --system appgroup && \
    adduser \
        --system \
        --ingroup appgroup \
        --home /app \
        appuser

COPY --from=builder /install /usr/local

COPY app.py .

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s \
             --timeout=5s \
             --start-period=10s \
             --retries=3 \
CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')"

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--threads", "2", "--access-logfile", "-", "--error-logfile", "-", "app:app"]