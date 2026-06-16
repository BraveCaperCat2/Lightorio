require("prototypes.data-utils")

require("prototypes.mundane")

-- Mundane science pack (gray)
update_pack(
    data.raw["tool"]["automation-science-pack"],
    {
        name = "li_mundane-science-pack",
        colour = {r = 0.588, g = 0.588, b = 0.588, a = 1.000},
        order = "a"
    }
)

local PhotoElectrics = {}
PhotoElectrics.name = "li_photo-electrics"
PhotoElectrics.type = "technology"
---@cast PhotoElectrics data.TechnologyPrototype
PhotoElectrics.icon = image("__base__/graphics/technology/solar-energy.png")
PhotoElectrics.icon_size = 256
PhotoElectrics.unit = {
    ingredients = {{"automation-science-pack", 1}},
    time = 30,
    count = 120
}
PhotoElectrics.prerequisites = {"radar", "automation-science-pack", "li_scientific-equipment"}
data:extend{PhotoElectrics}

data.raw["technology"]["solar-energy"].unit.ingredients = {{"automation-science-pack", 1}}
data.raw["technology"]["solar-energy"].prerequisites = {"li_photo-electrics", "steel-processing", "automation-science-pack"}

table.insert(data.raw["technology"]["lamp"].prerequisites, "li_photo-electrics")

local CrushedCopperOre = table.deepcopy(data.raw["item"]["copper-ore"])
CrushedCopperOre.name = "li_crushed-copper-ore"
CrushedCopperOre.auto_recycle = false
CrushedCopperOre.pictures = nil
CrushedCopperOre.icons = {
    {
        icon = image("__base__/graphics/icons/copper-ore.png"),
        tint = {r = 0.850, g = 0.850, b = 0.850, a = 1}
    }
}
CrushedCopperOre.order = "fa[crushed-copper-ore]"
CrushedCopperOre.stack_size = 200
data:extend{CrushedCopperOre}

local CrushedCopperOreRecipe = {}
CrushedCopperOreRecipe.name = "li_crushed-copper-ore"
CrushedCopperOreRecipe.type = "recipe"
---@cast CrushedCopperOreRecipe data.RecipePrototype
CrushedCopperOreRecipe.ingredients = {
    {amount = 2, name = "copper-ore", type = "item"}
}
CrushedCopperOreRecipe.results = {
    {amount = 3, name = "li_crushed-copper-ore", type = "item"}
}
CrushedCopperOreRecipe.energy_required = 3.4
CrushedCopperOreRecipe.enabled = false
data:extend{CrushedCopperOreRecipe}

local CopperPowder = table.deepcopy(data.raw["item"]["copper-ore"])
CopperPowder.name = "li_copper-powder"
CopperPowder.auto_recycle = false
CopperPowder.pictures = nil
CopperPowder.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.857, g = 0.625, b = 0.616, a = 1}
    }
}
CopperPowder.order = "fb[copper-powder]"
CopperPowder.stack_size = 200
data:extend{CopperPowder}

local SilverPowder = table.deepcopy(data.raw["item"]["iron-ore"])
SilverPowder.name = "li_silver-powder"
SilverPowder.auto_recycle = false
SilverPowder.pictures = nil
SilverPowder.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.725, g = 0.860, b = 0.964, a = 1}
    }
}
SilverPowder.order = "fc[silver-powder]"
SilverPowder.stack_size = 200
data:extend{SilverPowder}

local CopperPurification = {}
CopperPurification.name = "li_copper-purification"
CopperPurification.type = "recipe"
---@cast CopperPurification data.RecipePrototype
CopperPurification.ingredients = {
    {amount =  5, name = "li_crushed-copper-ore", type = "item"},
    {amount = 50, name = "water", type = "fluid"}
}
CopperPurification.results = {
    {amount = 4, name = "li_copper-powder", type = "item"},
    {amount = 1, name = "li_silver-powder", type = "item"}
}
CopperPurification.category = "crafting-with-fluid"
CopperPurification.energy_required = 6
CopperPurification.main_product = "li_copper-powder"
CopperPurification.enabled = false
data:extend{CopperPurification}

local CopperSmelting = {}
CopperSmelting.name = "li_copper-plate-advanced"
CopperSmelting.type = "recipe"
---@cast CopperSmelting data.RecipePrototype
CopperSmelting.ingredients = {
    {amount = 1, name = "li_copper-powder", type = "item"},
}
CopperSmelting.results = {
    {amount = 1, name = "copper-plate", type = "item"}
}
CopperSmelting.category = "smelting"
CopperSmelting.energy_required = 3.2
CopperSmelting.enabled = false
data:extend{CopperSmelting}

