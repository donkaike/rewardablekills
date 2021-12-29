require('NPCs/MainCreationMethods');
require("Items/Distributions");
require("Items/ProceduralDistributions");

--[[
Changelog Notes:
Martial Artist has lower base damage, but now also factors in the average of your strength and fitness in addition to Small Blunt skill for scaling damage.
    This rewards putting skill points into Strength, Fitness, and Small Blunt by making later levels feels more powerful, and lower levels less powerful so that
    you feel the development of your player's strength as you level.
Martial Artist wasn't giving a skill bonus.
Fearful now properly creates world sound event instead of forcing the player to yell "Hey you!".
    Fearful now also has tiers of screaming depending on the severity of your panic. You scream louder the more panicked you are.
Alcoholic trait now requires a minimum of "tipsy" moodle to consider the player drinking alcohol.
Attempt to fix TargetInvocationException in Grave Digger.
Migrate old SuburbsDistributions to ProceduralDistributions
Reduce skill requirements for several medical recipes.
--]]

--Global Variables
skipxpadd = false;
suspendevasive = false;
internalTick = 0;

local function tableContains(t, e)
    for _, value in pairs(t) do
        if value == e then
            return true
        end
    end
    return false
end
local function istable(t)
    local type = type(t)
    return type == 'table'
end
local function tablelength(T)
    local count = 0
    if istable(T) == true then
        for _ in pairs(T) do
            count = count + 1
        end
    else
        count = 1
    end
    return count
end

local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function addXPNoMultiplier(_player, _perk, _amount)
    local perk = _perk;
    local amount = _amount;
    local player = _player;
    skipxpadd = true;
    player:getXp():AddXPNoMultiplier(perk, amount);
end

