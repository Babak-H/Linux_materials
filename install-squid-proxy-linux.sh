#!/bin/bash
set -euo pipefail

# Install and start Squid Proxy.
# Optional authentication:
#   sudo env PROXY_USER=myuser PROXY_PASSWORD=mypassword ./install-squid-proxy-linux.sh

SQUID_CONF="/etc/squid/squid.conf"
SQUID_BACKUP="/etc/squid/squid.conf.default"
HTPASSWD_FILE="/etc/squid/htpasswd"
PROXY_USER="${PROXY_USER:-}"
PROXY_PASSWORD="${PROXY_PASSWORD:-}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this script as root, for example: sudo $0" >&2
  exit 1
fi

apt-get update
apt-get install -y squid apache2-utils

if [[ ! -f "${SQUID_BACKUP}" ]]; then
  cp "${SQUID_CONF}" "${SQUID_BACKUP}"
fi

# Allow clients from Squid's configured localnet ACL.
sed -i 's/^[[:space:]]*#\?[[:space:]]*http_access[[:space:]]\+allow[[:space:]]\+localnet/http_access allow localnet/' "${SQUID_CONF}"

if [[ -n "${PROXY_USER}" || -n "${PROXY_PASSWORD}" ]]; then
  if [[ -z "${PROXY_USER}" || -z "${PROXY_PASSWORD}" ]]; then
    echo "Set both PROXY_USER and PROXY_PASSWORD to enable authentication." >&2
    exit 1
  fi

  htpasswd -bc "${HTPASSWD_FILE}" "${PROXY_USER}" "${PROXY_PASSWORD}"
  chown proxy:proxy "${HTPASSWD_FILE}"
  chmod 640 "${HTPASSWD_FILE}"

  if ! grep -q "^auth_param basic program .*basic_ncsa_auth" "${SQUID_CONF}"; then
    auth_block=$(mktemp)
    updated_conf=$(mktemp)

    tee "${auth_block}" >/dev/null <<EOF
# Basic proxy authentication
auth_param basic program /usr/lib/squid/basic_ncsa_auth ${HTPASSWD_FILE}
auth_param basic realm Squid Proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated

EOF

    awk -v block_file="${auth_block}" '
      BEGIN {
        while ((getline line < block_file) > 0) {
          block = block line ORS
        }
        close(block_file)
      }
      !inserted && /^[[:space:]]*http_access[[:space:]]+deny[[:space:]]+all([[:space:]]*(#.*)?)?$/ {
        printf "%s", block
        inserted = 1
      }
      { print }
      END {
        if (!inserted) {
          printf "%s", block
        }
      }
    ' "${SQUID_CONF}" >"${updated_conf}"

    cat "${updated_conf}" >"${SQUID_CONF}"
    rm -f "${auth_block}" "${updated_conf}"
  fi
fi

systemctl enable squid
systemctl restart squid

if systemctl is-active --quiet squid; then
  echo "Squid is running."
  echo "Recent access log entries:"
  tail -n 20 /var/log/squid/access.log
else
  echo "Squid failed to start. Check logs with: journalctl -u squid" >&2
  exit 1
fi
