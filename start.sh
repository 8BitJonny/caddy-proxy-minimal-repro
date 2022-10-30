#!/bin/sh

### <--- Tailscale Setup Section
# env -i /app/tailscaled --tun=userspace-networking --socks5-server=localhost:55555 --outbound-http-proxy-listen=localhost:55555 &
# env -i /app/tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=caddy

# echo "tailscale has started ........... now reloading caddy"
# /app/tailscale status
### <--- Tailscale Setup Section

### <--- Test Tailscale Setup Section
### THIS COMMAND works with Tailscale and you reach your node. While down below caddy won't be able to reach the node
# ALL_PROXY=socks5://localhost:55555/ curl http://100.81.184.38:3000 # INSERT YOUR TAILSCALE NODE IP HERE
### <--- Test Tailscale Setup Section

### <--- Run Caddy with Tailscale Proxy
# ALL_PROXY=socks5://localhost:55555/ http_proxy=http://localhost:55555/ caddy start --config /etc/caddy/Caddyfile

### <--- Run Caddy with TinyProxy
http_proxy=http://localhost:3128/ caddy start --config /etc/caddy/Caddyfile

tinyproxy -d -c <(echo -e "Port 3128\nMaxClients 100\nStartServers 10\n")
