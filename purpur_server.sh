#!/usr/bin/bash

docker run -it -v minecraft-purpur-geyser:/minecraft \
       -p 25566:25566 -e Port=25566 \
       -p 19132:19132/udp -p 19132:19132 \
       -e TZ="Australia/Melbourne" \
       -e TZ="Australia/Melbourne" \
       -e ScheduleRestart="3:30" \
       -e NoBackup="plugins" \
       --restart unless-stopped \
       05jchambers/legendary-minecraft-purpur-geyser:latest
