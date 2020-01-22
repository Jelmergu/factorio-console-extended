require "helpers"
mod_info = {
    print_name = "Console Extended",
    porcelain_name = "console-extended",
    extensions = {}
}

C = require "Commands"

local cli_remote = {}

function cli_remote.add_command(name, func, help)
    log("add command called")
    C[name] = func
    C.util.help.helpTexts[name] = help

    if in_table(commands.commands, name) or in_table(commands.game_commands, name) then
        log("Command: "..name.." already exists")
    else
        commands.add_command(name, help, C.util.command)
    end
end

remote.add_interface("console-extended", cli_remote)

for _, v in pairs(C.util:getCommands()) do
    if in_table(commands.commands, name) or in_table(commands.game_commands, name) then
        log("Command: "..name.." already exists")
    else
        commands.add_command(v, C.util.help.getHelp(v), C.util.command)
    end
end