local function initToadTraits()

    -- pro traits
    local bluntperk = TraitFactory.addTrait("problunt", getText("UI_trait_problunt"), 5, getText("UI_trait_probluntdesc"), false, false);
    bluntperk:addXPBoost(Perks.SmallBlunt, 1);
    bluntperk:addXPBoost(Perks.Blunt, 1);
    local bladeperk = TraitFactory.addTrait("problade", getText("UI_trait_problade"), 5, getText("UI_trait_probladedesc"), false, false);
    bladeperk:addXPBoost(Perks.SmallBlade, 1);
    bladeperk:addXPBoost(Perks.LongBlade, 1);
    bladeperk:addXPBoost(Perks.Axe, 1);
    local gunperk = TraitFactory.addTrait("progun", getText("UI_trait_progun"), 5, getText("UI_trait_progundesc"), false, false);
    gunperk:addXPBoost(Perks.Aiming, 1);
    gunperk:addXPBoost(Perks.Reloading, 1);
    local spearperk = TraitFactory.addTrait("prospear", getText("UI_trait_prospear"), 5, getText("UI_trait_prospeardesc"), false, false);
    spearperk:addXPBoost(Perks.Spear, 2);

    -- normal traits
    local gunspecialist = TraitFactory.addTrait("gunspecialist", getText("UI_trait_gunspecialist"), 8, getText("UI_trait_gunspecialistdesc"), false, false);
    gunspecialist:addXPBoost(Perks.Aiming, 2);
    gunspecialist:addXPBoost(Perks.Reloading, 2);
    local swift = TraitFactory.addTrait("swift", getText("UI_trait_swift"), 2, getText("UI_trait_swiftdesc"), false, false);
    swift:addXPBoost(Perks.Lightfoot, 1);
    local olympian = TraitFactory.addTrait("olympian", getText("UI_trait_olympian"), 6, getText("UI_trait_olympiandesc"), false, false);
    olympian:addXPBoost(Perks.Sprinting, 1);
    olympian:addXPBoost(Perks.Fitness, 1);
    local flexible = TraitFactory.addTrait("flexible", getText("UI_trait_flexible"), 3, getText("UI_trait_flexibledesc"), false, false);
    flexible:addXPBoost(Perks.Nimble, 1);
    local grunt = TraitFactory.addTrait("grunt", getText("UI_trait_grunt"), 4, getText("UI_trait_gruntdesc"), false, false);
    grunt:addXPBoost(Perks.Woodwork, 1);
    grunt:addXPBoost(Perks.SmallBlunt, 1);
    local quiet = TraitFactory.addTrait("quiet", getText("UI_trait_quiet"), 3, getText("UI_trait_quietdesc"), false, false);
    quiet:addXPBoost(Perks.Sneak, 1);
    local tinkerer = TraitFactory.addTrait("tinkerer", getText("UI_trait_tinkerer"), 6, getText("UI_trait_tinkererdesc"), false, false);
    tinkerer:addXPBoost(Perks.Mechanics, 1);
    tinkerer:addXPBoost(Perks.Tailoring, 1);
    local scrapper = TraitFactory.addTrait("scrapper", getText("UI_trait_scrapper"), 4, getText("UI_trait_scrapperdesc"), false, false);
    scrapper:addXPBoost(Perks.MetalWelding, 1);
    scrapper:addXPBoost(Perks.Maintenance, 1);
    scrapper:getFreeRecipes():add("Make Metal Pipe");
    scrapper:getFreeRecipes():add("Make Metal Sheet");
    local bladetwirl = TraitFactory.addTrait("bladetwirl", getText("UI_trait_bladetwirl"), 5, getText("UI_trait_bladetwirldesc"), false, false);
    bladetwirl:addXPBoost(Perks.LongBlade, 1);
    bladetwirl:addXPBoost(Perks.SmallBlade, 1);
    local blunttwirl = TraitFactory.addTrait("blunttwirl", getText("UI_trait_blunttwirl"), 5, getText("UI_trait_blunttwirldesc"), false, false);
    blunttwirl:addXPBoost(Perks.SmallBlunt, 1);
    blunttwirl:addXPBoost(Perks.Blunt, 1);
    local evasive = TraitFactory.addTrait("evasive", getText("UI_trait_evasive"), 8, getText("UI_trait_evasivedesc"), false, false);
    evasive:addXPBoost(Perks.Nimble, 1);
    local thickblood = TraitFactory.addTrait("thickblood", getText("UI_trait_thickblood"), 2, getText("UI_trait_thickblooddesc"), false, false);
    local expertdriver = TraitFactory.addTrait("expertdriver", getText("UI_trait_expertdriver"), 5, getText("UI_trait_expertdriverdesc"), false, false);
    local packmule = TraitFactory.addTrait("packmule", getText("UI_trait_packmule"), 7, getText("UI_trait_packmuledesc"), false, false);
    local graverobber = TraitFactory.addTrait("graverobber", getText("UI_trait_graverobber"), 7, getText("UI_trait_graverobberdesc"), false, false);
    local gymgoerA = TraitFactory.addTrait("gymgoerA", getText("UI_trait_gymgoerA"), 4, getText("UI_trait_gymgoerdescA"), false, false);
    gymgoerA:addXPBoost(Perks.Strength, 1);
    local gymgoerP = TraitFactory.addTrait("gymgoerP", getText("UI_trait_gymgoerP"), 4, getText("UI_trait_gymgoerdescP"), false, false);
    gymgoerP:addXPBoost(Perks.Fitness, 1);


    --===========--
    --Bad Traits--
    --===========--
    local packmouse = TraitFactory.addTrait("packmouse", getText("UI_trait_packmouse"), -7, getText("UI_trait_packmousedesc"), false, false);
    local injured = TraitFactory.addTrait("injured", getText("UI_trait_injured"), -4, getText("UI_trait_injureddesc"), false, false);
    local broke = TraitFactory.addTrait("broke", getText("UI_trait_broke"), -7, getText("UI_trait_brokedesc"), false, false);
    local butterfingers = TraitFactory.addTrait("butterfingers", getText("UI_trait_butterfingers"), -8, getText("UI_trait_butterfingersdesc"), false, false);
    local depressive = TraitFactory.addTrait("depressive", getText("UI_trait_depressive"), -4, getText("UI_trait_depressivedesc"), false, false);
    local selfdestructive = TraitFactory.addTrait("selfdestructive", getText("UI_trait_selfdestructive"), -4, getText("UI_trait_selfdestructivedesc"), false, false);
    local badteeth = TraitFactory.addTrait("badteeth", getText("UI_trait_badteeth"), -2, getText("UI_trait_badteethdesc"), false, false);
    local poordriver = TraitFactory.addTrait("poordriver", getText("UI_trait_poordriver"), -5, getText("UI_trait_poordriverdesc"), false, false);
    local anemic = TraitFactory.addTrait("anemic", getText("UI_trait_anemic"), -2, getText("UI_trait_anemicdesc"), false, false);
    local fearful = TraitFactory.addTrait("fearful", getText("UI_trait_fearful"), -7, getText("UI_trait_fearfuldesc"), false, false);


    --===========--
    --Exclusives--
    --===========--
    TraitFactory.setMutualExclusive("quiet", "Clumsy");
    TraitFactory.setMutualExclusive("flexible", "Obese");
    TraitFactory.setMutualExclusive("olympian", "Unfit");
    TraitFactory.setMutualExclusive("olympian", "Jogger");
    TraitFactory.setMutualExclusive("thickblood", "anemic");
    TraitFactory.setMutualExclusive("expertdriver", "poordriver");
    TraitFactory.setMutualExclusive("packmule", "packmouse");
    TraitFactory.setMutualExclusive("fearful", "Desensitized");
    TraitFactory.setMutualExclusive("fearful", "Brave");
