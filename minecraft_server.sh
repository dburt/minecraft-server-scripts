#!/bin/bash

# Vanilla
#java -Xmx1024M -Xms1024M -jar minecraft_server.1.19.3.jar nogui

# Paper
# exec so java replaces this shell and directly owns screen's pty as its stdin,
# so `screen ... stuff` reaches the server console.
exec java -Xmx2G -Xms2G -jar minecraft_server.jar nogui

