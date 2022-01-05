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
intMaxRolls = 2;

-- luck can influence the rolls
intLuckExtraRoll = 50; -- 0 to 100 (-1 to disable)
intUnluckLostRoll = 50; -- 0 to 100 (-1 to disable)

--chance
intBaseChance = 3;
--added chance by boon
intNoobModify = 18;
intNormalModify = 10;
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
        common = 400,
        uncommon = 300,
        rare = 105,
        epic = 50,
        legendary = 15,
    },
    veteranboon = {
        noob = 50,
        common = 200,
        uncommon = 400,
        rare = 200,
        epic = 100,
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
    "Base.Hammer", "Base.MetalPipe", "Base.Screwdriver", "Base.KitchenKnife",
    "Base.GardenSaw", "Radio.WalkieTalkie1", "Base.SpearCrafted"
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
    "Base.NailsBox", "Base.Twine", "Base.Scissors", "Base.Cigarettes", "Base.Lighter", "Base.Matches", "Base.WeldingRods",
    "Base.Wire", "Base.DuctTape", "Base.Woodglue",

    -- medical
    "Base.Pills", "Base.PillsAntiDep", "Base.PillsBeta", "Base.PillsVitamins", "Base.Antibiotics",
    "Base.Disinfectant", "Base.Bandage", 

    --bullets
    "subtable.bullets"
};

rareTable = {
    -- better tools and weapons
    "Base.FishingRod", "Base.Axe", "Base.WoodAxe", "Base.WeldingMask", "Base.HandTorch", 

    -- farming
    "subtable.seeds",

    --carparts
    "subtable.carparts",

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
    "Base.AssaultRifle2", "Base.Katana", 
    
    -- tools
    "Base.Generator", "Base.Sledgehammer", 

    --bags
    "Base.Bag_ALICEpack_Army", "Base.Bag_ALICEpack",
};


--subtables
carparts = {
    "Base.NormalBrake1", "Base.NormalBrake2", "Base.NormalBrake3",
    "Base.NormalSuspension1", "Base.NormalSuspension2", "Base.NormalSuspension3",
    "Base.NormalTire1", "Base.NormalTire2", "Base.NormalTire3", 
    "Base.FrontWindow1", "Base.FrontWindow2", "Base.FrontWindow3", 
    "Base.RearWindow1", "Base.RearWindow2", "Base.RearWindow3", 
    "Base.RearWindshield1", "Base.RearWindshield2", "Base.RearWindshield3", 
    "Base.Windshield1", "Base.Windshield2", "Base.Windshield3", 
    "Base.CarBattery1", "Base.CarBattery2", "Base.CarBattery3",
};

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
};

magazines = {
    "Base.CookingMag1", "Base.CookingMag2", "Base.ElectronicsMag1", "Base.ElectronicsMag2", "Base.ElectronicsMag3",
    "Base.ElectronicsMag4", "Base.ElectronicsMag5", "Base.EngineerMagazine1", "Base.EngineerMagazine2",
    "Base.FarmingMag1", "Base.FishingMag1", "Base.FishingMag2", "Base.HerbalistMag", "Base.HuntingMag1", "Base.HuntingMag2",
    "Base.HuntingMag3", "Base.MechanicMag1", "Base.MechanicMag2", "Base.MechanicMag3", "Base.MetalworkMag1",
    "Base.MetalworkMag2", "Base.MetalworkMag3", "Base.MetalworkMag4",
}

bullets = {
    "Base.Bullets9mmBox", "Base.Bullets45Box", "Base.Bullets44Box", "Base.Bullets38Box",
    "Base.223Box", "Base.308Box", "Base.ShotgunShellsBox",
}

seeds = {
    "farming.BroccoliBagSeed", "farming.CabbageBagSeed", "farming.CarrotBagSeed", 
    "farming.PotatoBagSeed", "farming.RedRadishBagSeed", "farming.StrewberrieBagSeed",
    "farming.TomatoBagSeed", 
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

local function initTraits()
    local noobboon = TraitFactory.addTrait("noobboon", getText("UI_trait_noobboon"), 0, getText("UI_trait_noobboondesc"), false, false);
    local normalboon = TraitFactory.addTrait("normalboon", getText("UI_trait_normalboon"), 0, getText("UI_trait_normalboondesc"), false, false);
    local veteranboon = TraitFactory.addTrait("veteranboon", getText("UI_trait_veteranboon"), 0, getText("UI_trait_veteranboondesc"), false, false);
end

local function addStartingTrait(_player)
    local player = _player;
    player:getTraits():add("noobboon");
end

local function checkProgress()
    local player = getPlayer();
    local zombieKills = player:getZombieKills();
    local daysAlive = player:getHoursSurvived() / 24;

    if player:HasTrait("noobboon") and daysAlive >= intVeteranDays or zombieKills >= intZedVeteran then
        player:getTraits():remove("noobboon");
        player:getTraits():add("normalboon");
    elseif player:HasTrait("normalboon") daysAlive >= intNormalDays or zombieKills >= intZedNormal then
        player:getTraits():remove("normalboon");
        player:getTraits():add("veteranboon");
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

    --kills influence
    if then
    elseif roll <= 20 then
    end
    
    if chance <= 0 then
        chance = 1;
    end

    if player:HasTrait("noobboon") then
        if ZombRand(0, 100) <= chance then
            local inv = zombie:getInventory();
            local itterations = ZombRand(1, intMaxRolls);
            for i = 0, itterations do
                i = i + 1;
                local roll = ZombRand(0, 1000);
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

Events.OnZombieDead.Add(boonAction); --every kill

Events.EveryHours.Add(checkProgress); --every hour check progress

Events.OnNewGame.Add(initTraits); -- init the traits
Events.OnNewGame.Add(addStartingTrait); --add the starting trait