local SilverPlate = table.deepcopy(data.raw["item"]["iron-plate"])
SilverPlate.name = "li_silver-plate"
SilverPlate.auto_recycle = false
SilverPlate.icons = {
    {
        icon = image("__base__/graphics/icons/iron-plate.png"),
        tint = {r = 0.606, g = 0.888, b = 0.990, a = 1}
    }
}
SilverPlate.order = "a[smelting]-ba[li_silver-plate]"
data:extend{SilverPlate}

local SilverSmelting = {}
SilverSmelting.name = "li_silver-plate"
SilverSmelting.type = "recipe"
---@cast SilverSmelting data.RecipePrototype
SilverSmelting.ingredients = {
    {amount = 1, name = "li_silver-powder", type = "item"}
}
SilverSmelting.results = {
    {amount = 1, name = "li_silver-plate", type = "item"}
}
SilverSmelting.category = "smelting"
SilverSmelting.energy_required = 4.8
SilverSmelting.enabled = false
data:extend{SilverSmelting}

local SilverSolution = table.deepcopy(data.raw["fluid"]["water"])
SilverSolution.name = "li_silver-solution"
SilverSolution.auto_barrel = true
SilverSolution.base_color = {r = 0.513, g = 0.752, b = 0.839, a = 1}
SilverSolution.order = "a[fluid]-az[li_silver-solution]"
data:extend{SilverSolution}

local SilverSolutionRecipe = {}
SilverSolutionRecipe.name = "li_silver-solution"
SilverSolutionRecipe.type = "recipe"
---@cast SilverSolutionRecipe data.RecipePrototype
SilverSolutionRecipe.ingredients = {
    {amount =  5, name = "li_silver-powder", type = "item"},
    {amount = 50, name = "water", type = "fluid"}
}
SilverSolutionRecipe.results = {
    {amount = 65, name = "li_silver-solution", type = "fluid"}
}
SilverSolutionRecipe.category = "crafting-with-fluid"
SilverSolutionRecipe.energy_required = 12.2
SilverSolutionRecipe.enabled = false
data:extend{SilverSolutionRecipe}

local AdvancedCopperProcessing = {}
AdvancedCopperProcessing.name = "li_advanced-copper-processing"
AdvancedCopperProcessing.type = "technology"
---@cast AdvancedCopperProcessing data.TechnologyPrototype
AdvancedCopperProcessing.icon = image("__base__/graphics/technology/advanced-material-processing.png")
AdvancedCopperProcessing.icon_size = 256
AdvancedCopperProcessing.effects = {
    {type = "unlock-recipe", recipe = "li_silver-plate"},
    {type = "unlock-recipe", recipe = "li_silver-solution"},
    {type = "unlock-recipe", recipe = "li_crushed-copper-ore"},
    {type = "unlock-recipe", recipe = "li_copper-purification"},
    {type = "unlock-recipe", recipe = "li_copper-plate-advanced"}
}
AdvancedCopperProcessing.unit = {
    ingredients = {{"automation-science-pack", 1}},
    time = 60,
    count = 500
}
AdvancedCopperProcessing.prerequisites = {"automation-science-pack", "steel-processing"}
data:extend{AdvancedCopperProcessing}

local CrushedIronOre = table.deepcopy(data.raw["item"]["iron-ore"])
CrushedIronOre.name = "li_crushed-iron-ore"
CrushedIronOre.auto_recycle = false
CrushedIronOre.pictures = nil
CrushedIronOre.icons = {
    --[[{
        icon = image("__base__/graphics/icons/stone-ore.png"),
        tint = {r = 0.322, g = 0.851, b = 0.969, a = 1}
    }]]--
    {
        icon = image("__base__/graphics/icons/iron-ore.png"),
        tint = {r = 0.850, g = 0.850, b = 0.850, a = 1}
    }
}
CrushedIronOre.order = "ea[crushed-iron-ore]"
CrushedIronOre.stack_size = 200
data:extend{CrushedIronOre}

local CrushedIronOreRecipe = {}
CrushedIronOreRecipe.name = "li_crushed-iron-ore"
CrushedIronOreRecipe.type = "recipe"
---@cast CrushedIronOreRecipe data.RecipePrototype
CrushedIronOreRecipe.ingredients = {
    {amount = 2, name = "iron-ore", type = "item"}
}
CrushedIronOreRecipe.results = {
    {amount = 3, name = "li_crushed-iron-ore", type = "item"}
}
CrushedIronOreRecipe.energy_required = 3.4
CrushedIronOreRecipe.enabled = false
data:extend{CrushedIronOreRecipe}

