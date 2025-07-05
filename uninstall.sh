#!/bin/bash
set -e

echo "[+] Stopping and removing containers..."
docker compose down --rmi local

echo "[+] Removing iptables rules..."
sudo iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080 || true
sudo iptables -t nat -D PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8080 || true

echo "[+] Disabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=0
sudo sed -i '/net.ipv4.ip_forward=1/d' /etc/sysctl.conf

echo "[+] Cleanup complete. All related components removed."
