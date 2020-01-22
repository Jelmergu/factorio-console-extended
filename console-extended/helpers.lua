function in_table(table, item)
    for k,v in pairs(table) do
        if v == item or k == item then
            return true
        end
    end
    return false
end