local IronPowder = table.deepcopy(data.raw["item"]["iron-ore"])
IronPowder.name = "li_iron-powder"
IronPowder.auto_recycle = false
IronPowder.pictures = nil
IronPowder.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.638, g = 0.779, b = 0.987, a = 1}
    }
}
IronPowder.order = "eb[iron-powder]"
IronPowder.stack_size = 200
data:extend{IronPowder}

local NickelPowder = table.deepcopy(data.raw["item"]["iron-ore"])
NickelPowder.name = "li_nickel-powder"
NickelPowder.auto_recycle = false
NickelPowder.pictures = nil
NickelPowder.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.336, g = 0.974, b = 0.974, a = 1}
    }
}
NickelPowder.order = "ec[nickel-powder]"
NickelPowder.stack_size = 200
data:extend{NickelPowder}

local IronPurification = {}
IronPurification.name = "li_iron-purification"
IronPurification.type = "recipe"
---@cast IronPurification data.RecipePrototype
IronPurification.ingredients = {
    {amount =  5, name = "li_crushed-iron-ore", type = "item"},
    {amount = 50, name = "water", type = "fluid"}
}
IronPurification.results = {
    {amount = 4, name = "li_iron-powder", type = "item"},
    {amount = 1, name = "li_nickel-powder", type = "item"}
}
IronPurification.category = "crafting-with-fluid"
IronPurification.energy_required = 6
IronPurification.main_product = "li_iron-powder"
IronPurification.enabled = false
data:extend{IronPurification}

local IronSmelting = {}
IronSmelting.name = "li_iron-plate-advanced"
IronSmelting.type = "recipe"
---@cast IronSmelting data.RecipePrototype
IronSmelting.ingredients = {
    {amount = 1, name = "li_iron-powder", type = "item"},
}
IronSmelting.results = {
    {amount = 1, name = "iron-plate", type = "item"}
}
IronSmelting.category = "smelting"
IronSmelting.energy_required = 3.2
IronSmelting.enabled = false
data:extend{IronSmelting}

local NickelPlate = table.deepcopy(data.raw["item"]["iron-plate"])
NickelPlate.name = "li_nickel-plate"
NickelPlate.auto_recycle = false
NickelPlate.icons = {
    {
        icon = image("__base__/graphics/icons/iron-plate.png"),
        tint = {r = 0.449, g = 0.959, b = 0.757, a = 1}
    }
}
NickelPlate.order = "a[smelting]-ba[li_nickel-plate]"
data:extend{NickelPlate}

local NickelSmelting = {}
NickelSmelting.name = "li_nickel-plate"
NickelSmelting.type = "recipe"
---@cast NickelSmelting data.RecipePrototype
NickelSmelting.ingredients = {
    {amount = 1, name = "li_nickel-powder", type = "item"}
}
NickelSmelting.results = {
    {amount = 1, name = "li_nickel-plate", type = "item"}
}
NickelSmelting.category = "smelting"
NickelSmelting.energy_required = 4.8
NickelSmelting.enabled = false
data:extend{NickelSmelting}

local ElectricNickelPowder = table.deepcopy(data.raw["item"]["li_nickel-powder"])
ElectricNickelPowder.name = "li_electric-nickel-powder"
ElectricNickelPowder.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.354, g = 0.992, b = 0.992, a = 1}
    },
    {
        icon = image("__base__/graphics/icons/signal/signal-lightning.png"),
        tint = {r = 0.780, g = 0.890, b = 0.152, a = 1},
        shift = {x = 8, y = -8},
        scale = 0.25
    }
}
ElectricNickelPowder.order = "ed[electric-nickel-powder]"
data:extend{ElectricNickelPowder}

local ElectricNickelPowderRecipe = {}
ElectricNickelPowderRecipe.name = "li_electric-nickel-powder"
ElectricNickelPowderRecipe.type = "recipe"
---@cast ElectricNickelPowderRecipe data.RecipePrototype
ElectricNickelPowderRecipe.ingredients = {
    {amount = 4, name = "li_nickel-powder", type = "item"},
    {amount = 1, name = "li_copper-powder", type = "item"}
}
ElectricNickelPowderRecipe.results = {
    {amount = 5, name = "li_electric-nickel-powder", type = "item"}
}
ElectricNickelPowderRecipe.energy_required = 30.2
ElectricNickelPowderRecipe.enabled = false
data:extend{ElectricNickelPowderRecipe}

