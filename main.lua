local _, AddonTable = ...
local L = AddonTable.L

local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
local AdiBags_ClassReagents = LibStub("AceAddon-3.0"):NewAddon("AdiBags_ClassReagents")

-- Virag Dev Tool
AdiBags_ClassReagents.kbDEBUG = true
function AdiBags_ClassReagents:Dump(str, obj)
  if ViragDevTool_AddData and AdiBags_ClassReagents.kbDEBUG then 
    ViragDevTool_AddData(obj, str) 
  end
end

AdiBags_ClassReagents.ItemTables = {
  ['MAGE'] = {
    [17056] = true, -- Light Feather
    [17031] = true, -- Rune of Teleportation
    [17032] = true -- Rune of Portals
  },
  ['PRIEST'] = {
    [17056] = true, -- Light Feather
    [17029] = true, -- Sacred Candle
    [17028] = true -- Holy Candle
  },
  ['WARLOCK'] = {
    [5565] = true, -- Infernal Stone
    [16583] = true -- Demonic Figurine
  },
  ['DRUID'] = {
    [17034] = true, -- Maple Seed
    [17021] = true, -- Wild Berries
    [17035] = true, -- Stranglethorn Seed
    [17038] = true, -- Ironwood Seed
    [17036] = true, -- Ashwood Seed
    [17026] = true, -- Wild Thornroot
    [17037] = true -- Hornbeam Seed
  },
  ['ROGUE'] = {
    [8924] = true, -- Dust of Deterioration
    [5173] = true,  -- Deathweed
    [8923] = true -- Essence of Agony
  },
  ['SHAMAN'] = {
    [17030] = true, -- Ankh
  },
  ['PALADIN'] = {
    [21177] = true, -- Symbol of Kings
    [17033] = true -- Symbol of Divinity
  }
}
AddonTable.Modules = {}

function AdiBags_ClassReagents:GetOptions()
  return {}
end

function AdiBags_ClassReagents:GetProfile()
  return {
    PetFood = true
  }
end

function AdiBags_ClassReagents:DefaultFilter(slotData, module, petFoodFilter)
  local prefix = module.prefix

  local localisedClass, playerClass, _ = UnitClass('player')

  local category = 'Class Reagents'

  for className, items in pairs(AdiBags_ClassReagents.ItemTables) do
    if (className == playerClass) then
      category =  localisedClass .. ' Reagents'
    else
      category = 'Class Reagents'
    end

    for id,_ in pairs(items) do
      if (tonumber(id) == slotData.itemId) then
        return category
      end
    end
  end
end

function AdiBags_ClassReagents:GetDefaultCategories()
  return {
    ["Class Reagents"] = "Class Reagents"
  }
end

function AdiBags_ClassReagents:Load(module)
  local petFoodFilter = AdiBags:RegisterFilter(module.namespace, 90)
  petFoodFilter.uiName = module.namespace
  petFoodFilter.uiDesc = module.description

  if module.filter ~=nil then
    function petFoodFilter:Filter(slotData)
      return module.filter(slotData)
    end
  else
    function petFoodFilter:Filter(slotData)
      return AdiBags_ClassReagents:DefaultFilter(slotData, module, petFoodFilter)
    end
  end

  function petFoodFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace(module.namespace, {
      profile = AdiBags_ClassReagents:GetProfile()
    })
  end

  function petFoodFilter:GetOptions()
    return AdiBags_ClassReagents:GetOptions(), AdiBags:GetOptionHandler(self, true)
  end
end

AddonTable.Modules.reagents = {
  ["name"] = "Reagents",
  ["categories"] = AdiBags_ClassReagents:GetDefaultCategories(),
  ["namespace"] = "Class Reagents",
  ["prefix"] = "Class Reagents",
  ["description"] = "Class reagents"
}

AdiBags_ClassReagents:Load(AddonTable.Modules.reagents)
