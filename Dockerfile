FROM python:3.13-slim AS builder

WORKDIR /app

COPY requirements.txt .

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN python -m venv .venv/
RUN .venv/bin/python -m pip install --upgrade pip
RUN .venv/bin/python -m pip install --no-cache-dir -r requirements.txt

# Etapa 2: Ejecución
FROM python:3.13-slim AS runtime

WORKDIR /app

# Copiamos el venv completo
COPY backend backend/
COPY data data/
COPY app.py .
COPY --from=builder /app/.venv .venv/

# Variables de entorno críticas
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="$PATH:/app/.venv/bin"

EXPOSE 9091

RUN adduser app
USER app

ENTRYPOINT ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "9091"]