local AdvancedIronProcessing = {}
AdvancedIronProcessing.name = "li_advanced-iron-processing"
AdvancedIronProcessing.type = "technology"
---@cast AdvancedIronProcessing data.TechnologyPrototype
AdvancedIronProcessing.icon = image("__base__/graphics/technology/advanced-material-processing.png")
AdvancedIronProcessing.icon_size = 256
AdvancedIronProcessing.effects = {
    {type = "unlock-recipe", recipe = "li_nickel-plate"},
    {type = "unlock-recipe", recipe = "li_electric-nickel-powder"},
    {type = "unlock-recipe", recipe = "li_crushed-iron-ore"},
    {type = "unlock-recipe", recipe = "li_iron-purification"},
    {type = "unlock-recipe", recipe = "li_iron-plate-advanced"}
}
AdvancedIronProcessing.unit = {
    ingredients = {{"automation-science-pack", 1}},
    time = 60,
    count = 500
}
AdvancedIronProcessing.prerequisites = {"automation-science-pack", "steel-processing"}
data:extend{AdvancedIronProcessing}

local Mirror = table.deepcopy(data.raw["item"]["li_glass"])
Mirror.name = "li_mirror"
Mirror.auto_recycle = true
Mirror.order = "e[li_mirror]"
data:extend{Mirror}

local MirrorRecipe = {}
MirrorRecipe.name = "li_mirror"
MirrorRecipe.type = "recipe"
---@cast MirrorRecipe data.RecipePrototype
MirrorRecipe.ingredients = {
    {amount =  3, name = "li_glass", type = "item"},
    {amount =  4, name = "copper-plate", type = "item"},
    {amount = 50, name = "li_silver-solution", type = "fluid"}
}
MirrorRecipe.results = {
    {amount = 1, name = "li_mirror", type = "item"}
}
MirrorRecipe.category = "crafting-with-fluid"
MirrorRecipe.energy_required = 20
MirrorRecipe.enabled = false
data:extend{MirrorRecipe}

local ReflectionRecipeCategory = {}
ReflectionRecipeCategory.name = "reflection"
ReflectionRecipeCategory.type = "recipe-category"
data:extend{ReflectionRecipeCategory}

local ReflectingRecipe = {}
ReflectingRecipe.name = "li_reflecting"
ReflectingRecipe.type = "recipe"
---@cast ReflectingRecipe data.RecipePrototype
ReflectingRecipe.ingredients = {}
ReflectingRecipe.results = {
    {type = "light", name = "any"}
}
ReflectingRecipe.category = "reflection"
ReflectingRecipe.required_light = {light_type = "any", amount = 1, specific_direction = defines.direction.west}
ReflectingRecipe.icon = image("__core__/graphics/empty.png")
ReflectingRecipe.energy_required = 0.01 
ReflectingRecipe.hidden = true
ReflectingRecipe.hidden_in_factoriopedia = true
data:extend{ReflectingRecipe}

local LargeMirror = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
LargeMirror.name = "li_large-mirror"
LargeMirror.energy_source.type = "void"
LargeMirror.energy_source.emissions_per_minute["pollution"] = 0
LargeMirror.minable.result = "li_large-mirror"
LargeMirror.fixed_recipe = "li_reflecting"
LargeMirror.crafting_categories = {"reflection"}
LargeMirror.light_output = true
LargeMirror.light_direction = defines.direction.north
LargeMirror.crafting_speed = 1
LargeMirror.module_slots = 0
LargeMirror.no_ams = (mods["QualityAssurance"] == nil) and nil or true
LargeMirror.fluid_boxes_off_when_no_fluid_recipe = false
-- LargeMirror.collision_box = {left_top = {-0.29, -0.29}, right_bottom = {0.29, 0.29}}
LargeMirror.next_upgrade = nil
LargeMirror.fast_replaceable_group = nil
LargeMirror.forced_symmetry = "horizontal"
data:extend{LargeMirror}

local LargeMirrorItem = table.deepcopy(data.raw["item"]["assembling-machine-2"])
LargeMirrorItem.name = "li_large-mirror"
LargeMirrorItem.auto_recycle = true
LargeMirrorItem.order = "ba[li_large-mirror]"
LargeMirrorItem.place_result = "li_large-mirror"
data:extend{LargeMirrorItem}

local LargeMirrorRecipe = {}
LargeMirrorRecipe.name = "li_large-mirror"
LargeMirrorRecipe.type = "recipe"
---@cast LargeMirrorRecipe data.RecipePrototype
LargeMirrorRecipe.ingredients = {
    {amount = 3, name = "li_mirror", type = "item"},
    {amount = 5, name = "iron-plate", type = "item"},
    {amount = 20, name = "iron-stick", type = "item"},
    {amount = 1, name = "electronic-circuit", type = "item"}
}
LargeMirrorRecipe.results = {
    {amount = 1, name = "li_large-mirror", type = "item"}
}
LargeMirrorRecipe.enabled = false
data:extend{LargeMirrorRecipe}

