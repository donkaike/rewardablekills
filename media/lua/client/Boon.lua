require('NPCs/MainCreationMethods');
require("Items/Distributions");
require("Items/ProceduralDistributions");

--[[
    If you are reading this, you may want to make you own configs
    I will comment every place you need to update, but please, post the mod private in workshop for you
    and please, give me the credits! Thanks!
]]

--Global variables
--how much itens per roll
intMaxRolls = 1;

-- luck can influence the rolls
intLuckExtraRoll = 50; -- 0 to 100 (-1 to disable)
intUnluckLostRoll = 50; -- 0 to 100 (-1 to disable)

--chance
intBaseChance = 1;
--added chance by boon
intNoobModify = 5;
intNormalModify = 2;
intVeteranModify = 0;
--added chance by luck;
intLuckModify = 1;
intUnluckModify = -1;

--days until next stage
intNoobDays = 3;
intNormalDays = 8;
intVeteranDays = 20;
-- OR
-- days until next stage
intZedNoob = 200;
intZedNormal = 750;
intZedVeteran = 2000;

--tables of chance by boon
--all tables need to have 1000 points of weigth
DropTables = {
    noobboon = {
        noob = 600,
        common = 300,
        uncommon = 85,
        rare = 10,
        epic = 4,
        legendary = 1,
    },
    normalboon = {
        noob = 130,
        common = 250,
        uncommon = 350,
        rare = 205,
        epic = 50,
        legendary = 15,
    },
    veteranboon = {
        noob = 50,
        common = 100,
        uncommon = 400,
        rare = 250,
        epic = 150,
        legendary = 50,
    },
}

--each table
--test "Base.VHS_Retail"

noobTable = {
    --only foods and water
    "Base.Apple", "Base.Banana", "Base.Bread", "farming.Cabbage", "Base.Pop", 
    "Base.GranolaBar", "Base.JuiceBox", "Base.Dogfood", "Base.WaterBottleFull", "Base.WaterBottleFull",
};

commonTable = {
    -- some common weapons and tools
    "Base.Hammer", "Base.MetalPipe", "Base.GardenSaw",

    -- food
    "Base.CannedCorn", "Base.CannedPotato2", "Base.CannedSardines", "Base.CannedTomato2",
    "Base.BeerCan", "Base.Wine", "Base.Chocolate", "Base.CannedCarrots2",
};

uncommonTable = {
    --weapons
    "Base.GardenFork", "Base.Shovel", "farming.HandShovel", "Base.BaseballBat",

    -- misc
    "Base.WhiskeyFull", "Base.JarLid", "Base.EmptyJar",

    -- consumables things
    "Base.NailsBox", "Base.Twine", "Base.Scissors", "Base.WeldingRods",
    "Base.Wire", "Base.DuctTape", "Base.Woodglue",
};

rareTable = {
    -- better tools and weapons
    "Base.FishingRod", "Base.Axe", "Base.WoodAxe", "Base.WeldingMask", "Base.HandTorch", 

    -- farming
    "subtable.seeds",

    --carparts
    "subtable.carparts", "subtable.carparts",

    --bullets
    "subtable.bullets", "subtable.bullets",

    --cars tools
    "Base.EmptyPetrolCan", "Base.CarBatteryCharger", "Base.Jack", "Base.LugWrench", "Base.TirePump", "Base.Wrench", "Base.EngineParts", 
};

epicTable = {
    -- top weapons
    "Base.Machete",  "Base.Crowbar",
    
    --books
    "subtable.books",

    --magazines
    "subtable.magazines",

    -- misc
    "Base.PropaneTank", "Base.Padlock", "Base.PetrolCan",
};

legendaryTable = {
    -- weapons
    "Base.AssaultRifle", "Base.Katana", 
    
    -- tools
    "Base.Sledgehammer", 

    --bags
    "Base.Bag_ALICEpack_Army", "Base.Bag_ALICEpack",
};


