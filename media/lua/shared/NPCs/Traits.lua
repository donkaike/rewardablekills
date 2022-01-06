require('NPCs/MainCreationMethods');

local function initTraits()
    local noobboon = TraitFactory.addTrait("noobboon", getText("UI_trait_noobboon"), 0, getText("UI_trait_noobboondesc"), false, false);
    local normalboon = TraitFactory.addTrait("normalboon", getText("UI_trait_normalboon"), 0, getText("UI_trait_normalboondesc"), false, false);
    local veteranboon = TraitFactory.addTrait("veteranboon", getText("UI_trait_veteranboon"), 0, getText("UI_trait_veteranboondesc"), false, false);
end

Events.OnGameBoot.Add(initTraits);