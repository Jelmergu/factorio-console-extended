local Commands = {}
Commands.util = {}
Commands.util.dontUse = {}

function Commands.become_god(self)
    if self.util.allowedToUse() == false then return end
    local playerCharacter = game.player.character
    game.player.character = nil
    playerCharacter.destroy()
end

function Commands.become_mortal(self)
    local position = self.player.position
    if self.player.character == nil then
        game.player.create_character()
        self.player.teleport(position)
    end
end

function Commands.cli_ext(self)
    local availableCommands = ""
    for _, v in pairs(self.util.getCommands()) do
        availableCommands = availableCommands.." /"..v
    end
    self.player.print(availableCommands);
end

function Commands.destroy_selected(self)
    if self.util.allowedToUse() == false then return end
    if self.player.selected ~= nil then self.player.selected.destroy() end
end

function Commands.finish_current_tech(self)
    if self.util.allowedToUse() == false then return end
    if self.player.force.current_research ~= nil then self.player.force.current_research.researched = true end
end

function Commands.freeze(self)
    if self.util.allowedToUse() == false then return end
    self.player.surface.freeze_daytime = self.util.switchBool(self.player.surface.freeze_daytime, "Freezing")
end

function Commands.give_stack(self)
    if self.util.allowedToUse() == false then return end
    local parameterCountMessage = ": item name. Example usage '/give_stack iron plate'"
    if not self.util.correctParameterCount(1, parameterCountMessage) then
        return
    end
    local name=self.util.join(self.parameters, "-")
    if game.item_prototypes[name] ~= nil then
        local stack = game.item_prototypes[name].stack_size
        self.player.insert({name=name, count=stack})
    end
end

function Commands.kill_enemies(self)
    if self.util.allowedToUse() == false then return end
    for key, entity in pairs(self.player.surface.find_entities_filtered({force="enemy"})) do
        entity.destroy()
    end
end

function Commands.lock_all_tech(self)
    if self.util.allowedToUse() == false then return end
    for _, tech in pairs(self.player.force.technologies) do
        tech.researched=false
        self.player.force.set_saved_technology_progress(tech, 0)
    end
end

function Commands.lock_tech(self)
    if self.util.allowedToUse() == false then return end
    local parameterCountMessage = ": nameOfResearch. Example usage '/lock_tech automation'"
    if not self.util.correctParameterCount(1, parameterCountMessage) then
        return
    end

    local techName = self.util.join(self.parameters, "-")

    if self.player.force.current_research ~= nil then
        if self.player.force.current_research.name == techName then self.player.force.current_research = nil end
    end
    self.player.print("Searching technology with the name: '"..techName.."' ")

    for _, tech in pairs(self.player.force.technologies) do
        if tech.name == techName then
            self.player.print("Technology with the name: '"..techName.."' found")
            selectedTech = tech
        elseif tech.prerequisites[techName] ~= nil then
            self.util.lockDependingTechs(tech)
        end
    end
    if selectedTech == nil then
        self.player.print("Technology with the name: '"..techName.."' was not found")
        return
    end
    selectedTech.researched=false
    self.player.force.set_saved_technology_progress(selectedTech, 0)
end

function Commands.pickup_dropped_items(self)
    if self.util.allowedToUse() == false then return end
    local radius=32
    if self.parameterCount > 0 then
        radius = self.parameters[1]
    end

    local groundEntities = self.player.surface.find_entities_filtered(
        {
            area={
                {self.player.position.x-radius, self.player.position.y-radius},
                {self.player.position.x+radius, self.player.position.y+radius}
            },
            name="item-on-ground"
        }
    )
    for _, entity in pairs(groundEntities) do
        entity.to_be_looted = true
        entity.teleport({self.player.position.x, self.player.position.y})
    end
end

function Commands.position(self)
    local color = self.player.color
    color.a = 0.5
    self.player.print(self.player.name..": ("..self.player.position.x .. ", " .. self.player.position.y..")", color)
end

function Commands.position_to_global_chat(self)
    local color = self.player.color
    color.a = 0.5
    game.print(self.player.name..": ("..game.player.position.x .. ", " .. game.player.position.y..")", color)
end

function Commands.position_to_player(self)
    local parameterCountMessage = ": playerName, Example usage: /position_to_player "..self.player.name
    if not self.util.correctParameterCount(1, parameterCountMessage) then
        return
    end

    local destinationPlayer = self.util.getPlayerIndexFromName(self.parameters[1])
    if destinationPlayer == nil then
        return
    else
        destinationPlayer = game.players[destinationPlayer]
    end

    local color = self.player.color
    color.a = 0.5
    destinationPlayer.print(self.player.name..": ("..game.player.position.x .. ", " .. game.player.position.y..")", color)
end

function Commands.save(self)
    if self.parameterCount > 0 then
        local savename = self.util.join(self.parameters, " ")
        game.print("saving as: "..savename)
        game.server_save(savename)
    else
        game.print("saving")
        game.server_save();
    end
