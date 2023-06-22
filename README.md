# Minecraft paper server scripts

Scripts for managing a Minecraft server with:
* [Paper](https://papermc.io/) for the plugin-capable and performant version of the [Minecraft Java server](https://www.minecraft.net/en-us/download/server) itself
* [Geyser](https://geysermc.org/) and [Floodgate](https://wiki.geysermc.org/floodgate/) to proxy in Bedrock clients
* [Simple Voice Chat](https://modrinth.com/plugin/simple-voice-chat) plugin for voice chat
* Bash and Ruby scripts to automate backups, updates, and launching the server alongside a log viewer web app.

Inspired by [Legendary-Java-Minecraft-Geyser-Floodgate](https://github.com/TheRemote/Legendary-Java-Minecraft-Geyser-Floodgate).

## Scripts

### Example usage

```
./backup.sh && ./update.sh && ./start.sh
```

### start.sh

Start the Minecraft server using Foreman and its Procfile.

* Procfile: run `./minecraft_server.rb` and `./log_viewer_server.rb`
* minecraft\_server.rb: run Paper Minecraft server
* log\_viewer\_server.rb: run simple Sinatra log viewer server

### update.sh

Check for and install any available updates to Paper, Geyser, Floodgate, and Simple Voice Chat.

### backup.sh

Create a full backup including the world and the apps and scripts.
