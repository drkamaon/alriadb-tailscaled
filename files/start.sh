#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Start the Tailscale daemon in the background
/usr/local/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

# Bring the Tailscale interface up using your auth key from the environment
/usr/local/bin/tailscale up --authkey=${TS_AUTHKEY} --hostname=${TS_HOSTNAME}

# Your original entrypoint is now executed
# The 'exec' command replaces this script with your application's process
echo "[i] Hello, Tailscale is up now. Starting MariaDB service..."

exec /scripts/run.sh