end

function Commands.set_crafting_speed(self)
    if self.util.allowedToUse() == false then return end
    local player = self.player
    if self.parameterCount > 1 then
        local destinationPlayer = self.util.getPlayerIndexFromName(self.parameters[2])
        if destinationPlayer == nil then
            return
        else
            player = game.players[destinationPlayer]
        end
    elseif not self.util.correctParameterCount(1, ": modifier, Example usage: /set_crafting_speed 5") then
        return
    end
    player.character_crafting_speed_modifier = self.parameters[1]

end

function Commands.set_mining_speed(self)
    if self.util.allowedToUse() == false then return end
    local player = self.player
    if self.parameterCount > 1 then
        local destinationPlayer = self.util.getPlayerIndexFromName(self.parameters[2])
        if destinationPlayer == nil then
            return
        else
            player = game.players[destinationPlayer]
        end
    elseif not self.util.correctParameterCount(1, ": modifier, Example usage: /set_mining_speed 5") then
        return
    end

    player.character_mining_speed_modifier = self.parameters[1]
end

function Commands.set_running_speed(self)
    if self.util.allowedToUse() == false then return end
    local player = self.player
    if self.parameterCount > 1 then
        local destinationPlayer = self.util.getPlayerIndexFromName(self.parameters[2])
        if destinationPlayer == nil then
            return
        else
            player = game.players[destinationPlayer]
        end
    elseif not self.util.correctParameterCount(1, ": modifier, Example usage: /set_running_speed 5") then
        return
    end

    player.character_running_speed_modifier = self.parameters[1]
end

function Commands.speed(self)
    if self.util.allowedToUse() == false then return end
    if self.util.correctParameterCount(1) == false then
        return
    end
    local speed = tonumber(self.parameters[1])
    if speed < 1 then
        self.player.print("Game can not run slower than 1% speed")
        speed= 1
    elseif speed > 10000 then
        self.player.print("Game should not go faster then 10.000% speed. It can severly harm the performance of the game after that")
        speed = 10000
    end
    speed = speed/100
    game.speed=speed
end

function Commands.teleport_to(self)
    if self.util.allowedToUse() == false then return end
    local parameterCountMessage = ": x and y. Example usage '/teleport_to 0 0'"
    if not self.util.correctParameterCount(1, parameterCountMessage) then
        return
    end
    local x, y = tonumber(self.parameters[1]), tonumber(self.parameters[2])
    self.player.teleport(self.util.makeValidTeleportLocation({x=x,y=y}))
end

function Commands.teleport_to_player(self)
    if self.util.allowedToUse() == false then return end
    local destinationPlayer = self.util.getPlayerIndexFromName(self.parameters[1])
    if destinationPlayer == nil then
        return
    else
        destinationPlayer = game.players[destinationPlayer]
    end
    local destinationPosition = destinationPlayer.position
    self.player.teleport(self.util.makeValidTeleportLocation(destinationPosition))
end

function Commands.toggle_cheat(self)
    if self.util.allowedToUse() == false then return end
    self.player.cheat_mode = self.util.switchBool(self.player.cheat_mode, "Cheat mode is now")
end

function Commands.toggle_expansion(self)
    if self.util.allowedToUse() == false then return end
    game.map_settings.enemy_expansion.enabled = self.util.switchBool(game.map_settings.enemy_expansion.enabled, "Enemy expansion is now")
end

function Commands.toggle_night(self)
    if self.util.allowedToUse() == false then return end
    self.player.surface.always_day = self.util.switchBool(self.player.surface.always_day, "Turning always_day")
end

function Commands.toggle_peace(self)
    if self.util.allowedToUse() == false then return end
    self.player.surface.peaceful_mode = self.util.switchBool(self.player.surface.peaceful_mode, "Peace is now")
end

function Commands.unlock_all_tech(self)
    if self.util.allowedToUse() == false then return end
    self.player.force.research_all_technologies()
end

function Commands.unlock_tech(self)
    if self.util.allowedToUse() == false then return end
    local parameterCountMessage = ": nameOfResearch. Example usage '/unlock_tech automation'"
    if not self.util.correctParameterCount(1, parameterCountMessage) then
        return
    end

    local techName = self.util.join(self.parameters, "-")
    self.player.print("Searching technology with the name: '"..techName.."' ")
    for _, tech in pairs(self.player.force.technologies) do
        if tech.name == techName then
            self.player.print("Technology with the name: '"..techName.."' found")
            selectedTech = tech
        end
    end
    if selectedTech == nil then
        self.player.print("Technology with the name: '"..techName.."' was not found")
        return
    end
    self.util.unlockDependingTechs(selectedTech)
end

