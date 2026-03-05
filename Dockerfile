# Etapa 1: Constructor
FROM python:3.13-slim AS builder

# Instalar dependencias de compilación si son necesarias (ej. gcc)
# RUN apt-get update && apt-get install -y --no-install-recommends \
#    build-essential \
#    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Configuración de UV y Venv
ENV UV_PROJECT_ENVIRONMENT=/opt/venv
RUN pip install --no-cache-dir uv

COPY requirements.txt .
# UV creará el venv y sincronizará dependencias automáticamente
RUN uv venv /opt/venv && uv pip install --no-cache-dir -r requirements.txt

# Etapa 2: Ejecución
FROM python:3.13-slim AS runtime

WORKDIR /app

# Copiamos el venv completo
COPY --from=builder /opt/venv /opt/venv
COPY . .

# Variables de entorno críticas
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Es buena práctica no ejecutar como root
RUN useradd -m appuser
USER appuser

CMD ["python", "app.py"]