--subtables
SubTables = {
    carparts = {
        "Base.NormalBrake1", "Base.NormalBrake2", "Base.NormalBrake3",
        "Base.NormalSuspension1", "Base.NormalSuspension2", "Base.NormalSuspension3",
        "Base.NormalTire1", "Base.NormalTire2", "Base.NormalTire3", 
        "Base.FrontWindow1", "Base.FrontWindow2", "Base.FrontWindow3", 
        "Base.RearWindow1", "Base.RearWindow2", "Base.RearWindow3", 
        "Base.RearWindshield1", "Base.RearWindshield2", "Base.RearWindshield3", 
        "Base.Windshield1", "Base.Windshield2", "Base.Windshield3", 
        "Base.CarBattery1", "Base.CarBattery2", "Base.CarBattery3",
    },
    
    books = {
        "Base.BookCarpentry1", "Base.BookCarpentry2", "Base.BookCarpentry3", "Base.BookCarpentry4", "Base.BookCarpentry5",
        "Base.BookCooking1", "Base.BookCooking2", "Base.BookCooking3", "Base.BookCooking4", "Base.BookCooking5",
        "Base.BookElectrician1", "Base.BookElectrician2", "Base.BookElectrician3", "Base.BookElectrician4", "Base.BookElectrician5",
        "Base.BookFarming1", "Base.BookFarming2", "Base.BookFarming3", "Base.BookFarming4", "Base.BookFarming5",
        "Base.BookFirstAid1", "Base.BookFirstAid2", "Base.BookFirstAid3", "Base.BookFirstAid4", "Base.BookFirstAid5",
        "Base.BookFishing1", "Base.BookFishing2", "Base.BookFishing3", "Base.BookFishing4", "Base.BookFishing5",
        "Base.BookForaging1", "Base.BookForaging2", "Base.BookForaging3", "Base.BookForaging4", "Base.BookForaging5",
        "Base.BookMechanic1", "Base.BookMechanic2", "Base.BookMechanic3", "Base.BookMechanic4", "Base.BookMechanic5",
        "Base.BookMetalWelding1", "Base.BookMetalWelding2", "Base.BookMetalWelding3", "Base.BookMetalWelding4", "Base.BookMetalWelding5",
        "Base.BookTailoring1", "Base.BookTailoring2", "Base.BookTailoring3", "Base.BookTailoring4", "Base.BookTailoring5",
        "Base.BookTrapping1", "Base.BookTrapping2", "Base.BookTrapping3", "Base.BookTrapping4", "Base.BookTrapping5",
    },
    
    magazines = {
        "Base.CookingMag1", "Base.CookingMag2", "Base.ElectronicsMag1", "Base.ElectronicsMag2", "Base.ElectronicsMag3",
        "Base.ElectronicsMag4", "Base.ElectronicsMag5", "Base.EngineerMagazine1", "Base.EngineerMagazine2",
        "Base.FarmingMag1", "Base.FishingMag1", "Base.FishingMag2", "Base.HerbalistMag", "Base.HuntingMag1", "Base.HuntingMag2",
        "Base.HuntingMag3", "Base.MechanicMag1", "Base.MechanicMag2", "Base.MechanicMag3", "Base.MetalworkMag1",
        "Base.MetalworkMag2", "Base.MetalworkMag3", "Base.MetalworkMag4",
    },
    
    bullets = {
        "Base.Bullets9mmBox", "Base.Bullets45Box", "Base.Bullets44Box", "Base.Bullets38Box",
        "Base.223Box", "Base.308Box", "Base.ShotgunShellsBox",
    },
    
    seeds = {
        "farming.BroccoliBagSeed", "farming.CabbageBagSeed", "farming.CarrotBagSeed", 
        "farming.PotatoBagSeed", "farming.RedRadishBagSeed", "farming.StrewberrieBagSeed",
        "farming.TomatoBagSeed", 
    },
}

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

local function initPlayer()
    local player = getPlayer();
    player:getTraits():add("noobboon");
end

local function checkProgress()
    local player = getPlayer();
    local zombieKills = player:getZombieKills();
    local daysAlive = 0;

    if player:getHoursSurvived() > 0 then
        daysAlive = player:getHoursSurvived() / 24;
        print("hours " .. daysAlive);
    end

    if player:HasTrait("noobboon") then
        if daysAlive >= intNormalDays or zombieKills >= intZedNoob then
            player:getTraits():remove("noobboon");
            player:getTraits():add("normalboon");
        end
    elseif player:HasTrait("normalboon") then
        if daysAlive >= intVeteranDays or zombieKills >= intZedNormal then
            player:getTraits():remove("normalboon");
            player:getTraits():add("veteranboon");
        end
    end
