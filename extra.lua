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

---- More of a developer command than anything
--function Commands.print_parameters(self)
--    self.player.print(serpent.line(self.parameters))
--end
