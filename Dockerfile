FROM ghcr.io/spacelift-io/runner-terraform:latest AS tailscale-builder

USER root
WORKDIR /src

RUN apk add --no-cache git go && \
  git clone --depth 1 --branch main https://github.com/tailscale/tailscale /src/tailscale && \
  cd /src/tailscale/cmd/get-authkey && \
  go build -o get-authkey ./...

# hadolint ignore=DL3007
FROM ghcr.io/spacelift-io/runner-terraform:latest AS spacelift

USER root

# hadolint ignore=DL3018
RUN apk add --no-cache tailscale

COPY --from=tailscale-builder /src/tailscale/cmd/get-authkey/get-authkey /usr/local/bin/

COPY bin/ /usr/local/bin/

# Let tailscale/d use default socket location
RUN mkdir -p /home/spacelift/.local/share/tailscale /var/run/tailscale && chown spacelift:spacelift /home/spacelift/.local/share/tailscale /var/run/tailscale

USER spacelift
