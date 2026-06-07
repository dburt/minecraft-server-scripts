#!/usr/bin/bash

# Run the server inside a detached screen session named "mc" so its console
# (stdin) is reachable locally via `screen -S mc -X stuff "...^M"` — used by
# update_and_restart_service to warn players. This replaces network RCON.
# -Dm: detached, no fork, so systemd (Type=simple) tracks screen as the service.
exec screen -DmS mc ./minecraft_server.sh