local Mirrors = {}
Mirrors.name = "li_mirrors"
Mirrors.type = "technology"
---@cast Mirrors data.TechnologyPrototype
Mirrors.icons = {
    {
        icon = image("__base__/graphics/technology/space-science-pack.png"),
        icon_size = 256,
        tint = {r = 0.500, g = 0.500, b = 0.500, a = 0.750}
    }
}
Mirrors.effects = {
    {type = "unlock-recipe", recipe = "li_mirror"},
    {type = "unlock-recipe", recipe = "li_large-mirror"}
}
Mirrors.unit = {
    ingredients = {{"automation-science-pack", 1}},
    time = 45,
    count = 300
}
Mirrors.prerequisites = {"li_advanced-copper-processing", "automation-science-pack", "li_scientific-equipment"}
data:extend{Mirrors}

local SolarCollectionRecipeCategory = {}
SolarCollectionRecipeCategory.name = "solar-collection"
SolarCollectionRecipeCategory.type = "recipe-category"
data:extend{SolarCollectionRecipeCategory}

---@type data.AssemblingMachinePrototype
local SolarCollector = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"])
SolarCollector.name = "li_solar-collector"
SolarCollector.energy_source.type = "solar"
SolarCollector.energy_source.emissions_per_minute["pollution"] = 0
SolarCollector.minable.result = "li_solar-collector"
SolarCollector.fixed_recipe = "li_solar-light-collection"
SolarCollector.crafting_categories = {"solar-collection"}
SolarCollector.light_output = true
SolarCollector.crafting_speed = 1
SolarCollector.module_slots = 0
SolarCollector.no_ams = (mods["QualityAssurance"] == nil) and nil or true
SolarCollector.fluid_boxes_off_when_no_fluid_recipe = false
-- SolarCollector.collision_box = {left_top = {-2.35, -2.35}, right_bottom = {2.35, 2.35}}
SolarCollector.next_upgrade = nil
SolarCollector.fast_replaceable_group = nil
data:extend{SolarCollector}

local SolarCollectorItem = table.deepcopy(data.raw["item"]["assembling-machine-2"])
SolarCollectorItem.name = "li_solar-collector"
SolarCollectorItem.order = "bb[li_solar-collector]"
SolarCollectorItem.place_result = "li_solar-collector"
data:extend{SolarCollectorItem}

local SolarCollectionRecipe = {}
SolarCollectionRecipe.name = "li_solar-light-collection"
SolarCollectionRecipe.type = "recipe"
---@cast SolarCollectionRecipe data.RecipePrototype
SolarCollectionRecipe.ingredients = {}
SolarCollectionRecipe.results = {
    {type = "light", name = "solar"}
}
SolarCollectionRecipe.category = "solar-collection"
SolarCollectionRecipe.icon = image("__core__/graphics/empty.png")
SolarCollectionRecipe.energy_required = 0.01
SolarCollectionRecipe.hidden = true
SolarCollectionRecipe.hidden_in_factoriopedia = true
data:extend{SolarCollectionRecipe}

local SolarCollectorRecipe = {}
SolarCollectorRecipe.name = "li_solar-collector"
SolarCollectorRecipe.type = "recipe"
---@cast SolarCollectorRecipe data.RecipePrototype
SolarCollectorRecipe.ingredients = {
    {amount = 26, name = "li_mirror", type = "item"},
    {amount = 24, name = "iron-plate", type = "item"},
    {amount = 15, name = "iron-stick", type = "item"},
    {amount =  9, name = "electronic-circuit", type = "item"}
}
SolarCollectorRecipe.results = {
    {amount = 1, name = "li_solar-collector", type = "item"}
}
SolarCollectorRecipe.enabled = false
data:extend{SolarCollectorRecipe}

local SolarCollection = {}
SolarCollection.name = "li_solar-collection"
SolarCollection.type = "technology"
---@cast SolarCollection data.TechnologyPrototype
SolarCollection.icon = image("__base__/graphics/technology/solar-energy.png")
SolarCollection.icon_size = 256
SolarCollection.effects = {
    {type = "unlock-recipe", recipe = "li_solar-collector"}
}
SolarCollection.unit = {
    ingredients = {{"automation-science-pack", 1}},
    time = 30,
    count = 275
}
SolarCollection.prerequisites = {"li_mirrors", "automation-science-pack", "li_advanced-copper-processing"}
data:extend{SolarCollection}

make_light({r = 1, g = 0.8, b = 0.5}, "solar", {player = "low", other = "none"})

