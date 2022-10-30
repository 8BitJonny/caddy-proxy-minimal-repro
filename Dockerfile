FROM caddy:2-alpine as builder
WORKDIR /app
COPY . ./
COPY ./Caddyfile /etc/caddy/Caddyfile


FROM alpine:latest as tailscale
WORKDIR /app
COPY . ./
ENV TSFILE=tailscale_1.32.1_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && tar xzf ${TSFILE} --strip-components=1
COPY . ./


# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM caddy:2-alpine
RUN apk update && apk add curl tinyproxy ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy binary to production image
COPY --from=builder /app/start.sh /app/start.sh
COPY --from=builder /etc/caddy/Caddyfile /etc/caddy/Caddyfile
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# Run on container startup.
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
