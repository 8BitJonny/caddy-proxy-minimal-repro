# Caddy-proxy-minimal-repro
A minimal reproduction repo showing the struggles to setup caddy with a proxy (either tailscale or tinyproxy)

## Commands to run
```sh
docker build -t caddy_proxy:latest .
docker run -ti -p 43890:43890 --env TAILSCALE_AUTHKEY=TailScale-ApiKey --name caddy caddy_proxy
```

In a second terminal 
```sh
docker exec -it caddy /bin/sh
curl http://172.17.0.2/api //This errors with either proxy successfully forwarding the request
```
