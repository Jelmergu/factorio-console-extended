mod_info = {
    print_name = "Console Extended",
    porcelain_name = "console-extended"
}

C = require "Commands"

function in_table(table, item)
    for k,v in pairs(table) do
        if v == item or k == item then
            return true
        end
    end
    return false
end

for _, v in pairs(C.util:getCommands()) do
    if in_table(commands.commands, v) or in_table(commands.game_commands, v) then
        log("Command: "..v.." already exists")
    else
        commands.add_command(v, C.util.help(v), C.util.command)
    end

end
