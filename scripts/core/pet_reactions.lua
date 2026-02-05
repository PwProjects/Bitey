local PET_REACTIONS = require("constants.pet_reactions")

local pet_reactions = {}

function pet_reactions.trigger(player_index, entry, food)
    local reaction = PET_REACTIONS[food]
    if not reaction then return end

    if reaction.emotes then
        for _, e in ipairs(reaction.emotes) do
            pet_state.force_emote(player_index, entry, e.name, e.interrupt)
        end
    end
end

return pet_reactions