function Commands.zoom(self)
    if not self.util.correctParameterCount(1) then
        return
    end
    local zoom = tonumber(self.parameters[1])
    if zoom < 4 then
        self.player.print("zoom command is capped at 4, the game has a big potential to freeze with a zoom level that is smaller than that")
        zoom = 4
    elseif zoom > 1000 then
        self.player.print("zoom command is capped at 1000, a level greater than that will be unable to completely display the player character")
        zoom = 1000
    end
    zoom = zoom / 100

    self.player.zoom=zoom
end

-- Util functions

-- The entry point of every command.
function Commands.util.command(event)
    Commands.player = game.players[event.player_index]
    Commands.parameters = Commands.util.explode(event.parameter, " ")
    Commands.parameterCount = 0
    Commands.admin = Commands.player.admin

    for _, __ in pairs(Commands.parameters) do
        Commands.parameterCount = Commands.parameterCount + 1
    end
    Commands.calledCommand = event.name

    if in_table(Commands, Commands.calledCommand) then Commands[Commands.calledCommand](Commands) end
end

function Commands.util.allowedToUse()
    if (settings.startup["cli-ext-adminOnly"] == false or Commands.admin == true) then
        return true
    end
    game.print(Commands.player.name.." tried to use "..Commands.calledCommand.." but was not allowed", Commands.player.color)
    return false
end

-- Find a player by name and return its index or nil if the player was not found
function Commands.util.getPlayerIndexFromName(name)
    for k,v in pairs(game.players) do
        if v.name == name then return k end
    end
    Commands.player.print("Player '"..name.."' not found. Make sure that the name is typed correctly(case sensitive)")
    return nil
end

-- Join the elements of a table with the glue
function Commands.util.join(t, glue)
    local string = ""
    for _, v in pairs(t) do
        if string ~= "" then
            string = string..glue..v
        else
            string = string..v
        end
    end
    return string
end

-- Change true to false and false to true, and display a message to the player if specified
function Commands.util.switchBool(value, message)
    if value == true then
        value = false
        if message~=nil then Commands.player.print(message.." off") end
    else
        value = true
        if message~=nil then Commands.player.print(message.." on") end
    end
    return value
end

-- Get all of the commands available
function Commands.util.getCommands()
    local returnTable = {}
    for k, _ in pairs(Commands) do
        if in_table(Commands.util.dontUse, k) == false and type(_) == "function" then
            table.insert(returnTable, k)
        end
    end
    return returnTable
end

-- Convert a string to a table, splitting the string at the delimiter
function Commands.util.explode(s, delimiter)
    if type(s) ~= "string" then return {} end
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

-- Get the help message of a command
Commands.util.help = require "help"

-- Check if the parameter count is the same or more as count. If not display a message
function Commands.util.correctParameterCount(count, message)
    if message == nil then
        message = ""
    end

    if Commands.parameterCount >= count then
        return true
    end
    local argumentsText = count == 1 and " argument" or " arguments"
    Commands.player.print(Commands.calledCommand.." requires "..count..argumentsText..message)
    return false
end

-- Lock the techs that depend on the given tech
function Commands.util.lockDependingTechs(tech)
    if Commands.player.force.current_research ~= nil then
        if Commands.player.force.current_research.name == tech.name then Commands.player.force.current_research = nil end
    end
    for _, t in pairs(Commands.player.force.technologies) do
        if t.prerequisites[tech.name] ~= nil then
            Commands.util.lockDependingTechs(t)
        end
    end
    tech.researched=false
    Commands.player.force.set_saved_technology_progress(tech, 0)
end

-- Unlock the techs that the given tech depends on
function Commands.util.unlockDependingTechs(tech)
    for _, t in pairs(tech.prerequisites) do
        Commands.util.unlockDependingTechs(t)
    end
    tech.researched=true
end

function Commands.util.makeValidTeleportLocation(position)
    if Commands.player.surface.can_place_entity({name="player", position=position}) then
        return position
    else
        if Commands.player.surface.can_place_entity({name="player", position={position.x-1, position.y}}) then
            return {position.x-2, position.y} -- left side of position
        elseif Commands.player.surface.can_place_entity({name="player", position={position.x+1, position.y}}) then
            return {position.x+1, position.y} -- above position
        elseif Commands.player.surface.can_place_entity({name="player", position={position.x-1, position.y+1}}) then
            return {position.x-1, position.y+1} -- above position
        elseif Commands.player.surface.can_place_entity({name="player", position={position.x-1, position.y-1}}) then
            return {position.x-1, position.y-1} -- below position
        else
            return {position.x, position.y} -- same space as position
        end
    end
end

function Commands.resetQol(self)
    for _, tech in pairs(self.player.force.technologies) do
        local startPosition = tech.name:find("qol")
        if startPosition == 1 and tech.researched == true then
            if not tech.name:find("toolbelt") then
                tech.researched=false
                self.player.force.set_saved_technology_progress(tech, 0)
                tech.researched=true
            end
        end
    end
    self.pickup_dropped_items(self)
end


return Commands

