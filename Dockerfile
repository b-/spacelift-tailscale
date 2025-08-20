# hadolint ignore=DL3007
FROM ghcr.io/spacelift-io/runner-terraform:latest AS spacelift

USER root

RUN <<EOF
    set -eux
    echo https://downloads.1password.com/linux/alpinelinux/stable/ >> /etc/apk/repositories
    wget https://downloads.1password.com/linux/keys/alpinelinux/support@1password.com-61ddfc31.rsa.pub -P /etc/apk/keys
    apk add --no-cache tailscale 1password-cli
EOF

COPY bin/ /usr/local/bin/

# Let tailscale/d use default socket location
RUN mkdir -p /home/spacelift/.local/share/tailscale /var/run/tailscale && chown spacelift:spacelift /home/spacelift/.local/share/tailscale /var/run/tailscale

USER spacelift