end

local function initToadTraitsPerks(_player)
    local player = _player;
    local damage = 40;
    local bandagestrength = 5;
    local splintstrength = 0.5;
    local fracturetime = 40;
    local scratchtimemod = 15;
    local bleedtimemod = 5;
    player:getModData().bToadTraitDepressed = false;

    if player:HasTrait("Lucky") then
        damage = damage - 10;
        bandagestrength = bandagestrength + 3;
        fracturetime = fracturetime - 10;
        splintstrength = splintstrength + 0.1;
        scratchtimemod = scratchtimemod - 5;
        bleedtimemod = bleedtimemod - 2;
    end
    if player:HasTrait("Unlucky") then
        damage = damage + 10;
        bandagestrength = bandagestrength - 2;
        fracturetime = fracturetime + 5;
        splintstrength = splintstrength - 0.1;
        scratchtimemod = scratchtimemod + 5;
        bleedtimemod = bleedtimemod + 2;
    end

    if player:HasTrait("injured") then
        suspendevasive = true;
        --print("Beginning Injury.");
        local bodydamage = player:getBodyDamage();
        --how much injuries will beggin from 3 to 5
        local itterations = ZombRand(2, 4) + 1;
        for i = 0, itterations do
            local randompart = ZombRand(0, 16);
            local b = bodydamage:getBodyPart(BodyPartType.FromIndex(randompart));
            --local injury = ZombRand(0, 5);
            local skip = false;
            if b:HasInjury() then
                itterations = itterations - 1;
                skip = true;
            end
            if skip == false then
                --this way always will have a worst wound in first
                if i == 0 then
                    b:AddDamage(damage);
                    b:setBurned();
                    b:setBandaged(true, bandagestrength, true, "Base.Bandage");
                end
                if i >= 1 and i <= 2 then
                    b:AddDamage(damage);
                    b:setDeepWounded(true);
                    b:setStitched(true);
                    b:setBandaged(true, bandagestrength, true, "Base.Bandage");
                end
                if i == 3 then
                    b:AddDamage(damage);
                    b:setCut(true, true);
                    b:setBandaged(true, bandagestrength, true, "Base.Bandage");
                end
                if i > 3 then
                    b:AddDamage(damage);
                    b:setScratched(true, true);
                    b:setBandaged(true, bandagestrength, true, "Base.Bandage");
                end
            end
        end
        bodydamage:setInfected(false);
    end
    if player:HasTrait("broke") then
        --print("Broke Leg.");
        suspendevasive = true;
        local bodydamage = player:getBodyDamage();
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):AddDamage(damage);
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setFractureTime(fracturetime);
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setSplint(true, splintstrength);
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setSplintItem("Base.Splint");
        bodydamage:getBodyPart(BodyPartType.LowerLeg_R):setBandaged(true, bandagestrength, true, "Base.Bandage");
        bodydamage:setInfected(false);
    end
    player:getModData().ToadTraitBodyDamage = nil;
    suspendevasive = false;
    if player:HasTrait("packmule") then
        player:setMaxWeight(25);
        player:setMaxWeightBase(11);

    end
    if player:HasTrait("packmouse") then
        player:setMaxWeight(20);
        player:setMaxWeightBase(9);
    end
end

