This mod adds some extra console commands to the game. To see what commands are added use the console commmand `/cli_ext`
 
Currently only a couple of commands from [https://wiki.factorio.com/Console](https://wiki.factorio.com/Console) are implemented. 
In time I hope to have (almost) all of the commands in that list implemented.

Current commands:
| Command | Description |
| :--- | :--- |
| `become_god` | This command removes the players character, making the player 'god'. Requires you to be admin if adminsOnly is true |
| `become_mortal` | This command puts the player in a character, making the player 'mortal'. Useful if destroy_selected was used on a player character on accident |
| `cli_ext` | This command shows all commands added by this mod |
| `destroy_selected` | This command destroys the entity that is currently selected (also player characters, leaving them in god mode, use /become_mortal to exit god mode). Requires you to be admin if adminsOnly is true |
| `finish_current_tech` | This command finishes the current research. It does not use science packs, nor does it return already used packs. Requires you to be admin if adminsOnly is true | 
| `freeze` | This command freezes the time of day of the game. Requires you to be admin if adminsOnly is true |
| `give_stack` | This command gives the player a stack of the specified item. Requires you to be admin if adminsOnly is true |
| `kill_enemies` | This command removes all generated enemies from the map. Requires you to be admin if adminsOnly is true |
| `lock_all_tech` | This command unresearches the entire tech tree. Science packs used on the tech tree are not returned. Requires you to be admin if adminsOnly is true |
| `lock_tech` | This command unresearches the specified technology and all that depend on it. Needs the name of the research as known to the game. It does not return the science packs used for the tech(s). Requires you to be admin if adminsOnly is true |
| `pickup_dropped_items` | This command transfers all items from the ground to your inventory. By default it picks up everything in a 32 square radius, but this can be specified by passing a number as argument. Requires you to be admin if adminsOnly is true |
| `position` | This command tells you your coordinates |
| `position_to_global_chat` | This command tells everyone your coordinates |
| `position_to_player` | This command tells a specific player your coordinates. Needs the name of the player as argument(case sensitive) |
| `save` | This command instructs the server to save the current map under the given name. If no name is given it saves the map overwrites the current save. |
| `set_crafting_speed` | This commands sets the crafting speed of the specified player, If no player is given it has effect on the player using the command. Accepts 1 or 2 arguments. Modifier(required), player name(optional). Requires you to be admin if adminsOnly is true |
| `set_mining_speed` | This commands sets the mining speed of the specified player, If no player is given it has effect on the player using the command. Accepts 1 or 2 arguments. Modifier(required), player name(optional). Requires you to be admin if adminsOnly is true |
| `set_running_speed` | This commands sets the running speed of the specified player, If no player is given it has effect on the player using the command. Accepts 1 or 2 arguments. Modifier(required), player name(optional). Requires you to be admin if adminsOnly is true |
| `speed` | This command changes the speed of the game. Needs the percentage of the wanted speed (100 is normal speed, 50 is half speed, 200 is double). Has a range from 1 to 10.000. Requires you to be admin if adminsOnly is true |
| `teleport_to` | This command teleports you to the specified coordinates. Needs two coordinates x coordinate and y coordinate. Requires you to be admin if adminsOnly is true |
| `teleport_to_player` | This command teleports you to the right of the specified player. Needs the name of the player to teleport to. Requires you to be admin if adminsOnly is true |
| `toggle_cheat` | This command toggles cheat mode. Requires you to be admin if adminsOnly is true |
| `toggle_expansion` | This command toggles biter expansion. Requires you to be admin if adminsOnly is true |
| `toggle_night` | This command turns the night on and off. Requires you to be admin if adminsOnly is true |
| `toggle_peace` | This command toggles peaceful mode. Requires you to be admin if adminsOnly is true |
| `unlock_all_tech` | This command researches everything except for infinite techs. Requires you to be admin if adminsOnly is true |
| `unlock_tech` | This command researches the specified technology and all that it depends on. Needs the name of the research as known to the game. Requires you to be admin if adminsOnly is true |
| `zoom` | This command changes the zoom level. Needs the percentage of the wanted zoom (100 is normal speed, 50 is half speed, 200 is double). Has a range from 4 to 1.000 |