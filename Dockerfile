FROM python:3.12-slim

WORKDIR /app

# Corrige CVE-2025-47273 (setuptools >= 78.1.1)
RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" wheel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Ne pas exécuter en root (règle Trivy DS002)
RUN useradd --create-home appuser
USER appuser

EXPOSE 5000

# Règle Trivy DS026
HEALTHCHECK --interval=30s --timeout=5s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000')" || exit 1

CMD ["python", "app.py"]
