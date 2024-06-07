Config = {}

-- Job Name --
Config.JobName = 'miner'

-- Minigame --
Config.SkillCheckKeys = {'e'}

-- Pickaxe --
Config.PickAxeSkillDifficulty = {'easy', 'easy', 'easy'}
Config.BreakPickaxe = true      -- Set to false if you do not want the pickaxe to break.
Config.BreakPickaxeChance = 8.5 -- Chance of the pickaxe breaking. 1/100
Config.PickaxeStoneMin = 1      -- Minimum ammount of stone you want when drilling.
Config.PickaxeStoneMax = 3      -- Maximum ammount of stone you want when drilling.
Config.PickaxeReward = {
    ItemList = {
        'raw_copper', 'raw_aluminum', 'raw_iron', 'raw_silver', 'raw_gold'
    }
} 

-- Drill --
Config.DrillSkillDifficulty = {'medium', 'easy', 'medium'}
Config.RemoveDrillBit = true    -- Set to false if you do not want the drill bit to break.
Config.DrillStoneMin= 3         -- Minimum ammount of stone you want when drilling.
Config.DrillStoneMax = 5        -- Maximum ammount of stone you want when drilling.
Config.DrillReward = {
    ItemList = {
    'clump_copper', 'clump_aluminum', 'clump_iron', 'clump_silver', 'clump_gold', 'raw_diamond', 'raw_emerald', 'raw_sapphire', 'raw_ruby'
    }
} 

-- Blips --
Config.BlipMining = true
Config.BlipSmelt = true
Config.BlipGrind = true

-- Smelting --
Config.SmeltingOptions = {
    raw_copper = {
        label = 'Raw Copper',
        duration = 1000
    },
    raw_iron = {
        label = 'Raw Iron',
        duration = 1000
    },
    raw_silver = {
        label = 'Raw Silver',
        duration = 1000
    },
    raw_gold = {
        label = 'Raw Gold',
        duration = 1000
    },
    raw_aluminum = {
        label = 'Raw Aluminium',
        duration = 1000
    },
}
Config.SmeltingOptionsClump = {
    clump_copper = {
        label = 'Clumped Copper',
        duration = 5000
    },
    clump_iron = {
        label = 'Clumped Iron',
        duration = 5000
    },
    clump_silver = {
        label = 'Clumped Silver',
        duration = 5000
    },
    clump_gold = {
        label = 'Clumped Gold',
        duration = 5000
    },
    clump_aluminum = {
        label = 'Clumped Aluminum',
        duration = 5000
    },
}
Config.materialsOptions = {
    raw_diamond = {
        label = 'Raw Diamond',
        duration = 10000
    },
    raw_emerald = {
        label = 'Raw Emerald',
        duration = 10000
    },
    raw_sapphire = {
        label = 'Raw Sapphire',
        duration = 10000
    },
    raw_ruby = {
        label = 'Raw Ruby',
        duration = 10000
    },
}