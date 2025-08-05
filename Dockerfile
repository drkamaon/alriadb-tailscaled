# You can use your specific Alpine version or latest
FROM alpine:latest

# Install all packages at once: Tailscale's dependencies + your app's dependencies
RUN apk update && apk add --no-cache \
    ca-certificates \
    iptables \
    ip6tables \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    pwgen \
    && rm -rf /var/cache/apk/*

# --- Your Application Setup ---
# Copy your original run script from your "files" directory
COPY files/run.sh /scripts/run.sh

# Copy the new startup script (you must create this file, see step 2)
COPY files/start.sh /scripts/start.sh

# Create your required directories and set correct permissions
RUN mkdir -p /docker-entrypoint-initdb.d \
    /scripts/pre-exec.d \
    /scripts/pre-init.d \
    /scripts/first-run.d && \
    chmod -R 755 /scripts && \
    chmod 755 /scripts/start.sh

# --- Tailscale Setup ---
# Copy Tailscale binaries directly from the official image
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscaled /usr/local/bin/
COPY --from=docker.io/tailscale/tailscale:stable /usr/local/bin/tailscale /usr/local/bin/

# Create Tailscale state directories
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

# --- Container Configuration ---
# Your original EXPOSE and VOLUME instructions
EXPOSE 3306
VOLUME ["/data/mariadb/kotatsu-db"]

# This is the new command. It runs your "start.sh" script which handles everything.
CMD ["/scripts/start.sh"]