local IndustrialGradeChromomixtureBase = {}
IndustrialGradeChromomixtureBase.name = "li_chromomixture-2-base"
IndustrialGradeChromomixtureBase.type = "item"
IndustrialGradeChromomixtureBase.stack_size = 50
---@cast IndustrialGradeChromomixtureBase data.ItemPrototype
IndustrialGradeChromomixtureBase.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.525, g = 0.575, b = 0.730, a = 1}
    }
}
IndustrialGradeChromomixtureBase.auto_recycle = mods["quality"] and false or nil
IndustrialGradeChromomixtureBase.order = "fa[li_chromomixture-2-base]"
IndustrialGradeChromomixtureBase.subgroup = "li_glass-products"
data:extend{IndustrialGradeChromomixtureBase}

local IndustrialGradeChromomixtureBaseRecipe = {}
IndustrialGradeChromomixtureBaseRecipe.name = "li_chromomixture-2-base"
IndustrialGradeChromomixtureBaseRecipe.type = "recipe"
---@cast IndustrialGradeChromomixtureBaseRecipe data.RecipePrototype
IndustrialGradeChromomixtureBaseRecipe.ingredients = {
    {amount =   6, name = "li_hot-glass", type = "item"},
    {amount =  13, name = "li_sand", type = "item"},
    {amount = 100, name = "water", type = "fluid"},
    {amount =   3, name = "li_electric-nickel-powder", type = "item"}
}
IndustrialGradeChromomixtureBaseRecipe.results = {
    {amount = 18, name = "li_chromomixture-2-base", type = "item"}
}
IndustrialGradeChromomixtureBaseRecipe.category = "crafting-with-fluid"
IndustrialGradeChromomixtureBaseRecipe.energy_required = 30
IndustrialGradeChromomixtureBaseRecipe.enabled = false
data:extend{IndustrialGradeChromomixtureBaseRecipe}

local IndustrialGradeChromomixture = {}
IndustrialGradeChromomixture.name = "li_chromomixture-2"
IndustrialGradeChromomixture.type = "item"
IndustrialGradeChromomixture.stack_size = 50
---@cast IndustrialGradeChromomixture data.ItemPrototype
IndustrialGradeChromomixture.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.457, g = 0.507, b = 0.640, a = 1}
    }
}
IndustrialGradeChromomixture.auto_recycle = mods["quality"] and false or nil
IndustrialGradeChromomixture.order = "d[li_chromomixture-2]"
IndustrialGradeChromomixture.subgroup = "li_glass-products"
data:extend{IndustrialGradeChromomixture}

local IndustrialGradeChromomixtureRecipe = {}
IndustrialGradeChromomixtureRecipe.name = "li_chromomixture-2"
IndustrialGradeChromomixtureRecipe.type = "recipe"
---@cast IndustrialGradeChromomixtureRecipe data.RecipePrototype
IndustrialGradeChromomixtureRecipe.ingredients = {
    {amount =  5, name = "li_chromomixture-2-base", type = "item"},
    {amount = 30, name = "li_silver-solution", type = "fluid"},
    {amount =  2, name = "li_hot-glass", type = "item"},
    {amount =  9, name = "li_sand", type = "item"}
}
IndustrialGradeChromomixtureRecipe.results = {
    {amount = 11, name = "li_chromomixture-2", type = "item"}
}
IndustrialGradeChromomixtureRecipe.category = "crafting-with-fluid"
IndustrialGradeChromomixtureRecipe.energy_required = 32
IndustrialGradeChromomixtureRecipe.enabled = false
data:extend{IndustrialGradeChromomixtureRecipe}

local Chromomixture2Category = {}
Chromomixture2Category.name = "li_chromomixture-2"
Chromomixture2Category.type = "item-subgroup"
Chromomixture2Category.group = "intermediate-products"
Chromomixture2Category.order = "xzzzzzzb"
data:extend{Chromomixture2Category}

local MundaneExposedChromomixtureRecipe2 = {}
MundaneExposedChromomixtureRecipe2.name = "li_exposed-chromomixture-1b"
MundaneExposedChromomixtureRecipe2.type = "recipe"
---@cast MundaneExposedChromomixtureRecipe2 data.RecipePrototype
MundaneExposedChromomixtureRecipe2.ingredients = {
    {amount = 15, name = "li_chromomixture-2", type = "item"}
}
MundaneExposedChromomixtureRecipe2.results = {
    {amount = 15, name = "li_exposed-chromomixture-1", type = "item"}
}
MundaneExposedChromomixtureRecipe2.category = "light-exposure"
MundaneExposedChromomixtureRecipe2.required_light = {light_type = "none", amount = 0, specific_direction = false}
MundaneExposedChromomixtureRecipe2.energy_required = 200
MundaneExposedChromomixtureRecipe2.subgroup = "li_chromomixture-2"
MundaneExposedChromomixtureRecipe2.order = "a[li_exposed-chromomixture-1b]"
MundaneExposedChromomixtureRecipe2.enabled = false
data:extend{MundaneExposedChromomixtureRecipe2}

