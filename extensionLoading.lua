function loadExtensions()
    local extensions = {
        dev_ext = "console-extended-dev"
    }

    for k, v in pairs(extensions) do
        if game.active_mods[v] then
            extensions[k] = require "__"..v.."__/mod_info"
        end
    end
    return extensions
end