end

local function boonAction(_zombie)
    local player = getPlayer();
    local zombie = _zombie;
    local chance = intBaseChance;
    local extraRoll = 0;

    --luck influence
    if player:HasTrait("Lucky") then
        chance = chance + intLuckModify;
        -- with luck you have a chance of get extra roll
        if ZombRand(0, 100) <= intLuckExtraRoll then
            extraRoll = 1;
        end
    end 

    --unluck influence
    if player:HasTrait("Unlucky") then
        chance = chance + intUnluckModify;
        -- with unluck you have a chance of lost an roll, only if the rolls of server are more than one
        if ZombRand(0, 100) <= intUnluckLostRoll and intMaxRolls > 1 then
            extraRoll = -1;
        end
    end

    if chance <= 0 then
        chance = 1;
    end

    -- get current boon and set modify
    local currentBoon = "noobboon";
    if player:HasTrait("noobboon") then
        chance = chance + intNoobModify;
    elseif player:HasTrait("normalboon") then
        chance = chance + intNormalModify;
        currentBoon = "normalboon";
    elseif player:HasTrait("veteranboon") then
        chance = chance + intVeteranModify;
        currentBoon = "veteranboon";
    end
    
    -- first we see if will enter in loot tables
    if ZombRand(0, 100) <= chance then
        local itterations = ZombRand(1, intMaxRolls + extraRoll);
        print("rolasssssssssssssssss " .. itterations);
        for i = 0, itterations do
            i = i + 1;
            local roll = ZombRand(0, 1000);
            local randomitem = "";
            local increment = 0;

            if roll <= DropTables[currentBoon]["legendary"] then
                print("legendary");
                randomitem = legendaryTable[ZombRand(1, tablelength(legendaryTable))];
            else
                increment = increment + DropTables[currentBoon]["legendary"];
            end


            if roll <= DropTables[currentBoon]["epic"] + increment and randomitem == "" then
                print("epic");
                randomitem = epicTable[ZombRand(1, tablelength(epicTable))];
            else
                increment = increment + DropTables[currentBoon]["epic"];
            end

            if roll <= DropTables[currentBoon]["rare"] + increment and randomitem == "" then
                print("rare");
                randomitem = rareTable[ZombRand(1, tablelength(rareTable))];
            else
                increment = increment + DropTables[currentBoon]["rare"];
            end

            if roll <= DropTables[currentBoon]["uncommon"] + increment and randomitem == "" then
                print("uncommon");
                randomitem = uncommonTable[ZombRand(1, tablelength(uncommonTable))];
            else
                increment = increment + DropTables[currentBoon]["uncommon"];
            end

            if roll <= DropTables[currentBoon]["common"] + increment and randomitem == "" then
                print("common");
                randomitem = commonTable[ZombRand(1, tablelength(commonTable))];
            else
                increment = increment + DropTables[currentBoon]["common"];
            end

            if roll <= DropTables[currentBoon]["noob"] + increment and randomitem == "" then
                print("noob");
                randomitem = noobTable[ZombRand(1, tablelength(noobTable))];
            end

            --check if is a subtable
            if string.find(randomitem, "subtable") then
                randomitem = SubTables[string.gsub(randomitem, "subtable.", "")][ZombRand(1, tablelength(SubTables[string.gsub(randomitem, "subtable.", "")]))];
                print("SUB TABLE @@@@@@@ " .. randomitem);
            end

            print("droooppp ########## " .. randomitem);

            zombie:getInventory():AddItem(randomitem);
            player:getInventory():AddItem(randomitem);
        end

    end

end

Events.OnZombieDead.Add(boonAction); --every kill

Events.EveryHours.Add(checkProgress); --every hour check progress

Events.OnNewGame.Add(initPlayer); -- init the traits
--Events.OnNewGame.Add(addStartingTrait); --add the starting trait