local BetterChromomixture = {}
BetterChromomixture.name = "li_better-chromomixture"
BetterChromomixture.type = "technology"
---@cast BetterChromomixture data.TechnologyPrototype
BetterChromomixture.icons = {
    {
        icon = image("__base__/graphics/technology/space-science-pack.png"),
        icon_size = 256,
        tint = {r = 0.588, g = 0.588, b = 0.588, a = 1.000}
    }
}
BetterChromomixture.effects = {
    {type = "unlock-recipe", recipe = "li_chromomixture-2-base"},
    {type = "unlock-recipe", recipe = "li_chromomixture-2"},
    {type = "unlock-recipe", recipe = "li_exposed-chromomixture-1b"}
}
BetterChromomixture.unit = {
    ingredients = {{"automation-science-pack", 1}},
    count = 350,
    time = 50
}
BetterChromomixture.prerequisites = {"automation-science-pack", "li_advanced-iron-processing", "li_advanced-copper-processing"}
data:extend{BetterChromomixture}

local SolarExposedChromomixture = {}
SolarExposedChromomixture.name = "li_exposed-chromomixture-2"
SolarExposedChromomixture.type = "item"
SolarExposedChromomixture.stack_size = IndustrialGradeChromomixture.stack_size
---@cast SolarExposedChromomixture data.ItemPrototype
SolarExposedChromomixture.auto_recycle = false
SolarExposedChromomixture.order = "b[li_exposed-chromomixture-2]"
SolarExposedChromomixture.subgroup = "li_chromomixture-2"
SolarExposedChromomixture.icons = {
    {
        icon = image("__Lightorio__/graphics/icons/sand.png"),
        tint = {r = 0.972, g = 0.941, b = 0.360, a = 1.000}
    }
}
data:extend{SolarExposedChromomixture}

local SolarExposedChromomixtureRecipe = {}
SolarExposedChromomixtureRecipe.name = "li_exposed-chromomixture-2"
SolarExposedChromomixtureRecipe.type = "recipe"
---@cast SolarExposedChromomixtureRecipe data.RecipePrototype
SolarExposedChromomixtureRecipe.ingredients = {
    {amount = 15, name = "li_chromomixture-2", type = "item"}
}
SolarExposedChromomixtureRecipe.results = {
    {amount = 13, name = "li_exposed-chromomixture-2", type = "item"}
}
SolarExposedChromomixtureRecipe.category = "light-exposure"
SolarExposedChromomixtureRecipe.required_light = {light_type = "solar", amount = 1, specific_direction = false}
SolarExposedChromomixtureRecipe.energy_required = 140
SolarExposedChromomixtureRecipe.enabled = false
data:extend{SolarExposedChromomixtureRecipe}

local ThePowerOfTheSun = {}
ThePowerOfTheSun.name = "li_solar"
ThePowerOfTheSun.type = "produce-achievement"
---@cast ThePowerOfTheSun data.ProduceAchievementPrototype
ThePowerOfTheSun.limited_to_one_game = true
ThePowerOfTheSun.amount = 1
ThePowerOfTheSun.item_product = "li_exposed-chromomixture-2"
ThePowerOfTheSun.icon = image("__base__/graphics/achievement/research-with-logistics.png")
ThePowerOfTheSun.icon_size = 128
data:extend{ThePowerOfTheSun}

data.raw["technology"]["automation-2"].unit.ingredients = {{"automation-science-pack", 1}}
data.raw["technology"]["automation-2"].prerequisites = {"automation", "steel-processing", "automation-science-pack"}

data.raw["recipe"]["logistic-science-pack"].ingredients = {
    {amount = 125, name = "water", type = "fluid"},
    {amount =  19, name = "li_exposed-chromomixture-2", type = "item"},
    {amount =   2, name = "li_glass-bottle", type = "item"}
}
data.raw["recipe"]["logistic-science-pack"].results = {
    {amount = 2, name = "logistic-science-pack", type = "item"}
}
data.raw["recipe"]["logistic-science-pack"].category = "crafting-with-fluid"

