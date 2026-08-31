#!/bin/bash
# Interactive shell into the Metavision SDK Apptainer sandbox.
#
# Usage: ./mv-shell.sh          # plain interactive shell
#        ./mv-shell.sh --nv     # ... with NVIDIA GPU passthrough
#
# --bind /run/user/$(id -u) fixes X11/Xauthority auth for GUI apps
# (Metavision Studio etc.) on Ubuntu 24.04's GDM/Xwayland sessions, where
# the Xauthority cookie lives outside Apptainer's default-bound paths.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SANDBOX="$SCRIPT_DIR/mv-sandbox"

exec apptainer shell \
    --bind "/run/user/$(id -u)" \
    "$@" \
    "$SANDBOX"
