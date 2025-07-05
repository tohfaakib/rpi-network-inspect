#!/bin/bash
set -e

echo "[+] Installing dependencies..."
sudo apt update && sudo apt install -y iptables docker.io docker-compose

echo "[+] Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

echo "[+] Adding iptables redirect rules..."
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8080

echo "[+] Building and starting Docker stack..."
docker compose build
docker compose up -d

echo "[+] Setup complete! Access mitmweb at: http://$(hostname -I | awk '{print $1}'):8081"
echo "[+] View packet logs at: http://$(hostname -I | awk '{print $1}'):8082"
