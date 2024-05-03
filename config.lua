Config = {}

Config.Debug = false

Config.Locales = {
    ['ContainerRobbery'] = 'Konttiryöstö',
    ['LockpickDoor'] = 'Tiirikoi ovi',
    ['BreakDoor'] = 'Murra ovi',
    ['HackDoor'] = 'Häkkeröi ovi',
    ['LockDoor'] = 'Lukitse ovi',
    ['SearchCabinet'] = 'Tutki',
    ['YouFailed'] = 'Epäonnistuit!',
    ['DoorOpened'] = 'Ovi avattu!',
    ['DoorLocked'] = 'Ovi lukittu!',
    ['CabinetSearched'] = 'Kaappi on jo tutkittu!',
    ['CabinetSearching'] = 'Tutkitaan',
    ['HackConnecting'] = 'Yhdistetään',
    ['Breaking'] = 'Murretaan ovea',
    ['Canceled'] = 'Peruutettu',
    ['NothingFound'] = 'Kaapista ei löytynyt mitään!',
}

Config.Containers = {
    HackingItem = 'laptop', -- The name of the item needed for hacking the door
    BreakDoorItem = 'weapon_crowbar', -- The name of the item needed to break the door open
    LockpickItem = 'lockpick', -- The name of the item needed for lockpicking the door
    Cabinets = {
        ChanceOfSkillcheck = 75, -- What is the chance of a skillcheck when searching a cabinet
    },
}

Config.Loot = {
    ChanceOfRare = 5, -- What is the chance of getting rare loot from a cabinet
    Common = { -- The config for the common items: 
        AllowItems = true, -- Do you want to give items from the cabinet
        AllowMoney = true, -- Do you want to give money from the cabinet
        Money = { min = 100, max = 500, chance = 100 }, -- How much money (min, max) and the chance of getting money (chance)
        Item = { min = 1, max = 2 }, -- How many different items do you get from a cabinet
        Items = { -- The list of items the loot is from
            { name = 'lockpick', minQuantity = 1, maxQuantity = 2, chance = 30 },
            -- { name = 'examplename', minQuantity = 1, maxQuantity = 2, chance = 50 }, this is an example of how to add more items 
        }
    },
    Rare = { -- The config for the rare items(works the same as the one for common items): 
        AllowItems = true,
        AllowMoney = true,
        Money = { min = 1000, max = 5000, chance = 100 },
        Item = { min = 1, max = 3 },
        Items = {
            { name = 'lockpick', minQuantity = 1, maxQuantity = 2, chance = 30 },
        }
    }
}
