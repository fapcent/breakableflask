FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" wheel

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd --create-home appuser
USER appuser

EXPOSE 4000

HEALTHCHECK --interval=30s --timeout=5s \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:4000')" || exit 1

CMD ["python", "main.py"]