local function ToadTraitEvasive(_player, _playerdata)
    local player = _player;
    local playerdata = _playerdata;
    if player:HasTrait("evasive") then
        local basechance = 15;
        local bMarkForUpdate = false;
        local bodydamage = player:getBodyDamage();
        local modbodydamage = playerdata.ToadTraitBodyDamage;
        if bodydamage:getNumPartsScratched() == nil then
            return
        end ;
        if player:HasTrait("Lucky") then
            basechance = basechance + 3;
        end
        if player:HasTrait("Unlucky") then
            basechance = basechance - 3;
        end
        if modbodydamage == nil then
            modbodydamage = {};
            --Initialize the Body Part Reference Table
            print("Initializing Body Damage");
            for i = 0, bodydamage:getBodyParts():size() - 1 do
                local b = bodydamage:getBodyParts():get(i);
                local temptable = { b:getType(), b:scratched(), b:bitten() };
                table.insert(modbodydamage, temptable);
            end
            playerdata.ToadTraitBodyDamage = modbodydamage;
            print("Body Damage Initialized");
        else
            for n = 0, bodydamage:getBodyParts():size() - 1 do
                local i = bodydamage:getBodyParts():get(n);
                for _, b in pairs(modbodydamage) do
                    if i:getType() == b[1] then
                        if i:scratched() == false and b[2] == true or i:bitten() == false and b[3] == true then
                            bMarkForUpdate = true;
                        end
                        if i:scratched() == true and b[2] == false then
                            print("Scratch Detected On: " .. tostring(i:getType()));
                            if ZombRand(100) <= basechance then
                                print("Attack Dodged!");
                                i:RestoreToFullHealth();
                                i:setScratched(false);
                                i:SetInfected(false);
                                player:Say("*Dodged*");
                            else
                                bMarkForUpdate = true;
                            end

                        elseif i:bitten() == true and b[3] == false then
                            print("Bite Detected On: " .. tostring(i:getType()));
                            if ZombRand(100) <= basechance then
                                print("Attack Dodged!");
                                i:RestoreToFullHealth();
                                i:SetBitten(false, false);
                                i:SetInfected(false);
                                player:Say("*Dodged*");
                            else
                                bMarkForUpdate = true;
                            end
                        end
                    end
                end
            end
        end
        if bMarkForUpdate == true then
            modbodydamage = {};
            --Initialize the Body Part Reference Table
            for i = 0, bodydamage:getBodyParts():size() - 1 do
                local b = bodydamage:getBodyParts():get(i);
                local temptable = { b:getType(), b:scratched(), b:bitten() };
                table.insert(modbodydamage, temptable);
            end
            playerdata.ToadTraitBodyDamage = modbodydamage;
        end
    end
end

local function ToadTraitButter()
    local player = getPlayer();
    if player:HasTrait("butterfingers") and player:isPlayerMoving() then
        local basechance = 5;
        if player:HasTrait("AllThumbs") then
            basechance = basechance + 5;
        end
        if player:HasTrait("Dextrous") then
            basechance = basechance - 2.5;
        end
        if player:HasTrait("Lucky") then
            basechance = basechance - 2.5;
        end
        if player:HasTrait("packmule") then
            basechance = basechance - 2.5;
        end
        if player:HasTrait("packmouse") then
            basechance = basechance + 5;
        end
        if player:HasTrait("Unlucky") then
            basechance = basechance + 5;
        end
        local weight = player:getInventoryWeight();
        local chancemod = 0;
        if weight > 0 then
            chancemod = math.floor(weight / 5);
        end
        local chance = (basechance + chancemod);
        if chance >= ZombRand(1000) then
            player:dropHandItems();
        end
    end
end

local function ToadTraitDepressive()
    local player = getPlayer();
    if player:HasTrait("depressive") then
        local basechance = 5;
        if player:HasTrait("Lucky") then
            basechance = basechance - 2;
        end
        if player:HasTrait("Unlucky") then
            basechance = basechance + 2;
        end
        if ZombRand(100) <= basechance then
            if player:getModData().bToadTraitDepressed == false then
                print("Player is experiencing depression.");
                player:getBodyDamage():setUnhappynessLevel((player:getBodyDamage():getUnhappynessLevel() + 25));
                player:getModData().bToadTraitDepressed = true;
            end
        end
    end
end

local function CheckDepress(_player, _playerdata)
    local player = _player;
    local playerdata = _playerdata;
    local depressed = playerdata.bToadTraitDepressed;
    if depressed == nil then
        playerdata.bToadTraitDepressed = false;
    else
        if depressed == true then
            if player:getBodyDamage():getUnhappynessLevel() < 25 then
                playerdata.bToadTraitDepressed = false;
            else
                player:getBodyDamage():setUnhappynessLevel(player:getBodyDamage():getUnhappynessLevel() + 0.0005);
            end
        end
    end
end

local function CheckSelfHarm(_player)
    local player = _player;
    local modifier = 3;
    if player:HasTrait("depressive") then
        modifier = modifier - 1;
    end
    if player:HasTrait("selfdestructive") then
        if player:getBodyDamage():getUnhappynessLevel() >= 25 then
            if player:getBodyDamage():getOverallBodyHealth() >= (100 - player:getBodyDamage():getUnhappynessLevel() / modifier) then
                for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
                    local b = player:getBodyDamage():getBodyParts():get(i);
                    b:AddDamage(0.005);
                end
            end
        end
    end
