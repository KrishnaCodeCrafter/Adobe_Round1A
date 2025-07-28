FROM python:3.9-slim-buster AS builder

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libharfbuzz-dev \
    libfreetype6-dev \
    libfontconfig1 \
    libjpeg-dev \
    zlib1g-dev \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

RUN mkdir -p input output

CMD ["python", "main.py"]