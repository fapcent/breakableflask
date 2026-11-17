FROM python:3.12-slim AS build
WORKDIR /build

RUN python -m venv /opt/venv
COPY requirements.txt .
RUN /opt/venv/bin/pip install --no-cache-dir --only-binary=:all: -r requirements.txt

FROM python:3.12-slim
WORKDIR /app

ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN useradd --create-home --uid 10001 appuser
COPY --from=build /opt/venv /opt/venv
COPY main.py .

USER appuser
EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://127.0.0.1:4000/', timeout=2).close()"]

CMD ["python", "main.py"]
