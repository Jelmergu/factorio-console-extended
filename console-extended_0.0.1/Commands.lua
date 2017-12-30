local Commands = {}
Commands.util = {}
Commands.util.dontUse = {}

function Commands.position()
    local color = Commands.player.color
    color.a = 0.5
    Commands.player.print(Commands.player.name..": ("..game.player.position.x .. ", " .. game.player.position.y..")", color)
end

function Commands.positionToGlobalChat()
    local color = Commands.player.color
    color.a = 0.5
    game.print(Commands.player.name..": ("..game.player.position.x .. ", " .. game.player.position.y..")", color)
end

function Commands.cli_ext()
    local availableCommands = ""
    for _, v in pairs(Commands.util.getCommands()) do
        availableCommands = availableCommands.." /"..v
    end
    Commands.player.print(availableCommands);
end

function Commands.finish_current_tech(self)
    if self.player.force.current_research ~= nil then self.player.force.current_research.researched = true end
end

function Commands.destroy_selected()
    if Commands.player.selected ~= nil then Commands.player.selected.destroy() end
end

function Commands.teleport_to(self)
    if self.parameterCount < 2 then
        game.print("teleport_to requires 2 arguments: x and y. Example usage '/teleport_to 0 0'")
        return
    end
    local x, y = tonumber(self.parameters[1]), tonumber(self.parameters[2])
    self.player.teleport({x,y})
end

function Commands.teleport_to_player()
    local destinationPlayer = Commands.util.getPlayerIndexFromName(Commands.parameters[1])
    if destinationPlayer == nil then
        game.print("Player '"..Commands.parameters[1].."' not found")
        return
    else
        destinationPlayer = game.players[destinationPlayer]
    end
    local destinationPosition = destinationPlayer.position
    destinationPosition.x = destinationPosition.x+1
    Commands.player.teleport(destinationPosition)
end

-- More of a developer command than anything
function Commands.print_parameters()
    game.print(serpent.line(Commands.parameters))
end

function Commands.unlock_all_tech()
    Commands.player.force.research_all_technologies()
end

function Commands.freeze()
    Commands.player.surface.freeze_daytime = Commands.util.switchBool(Commands.player.surface.freeze_daytime, "Freezing")
end

function Commands.toggle_night()
   Commands.player.surface.always_day = Commands.util.switchBool(Commands.player.surface.always_day, "Turning always_day")
end

function Commands.toggle_peace()
    Commands.player.surface.peaceful_mode = Commands.util.switchBool(Commands.player.surface.peaceful_mode, "Peace is now")
end

function Commands.toggle_cheat()
    Commands.player.surface.peaceful_mode = Commands.util.switchBool(Commands.player.cheat_mode, "Cheat mode is now")
end

function Commands.speed()
    local speed = tonumber(Commands.parameters[1])
    if speed < 1 then
        game.print("Game can not run slower than 1% speed")
        speed= 1
    elseif speed > 10000 then
        game.print("Game should not go faster then 10.000% speed. It can severly harm the performance of the game after that")
        speed = 10000
    end
    speed = speed/100
    game.speed=speed
end

function Commands.lock_all_tech()
    for _, tech in pairs(Commands.player.force.technologies) do
        tech.researched=false
        Commands.player.force.set_saved_technology_progress(tech, 0)
    end
end

function Commands.zoom()
    local zoom = tonumber(Commands.parameters[1])
    if zoom < 4 then
        game.print("zoom command is capped at 4, the game has a big potential to freeze with a zoom level that is smaller than that")
        zoom = 4
    elseif zoom > 1000 then
        game.print("zoom command is capped at 1000, a level greater than that will be unable to completely display the player character")
        zoom = 1000
    end
    zoom = zoom / 100

    Commands.player.zoom=zoom
end


-- Util functions

function Commands.util.command(event)
    Commands.player = game.players[event.player_index]
    Commands.parameters = Commands.util.explode(event.parameter, " ")
    Commands.parameterCount = 0
    for _, __ in pairs(Commands.parameters) do
        Commands.parameterCount = Commands.parameterCount + 1
    end
    Commands.calledCommand = event.name

    if in_table(Commands, Commands.calledCommand) then Commands[Commands.calledCommand](Commands) end
end

function Commands.util.getPlayerIndexFromName(name)

    for k,v in pairs(game.players) do
        if v.name == name then return k end
    end
    return nil
end

function Commands.util.switchBool(value, message)
    if value == true then
        value = false
        if message~=nil then game.print(message.." off") end
    else
        value = true
        if message~=nil then game.print(message.." on") end
    end
    return value
end

function Commands.util.getCommands()
    local returnTable = {}
    for k, _ in pairs(Commands) do
        if in_table(Commands.util.dontUse, k) == false and type(_) == "function" then
            table.insert(returnTable, k)
        end
    end
    return returnTable
end

function Commands.util.explode(s, delimiter)
    if type(s) ~= "string" then return {} end
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function Commands.util.help()
    return "it is al a test"
end






return Commands