data.raw["technology"]["logistic-science-pack"].effects = {
    {type = "unlock-recipe", recipe = "li_exposed-chromomixture-2"},
    {type = "unlock-recipe", recipe = "logistic-science-pack"}
}
data.raw["technology"]["logistic-science-pack"].icons = {
    {
        icon = image("__base__/graphics/technology/space-science-pack.png"),
        icon_size = 256,
        tint = {r = 0.972, g = 0.941, b = 0.360, a = 1.000}
    }
}

data.raw["technology"]["logistic-science-pack"].prerequisites = {"li_better-chromomixture", "li_solar-collection", "automation-science-pack", "automation-2"}

data.raw["research-with-science-pack-achievement"]["research-with-logistics"].icons = {
    {
        icon = image("__base__/graphics/achievement/research-with-space.png"),
        icon_size = 128,
        tint = {r = 0.972, g = 0.941, b = 0.360, a = 1.000}
    }
}

-- Solar science pack (yellow)
update_pack(
    data.raw["tool"]["logistic-science-pack"],
    {
        name = "li_solar-science-pack",
        colour = {r = 0.972, g = 0.941, b = 0.360, a = 1.000},
        order = "b"
    }
)

---@type data.BoilerPrototype
local SolarBoiler = table.deepcopy(data.raw["boiler"]["boiler"])
SolarBoiler.name = "li_solar-boiler"
SolarBoiler.energy_source.type = "solar"
SolarBoiler.energy_source.emissions_per_minute["pollution"] = 0
SolarBoiler.energy_consumption = "120kW"
SolarBoiler.minable.result = "li_solar-boiler"
data:extend{SolarBoiler}

---@type data.ItemPrototype
local SolarBoilerItem = table.deepcopy(data.raw["item"]["boiler"])
SolarBoilerItem.name = "li_solar-boiler"
SolarBoilerItem.order = "bzzzz[li_solar-boiler]"
SolarBoilerItem.place_result = "li_solar-boiler"
data:extend{SolarBoilerItem}

local SolarBoilerRecipe = {}
SolarBoilerRecipe.name = "li_solar-boiler"
SolarBoilerRecipe.type = "recipe"
---@cast SolarBoilerRecipe data.RecipePrototype
SolarBoilerRecipe.ingredients = {
    {amount =  2, name = "copper-plate", type = "item"},
    {amount = 10, name = "copper-cable", type = "item"},
    {amount =  1, name = "boiler", type = "item"},
    {amount =  4, name = "li_glass", type = "item"},
    {amount =  6, name = "steel-plate", type = "item"}
}
SolarBoilerRecipe.results = {
    {amount = 1, name = "li_solar-boiler", type = "item"}
}
data:extend{SolarBoilerRecipe}

local SolarBoiling = {}
SolarBoiling.name = "li_solar-boiling"
SolarBoiling.type = "technology"
---@cast SolarBoiling data.TechnologyPrototype
SolarBoiling.icon = image("__base__/graphics/technology/steam-power.png")
SolarBoiling.icon_size = 256
SolarBoiling.effects = {
    {type = "unlock-recipe", recipe = "li_solar-boiler"}
}
SolarBoiling.unit = {
    ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 2}},
    time = 75,
    count = 800
}
SolarBoiling.prerequisites = {"li_scientific-equipment", "logistic-science-pack", "steam-power", "li_photo-electrics", "solar-energy"}
data:extend{SolarBoiling}

-- Filtration science pack (orange)
update_pack(
    data.raw["tool"]["military-science-pack"],
    {
        name = "li_filtration-science-pack",
        colour = {r = 0.986, g = 0.547, b = 0.124, a = 1.000},
        order = "c"
    }
)

-- Artificial science pack (green)
update_pack(
    data.raw["tool"]["chemical-science-pack"],
    {
        name = "li_artificial-science-pack",
        colour = {r = 0.333, g = 0.956, b = 0.388, a = 1.000},
        order = "d"
    }
)

-- High-Frequency science pack (dark purple)
update_pack(
    data.raw["tool"]["production-science-pack"],
    {
        name = "li_high-freq-science-pack",
        colour = {r = 0.298, g = 0.143, b = 0.430, a = 1.000},
        order = "e"
    }
)

-- Low-Frequency science pack (dark red)
update_pack(
    data.raw["tool"]["utility-science-pack"],
    {
        name = "li_low-freq-science-pack",
        colour = {r = 0.455, g = 0.130, b = 0.096, a = 1.000},
        order = "e"
    }
)

-- Spectral science pack (rainbow)
update_pack(
    data.raw["tool"]["space-science-pack"],
    {
        name = "li_spectral-science-pack",
        icon = {
            icon = image("__Lightorio__/graphics/icons/bottle_filler_spectral.png")
        },
        order = "f"
    }
)

log(serpent.block(data.raw["technology"]["steam-power"]))