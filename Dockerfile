FROM arm64v8/python:3.11-slim

RUN apt-get update && apt-get install -y \
    mitmproxy \
    tshark \
    iproute2 \
    iputils-ping \
    curl \
    nano \
    ca-certificates \
    libcap2-bin \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN setcap 'cap_net_bind_service=+ep' /usr/bin/mitmproxy
RUN mkdir -p /root/.mitmproxy

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY config/block_urls.py /app/

EXPOSE 8081
CMD ["mitmweb", "--mode", "transparent@8880", "-s", "/app/block_urls.py", "--web-port", "8081"]
