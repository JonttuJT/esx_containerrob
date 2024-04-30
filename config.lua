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
    HackingItem = 'laptop',
    BreakDoorItem = 'weapon_crowbar',
    LockpickItem = 'lockpick',
    Cabinets = {
        ChanceOfSkillcheck = 75,
    },
}

Config.Loot = {
    ChanceOfRare = 5,
    Common = {
        AllowItems = true,
        AllowMoney = true,
        Money = {min = 100, max = 500, chance = 100},
        Item = {min = 1, max = 2},
        Items = {
            {name = 'lockpick', minQuantity = 1, maxQuantity = 2, chance = 30}
        }
    },
    Rare = {
        AllowItems = true,
        AllowMoney = true,
        Money = {min = 1000, max = 5000, chance = 100},
        Item = {min = 1, max = 3},
        Items = {
            {name = 'lockpick', minQuantity = 1, maxQuantity = 2, chance = 30}
        }
    }
}