end


local function badteethtrait(_player)
    local player = _player;
    if player:HasTrait("badteeth") then
        if player:getBodyDamage():getHealthFromFoodTimer() > 1000 then
            player:getStats():setPain(player:getBodyDamage():getHealthFromFoodTimer() / 90);
        end
    end
end

local function gimp()
    local player = getPlayer();
    local playerdata = player:getModData();
    local modifier = 0.85;
    if player:HasTrait("gimp") and player:isLocalPlayer() then
        if playerdata.fToadTraitsPlayerX ~= nil and playerdata.fToadTraitsPlayerY ~= nil then
            local oldx = playerdata.fToadTraitsPlayerX;
            local oldy = playerdata.fToadTraitsPlayerY;
            local newx = player:getX();
            local newy = player:getY();
            local xdif = (newx - oldx);
            local ydif = (newy - oldy);
            if xdif > 5 or xdif < -5 or ydif > 5 or ydif < -5 then
                playerdata.fToadTraitsPlayerX = player:getX();
                playerdata.fToadTraitsPlayerY = player:getY();

                return
            end
            player:setX((oldx + xdif * modifier));
            player:setY((oldy + ydif * modifier));
        end
        playerdata.fToadTraitsPlayerX = player:getX();
        playerdata.fToadTraitsPlayerY = player:getY();
    end
end

local function fast()
    local player = getPlayer();
    local playerdata = player:getModData();
    local vector = player:getPlayerMoveDir();
    local length = vector:getLength();
    local modifier = 2.15;
    if player:HasTrait("fast") and player:isLocalPlayer() then
        if playerdata.fToadTraitsPlayerX ~= nil and playerdata.fToadTraitsPlayerY ~= nil then
            local oldx = playerdata.fToadTraitsPlayerX;
            local oldy = playerdata.fToadTraitsPlayerY;
            local newx = player:getX();
            local newy = player:getY();
            local xdif = (newx - oldx);
            local ydif = (newy - oldy);
            if xdif > 5 or xdif < -5 or ydif > 5 or ydif < -5 then
                playerdata.fToadTraitsPlayerX = player:getX();
                playerdata.fToadTraitsPlayerY = player:getY();

                return
            end
            if xdif ~= 0 or xdif ~= 0 or ydif ~= 0 or ydif ~= 0 then
                player:setX((oldx + xdif * modifier));
                player:setY((oldy + ydif * modifier));
                playerdata.fToadTraitsPlayerX = player:getX();
                playerdata.fToadTraitsPlayerY = player:getY();
            end
        else
            playerdata.fToadTraitsPlayerX = player:getX();
            playerdata.fToadTraitsPlayerY = player:getY();
        end
    end

end
local function anemic(_player)
    local player = _player;
    if player:HasTrait("anemic") then
        local bodydamage = player:getBodyDamage();
        local bleeding = bodydamage:getNumPartsBleeding();
        if bleeding > 0 then
            for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
                local b = player:getBodyDamage():getBodyParts():get(i);
                if b:bleeding() and b:IsBleedingStemmed() == false then
                    b:ReduceHealth(0.10);
                end
            end
        end

    end
end
local function thickblood(_player)
    local player = _player;
    if player:HasTrait("thickblood") then
        local bodydamage = player:getBodyDamage();
        local bleeding = bodydamage:getNumPartsBleeding();
        if bleeding > 0 then
            for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
                local b = player:getBodyDamage():getBodyParts():get(i);
                if b:bleeding() and b:IsBleedingStemmed() == false then
                    b:AddHealth(0.10);
                end
            end
        end

    end
end

