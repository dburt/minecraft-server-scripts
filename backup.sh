#!/bin/bash

tar -I pigz --exclude='./backups' --exclude='./cache' --exclude='./logs' --exclude='./paperclip.jar' \
	--exclude='*.jar' --exclude='libraries' --exclude='client_mods' --exclude='plugins_available' \
       	-pvcf backups/full-$(date +%Y.%m.%d.%H.%M.%S).tar.gz ./*
