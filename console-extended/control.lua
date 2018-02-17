C = require "Commands"

function in_table(table, item)
    for _,v in pairs(table) do
        if v == item then
            return true
        end
    end
    return false
end


for _, v in pairs(C.util:getCommands()) do
    commands.add_command(v, C.util.help(v), C.util.command)
end