local function vehicleCheck(_player)
    local player = _player;
    if player:isDriving() == true then
        local vehicle = player:getVehicle();
        local vmd = vehicle:getModData();
        if vmd.bUpdated == nil then
            vmd.fBrakingForce = vehicle:getBrakingForce();
            vmd.fMaxSpeed = vehicle:getMaxSpeed();
            vmd.iEngineQuality = vehicle:getEngineQuality();
            vmd.iEngineLoudness = vehicle:getEngineLoudness()
            vmd.iEnginePower = vehicle:getEnginePower();
            vmd.sState = "Normal";
            vmd.bUpdated = true;
        else
            if player:HasTrait("expertdriver") and vmd.sState ~= "ExpertDriver" then
                vehicle:setBrakingForce(vmd.fBrakingForce * 2);
                vehicle:setEngineFeature(vmd.iEngineQuality * 1.5, vmd.iEngineLoudness * 0.75, vmd.iEnginePower * 1.5);
                vehicle:setMaxSpeed(vmd.fMaxSpeed * 1.25);
                vmd.sState = "ExpertDriver";
                print("Vehicle State: " .. vmd.sState);
                vehicle:update();
            end
            if player:HasTrait("poordriver") and vmd.sState ~= "PoorDriver" then
                vehicle:setBrakingForce(vmd.fBrakingForce * 0.5);
                vehicle:setEngineFeature(vmd.iEngineQuality * 0.75, vmd.iEngineLoudness * 1.5, vmd.iEnginePower * 0.75);
                vehicle:setMaxSpeed(vmd.fMaxSpeed * 0.75);
                vmd.sState = "PoorDriver";
                print("Vehicle State: " .. vmd.sState);
                vehicle:update();
            end
            if player:HasTrait("expertdriver") == false and player:HasTrait("poordriver") == false and vmd.sState ~= "Normal" then
                vehicle:setBrakingForce(vmd.fBrakingForce);
                vehicle:setEngineFeature(vmd.iEngineQuality, vmd.iEngineLoudness, vmd.iEnginePower);
                vehicle:setMaxSpeed(vmd.fMaxSpeed);
                vmd.sState = "Normal";
                print("Vehicle State: " .. vmd.sState);
                vehicle:update();
            end

        end

    end
end

local function checkWeight()
    local player = getPlayer();
    local strength = player:getPerkLevel(Perks.Strength);

    print(player:getMaxWeightBase());
    print(player:getMaxWeight());

    if player:HasTrait("packmule") then
        player:setMaxWeightBase(11);    
    elseif player:HasTrait("packmouse") then
        player:setMaxWeightBase(7);
    end
end

