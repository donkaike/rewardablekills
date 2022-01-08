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

    --books
    "subtable.books",

    --magazines
    "subtable.magazines",

    -- consumables things
    "Base.NailsBox", "Base.Twine", "Base.Scissors", "Base.WeldingRods",
    "Base.Wire", "Base.DuctTape", "Base.Woodglue",
};

rareTable = {
    -- farming
    "subtable.seeds",

    --carparts
    "subtable.carparts", "Base.EngineParts", 

    --bullets
    "subtable.bullets",

    --vhs
    "Base.VHS_Retail",
};

epicTable = {
    -- better tools and weapons
    "Base.Machete", "Base.Crowbar", "Base.Axe", "Base.WoodAxe", "Base.FishingRod",

    --cars tools
    "Base.CarBatteryCharger", "Base.Jack", "Base.LugWrench", "Base.TirePump", "Base.Wrench",

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
    elseif player:HasTrait("veteranboon") == false then
        local playerdata = player:getModData();
        playerdata.iNoobDrops = 0;
        playerdata.iCommonDrops = 0;
        playerdata.iUncommonDrops = 0;
        playerdata.iRareDrops = 0;
        playerdata.iEpicDrops = 0;
        playerdata.iLegendaryDrops = 0;
        player:getTraits():add("noobboon");
    end
end

local function boonAction(_zombie)
    local player = getPlayer();
    local zombie = _zombie;
    local chance = intBaseChance;
    local extraRoll = 0;
    local playerdata = player:getModData();

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
        for i = 1, itterations do
            i = i + 1;
            local roll = ZombRand(0, 1000);
            local randomitem = "";
            local increment = 0;

            if roll <= DropTables[currentBoon]["legendary"] then
                randomitem = legendaryTable[ZombRand(1, tablelength(legendaryTable))];
                playerdata.iLegendaryDrops = playerdata.iLegendaryDrops + 1;
            else
                increment = increment + DropTables[currentBoon]["legendary"];
            end


            if roll <= DropTables[currentBoon]["epic"] + increment and randomitem == "" then
                randomitem = epicTable[ZombRand(1, tablelength(epicTable))];
                playerdata.iEpicDrops = playerdata.iEpicDrops + 1;
            else
                increment = increment + DropTables[currentBoon]["epic"];
            end

            if roll <= DropTables[currentBoon]["rare"] + increment and randomitem == "" then
                randomitem = rareTable[ZombRand(1, tablelength(rareTable))];
                playerdata.iRareDrops = playerdata.iRareDrops + 1;
            else
                increment = increment + DropTables[currentBoon]["rare"];
            end

            if roll <= DropTables[currentBoon]["uncommon"] + increment and randomitem == "" then
                randomitem = uncommonTable[ZombRand(1, tablelength(uncommonTable))];
                playerdata.iUncommonDrops = playerdata.iUncommonDrops + 1;
            else
                increment = increment + DropTables[currentBoon]["uncommon"];
            end

            if roll <= DropTables[currentBoon]["common"] + increment and randomitem == "" then
                randomitem = commonTable[ZombRand(1, tablelength(commonTable))];
                playerdata.iCommonDrops = playerdata.iCommonDrops + 1;
            else
                increment = increment + DropTables[currentBoon]["common"];
            end

            if roll <= DropTables[currentBoon]["noob"] + increment and randomitem == "" then
                randomitem = noobTable[ZombRand(1, tablelength(noobTable))];
                playerdata.iNoobDrops = playerdata.iNoobDrops + 1;
            end

            --check if is a subtable
            if string.find(randomitem, "subtable") then
                randomitem = SubTables[string.gsub(randomitem, "subtable.", "")][ZombRand(1, tablelength(SubTables[string.gsub(randomitem, "subtable.", "")]))];
            end

            zombie:getInventory():AddItem(randomitem);
            --player:getInventory():AddItem(randomitem);
        end

    end

end

Events.OnZombieDead.Add(boonAction); --every kill

Events.EveryHours.Add(checkProgress); --every hour check progress

Events.OnNewGame.Add(initPlayer); -- init the traits
--Events.OnNewGame.Add(addStartingTrait); --add the starting trait