local function graveRobber(_zombie)
    local player = getPlayer();
    local zombie = _zombie;
    local chance = 5;

    if player:HasTrait("graverobber") then
        if player:HasTrait("Lucky") then
            chance = chance + 2;
        end
        if player:HasTrait("Unlucky") then
            chance = chance - 2;
        end 
        if chance <= 0 then
            chance = 1;
        end
        if ZombRand(0, 100) <= chance then
            local inv = zombie:getInventory();
            local itterations = ZombRand(1, chance + 1);
            for i = 0, itterations do
                i = i + 1;
                local roll = ZombRand(0, 100);
                print("roool " .. tostring(roll));
                if roll <= 10 then
                    local randomitem = { "Base.Apple", "Base.Avocado", "Base.Banana", "Base.BellPepper", "Base.BeerCan",
                                         "Base.BeefJerky", "Base.Bread", "Base.Broccoli", "Base.Butter", "Base.CandyPackage", "Base.TinnedBeans",
                                         "Base.CannedCarrots2", "Base.CannedChili", "Base.CannedCorn", "Base.CannedCornedBeef", "CannedMushroomSoup",
                                         "Base.CannedPeas", "Base.CannedPotato2", "Base.CannedSardines", "Base.CannedTomato2", "Base.TunaTin" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 20 then
                    local randomitem = { "Base.PillsAntiDep", "Base.AlcoholWipes", "Base.AlcoholedCottonBalls", "Base.Pills", "Base.PillsSleepingTablets",
                                         "Base.Tissue", "Base.ToiletPaper", "Base.PillsVitamins", "Base.Bandaid", "Base.Bandage", "Base.CottonBalls", "Base.Splint", "Base.AlcoholBandage",
                                         "Base.AlcoholRippedSheets", "Base.SutureNeedle", "Base.Tweezers", "Base.WildGarlicCataplasm", "Base.ComfreyCataplasm", "Base.PlantainCataplasm", "Base.Disinfectant" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 25 then
                    local randomitem = { "Base.223Box", "Base.308Box", "Base.Bullets38Box", "Base.Bullets44Box", "Base.Bullets45Box", "Base.556Box", "Base.Bullets9mmBox",
                                         "Base.ShotgunShellsBox", "Base.DoubleBarrelShotgun", "Base.Shotgun", "Base.ShotgunSawnoff", "Base.Pistol", "Base.Pistol2", "Base.Pistol3", "Base.AssaultRifle", "Base.AssaultRifle2",
                                         "Base.VarmintRifle", "Base.HuntingRifle", "Base.556Clip", "Base.M14Clip", "Base.308Clip", "Base.223Clip", "Base.44Clip", "Base.45Clip", "Base.9mmClip", "Base.Revolver_Short", "Base.Revolver_Long",
                                         "Base.Revolver" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 30 then
                    local randomitem = { "Base.Aerosolbomb", "Base.Axe", "Base.BaseballBat", "Base.SpearCrafted", "Base.Crowbar", "Base.FlameTrap", "Base.HandAxe", "Base.HuntingKnife", "Base.Katana",
                                         "Base.PipeBomb", "Base.Sledgehammer", "Base.Shovel", "Base.SmokeBomb", "Base.WoodAxe", "Base.GardenFork", "Base.WoodenLance", "Base.SpearBreadKnife",
                                         "Base.SpearButterKnife", "Base.SpearFork", "Base.SpearLetterOpener", "Base.SpearScalpel", "Base.SpearSpoon", "Base.SpearScissors", "Base.SpearHandFork",
                                         "Base.SpearScrewdriver", "Base.SpearHuntingKnife", "Base.SpearMachete", "Base.SpearIcePick", "Base.SpearKnife", "Base.Machete", "Base.GardenHoe" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 45 then
                    local randomitem = { "Base.Wine", "Base.Wine2", "Base.WhiskeyFull", "Base.BeerCan", "Base.BeerBottle" };
                    print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 50 then
                    local randomitem = { "Base.Bag_SurvivorBag", "Base.Bag_BigHikingBag", "Base.Bag_DuffelBag", "Base.Bag_FannyPackFront", "Base.Bag_NormalHikingBag", "Base.Bag_ALICEpack", "Base.Bag_ALICEpack_Army",
                                         "Base.Bag_Schoolbag", "Base.SackOnions", "Base.SackPotatoes", "Base.SackCarrots", "Base.SackCabbages" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 52 then
                    local randomitem = { "Base.Hat_SPHhelmet", "Base.Jacket_CoatArmy", "Base.Hat_BalaclavaFull", "Base.Hat_BicycleHelmet", "Base.Shoes_BlackBoots", "Base.Hat_CrashHelmet",
                                         "Base.HolsterDouble", "Base.Hat_Fireman", "Base.Jacket_Fireman", "Base.Trousers_Fireman", "Base.Hat_FootballHelmet", "Base.Hat_GasMask", "Base.Ghillie_Trousers", "Base.Ghillie_Top",
                                         "Base.Gloves_LeatherGloves", "Base.JacketLong_Random", "Base.Shoes_ArmyBoots", "Base.Vest_BulletArmy", "Base.Hat_Army", "Base.Hat_HardHat_Miner", "Base.Hat_NBCmask",
                                         "Base.Vest_BulletPolice", "Base.Hat_RiotHelmet", "Base.AmmoStrap_Shells" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 60 then
                    local randomitem = { "Base.CarBattery1", "Base.CarBattery2", "Base.CarBattery3", "Base.Extinguisher", "Base.PetrolCan", "Base.ConcretePowder", "Base.PlasterPowder", "Base.BarbedWire", "Base.Log",
                                         "Base.SheetMetal", "Base.MotionSensor", "Base.ModernTire1", "Base.ModernTire2", "Base.ModernTire3", "Base.ModernSuspension1", "Base.ModernSuspension2", "Base.ModernSuspension3",
                                         "Base.ModernCarMuffler1", "Base.ModernCarMuffler2", "Base.ModernCarMuffler3", "Base.ModernBrake1", "Base.ModernBrake2", "Base.ModernBrake3", "Base.smallSheetMetal",
                                         "Base.Speaker", "Base.EngineParts", "Base.LogStacks2", "Base.LogStacks3", "Base.LogStacks4", "Base.NailsBox" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 65 then
                    local randomitem = { "Base.ComicBook", "Base.ElectronicsMag4", "Base.HerbalistMag", "Base.MetalworkMag1", "Base.MetalworkMag2", "Base.MetalworkMag3", "Base.MetalworkMag4",
                                         "Base.HuntingMag1", "Base.HuntingMag2", "Base.HuntingMag3", "Base.FarmingMag1", "Base.MechanicMag1", "Base.MechanicMag2", "Base.MechanicMag3",
                                         "Base.CookingMag1", "Base.CookingMag2", "Base.EngineerMagazine1", "Base.EngineerMagazine2", "Base.ElectronicsMag1", "Base.ElectronicsMag2", "Base.ElectronicsMag3", "Base.ElectronicsMag5",
                                         "Base.FishingMag1", "Base.FishingMag2", "Base.Book" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 80 then
                    local randomitem = { "Base.Banana", "Base.BellPepper", "Base.BeerCan",
                    "Base.BeefJerky", "Base.Bread", "Base.Gum", "farming.Strewberrie", "farming.Tomato", "farming.Potato", "farming.Cabbage", "Base.Milk",
                    "farming.CarrotBagSeed", "farming.BroccoliBagSeed", "farming.RedRadishBagSeed", "farming.StrewberrieBagSeed", "farming.TomatoBagSeed", "farming.PotatoBagSeed", "farming.CabbageBagSeed",
                    "Base.Needle", "Base.Thread", "Base.RippedSheets", "Base.Matches"};
                                        print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 90 then
                    local randomitem = { "Base.DumbBell", "Base.EggCarton", "Base.HomeAlarm", "Base.HotDog", "Base.HottieZ", "Base.Icecream", "Base.Machete", "Base.Revolver_Long",
                                         "Base.MeatPatty", "Base.Milk", "Base.MuttonChop", "Base.Padlock", "Base.PorkChop", "Base.Ham" };
                                         print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 97 then
                    local randomitem = { "Base.PropaneTank", "Base.BlowTorch", "Base.Woodglue", "Base.DuctTape", "Base.Rope", "Base.Extinguisher" };
                    print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                elseif roll <= 100 then
                    local randomitem = { "Base.Spiffo", "Base.SpiffoSuit", "Base.Hat_Spiffo", "Base.SpiffoTail" };
                    print(randomitem);
                    inv:AddItem(randomitem[ZombRand(1, tablelength(randomitem) - 1)]);
                end
            end

        end
    end

end

local function FearfulUpdate(_player)
    local player = _player;
    if player:HasTrait("fearful") then
        local stats = player:getStats();
        local panic = stats:getPanic();
        if panic > 5 then
            local chance = 3 + panic / 10;
            if player:HasTrait("Cowardly") then
                chance = chance + 1;
            end
            if player:HasTrait("Lucky") then
                chance = chance - 1;
            end
            if player:HasTrait("Unlucky") then
                chance = chance + 1;
            end
            if ZombRand(0, 1000) <= chance then
                if panic <= 25 then
                    player:Say("*Whimper*");
                    addSound(player, player:getX(), player:getY(), player:getZ(), 5, 10);
                elseif panic <= 50 then
                    player:Say("*Muffled Shriek*");
                    addSound(player, player:getX(), player:getY(), player:getZ(), 10, 15);
                elseif panic <= 75 then
                    player:Say("*Panicked Screech*");
                    addSound(player, player:getX(), player:getY(), player:getZ(), 20, 25);
                elseif panic > 75 then
                    player:Say("*Desperate Screaming*");
                    addSound(player, player:getX(), player:getY(), player:getZ(), 25, 50);
                end
            end
        end
    end
end
local function GymGoer(_player, _perk, _amount)
    local player = _player;
    local perk = _perk;
    local amount = _amount;
    if player:HasTrait("gymgoerA") then
        if perk == Perks.Strength then
            amount = amount * 1.5;
            player:getXp():AddXP(perk, amount, false, false);
        end
    elseif player:HasTrait("gymgoerB") then
        if perk == Perks.Fitness then
            amount = amount * 1.5;
            player:getXp():AddXP(perk, amount, false, false);
        end
    end
end
local function test(_container)
    local container = _container;
    local inv = container:getInventory();
    inv:AddItem("Base.Screwdriver");
end
local function MainPlayerUpdate(_player)
    local player = _player;
    local playerdata = player:getModData();
    if internalTick >= 30 then
        vehicleCheck(player);
        FearfulUpdate(player);
        --Reset internalTick every 30 ticks
        internalTick = 0;
    end
    anemic(player);
    thickblood(player);
    CheckDepress(player, playerdata);
    CheckSelfHarm(player);
    badteethtrait(player);
    if suspendevasive == false then
        ToadTraitEvasive(player, playerdata);
    end
    internalTick = internalTick + 1;
end
Events.OnZombieDead.Add(graveRobber);
Events.AddXP.Add(GymGoer);
Events.OnPlayerUpdate.Add(MainPlayerUpdate);
Events.EveryTenMinutes.Add(ToadTraitButter);
Events.EveryTenMinutes.Add(checkWeight);
Events.EveryHours.Add(ToadTraitDepressive);
Events.OnNewGame.Add(initToadTraitsPerks);
Events.OnGameBoot.Add(initToadTraits);
