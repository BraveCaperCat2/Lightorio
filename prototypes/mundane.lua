require("prototypes.data-utils")

data.raw["recipe"]["iron-gear-wheel"].enabled = false

remove_effect(data.raw["technology"]["railway"], {type = "unlock-recipe", recipe = "iron-stick"})

remove_effect(data.raw["technology"]["steam-power"], {type = "unlock-recipe", recipe = "pipe"})
remove_effect(data.raw["technology"]["steam-power"], {type = "unlock-recipe", recipe = "pipe-to-ground"})

local Metallurgy = {}
Metallurgy.name = "li_metallurgy"
Metallurgy.type = "technology"
---@cast Metallurgy data.TechnologyPrototype
Metallurgy.icon = image("__base__/graphics/technology/automation-1.png")
Metallurgy.icon_size = 256
Metallurgy.effects = {
    {type = "unlock-recipe", recipe = "iron-gear-wheel"},
    {type = "unlock-recipe", recipe = "iron-stick"},
    {type = "unlock-recipe", recipe = "pipe"},
    {type = "unlock-recipe", recipe = "pipe-to-ground"},
}
Metallurgy.research_trigger = {type = "craft-item", item = "iron-plate", count = 25}
data:extend{Metallurgy}

remove_effect(data.raw["technology"]["fluid-handling"], {type = "unlock-recipe", recipe = "storage-tank"})
remove_effect(data.raw["technology"]["fluid-handling"], {type = "unlock-recipe", recipe = "pump"})

remove_effect(data.raw["technology"]["steam-power"], {type = "unlock-recipe", recipe = "offshore-pump"})

local BasicFluidHandling = {}
BasicFluidHandling.name = "li_basic-fluid-handling"
BasicFluidHandling.type = "technology"
---@cast BasicFluidHandling data.TechnologyPrototype
BasicFluidHandling.icon = image("__base__/graphics/technology/fluid-handling.png")
BasicFluidHandling.icon_size = 256
BasicFluidHandling.effects = {
    {type = "unlock-recipe", recipe = "storage-tank"},
    {type = "unlock-recipe", recipe = "pump"},
    {type = "unlock-recipe", recipe = "offshore-pump"}
}
BasicFluidHandling.research_trigger = {type = "craft-item", item = "pipe", count = 20}
BasicFluidHandling.prerequisites = {"li_metallurgy"}
data:extend{BasicFluidHandling}

data.raw["technology"]["steam-power"].prerequisites = data.raw["technology"]["steam-power"].prerequisites or {}

table.insert(data.raw["technology"]["steam-power"].prerequisites, "li_basic-fluid-handling")

data.raw["recipe"]["burner-mining-drill"].enabled = false

table.insert(data.raw["technology"]["electric-mining-drill"].prerequisites, "li_burner-mining")

local BurnerMining = {}
BurnerMining.name = "li_burner-mining"
BurnerMining.type = "technology"
---@cast BurnerMining data.TechnologyPrototype
BurnerMining.icon = image("__base__/graphics/technology/electric-mining-drill.png")
BurnerMining.icon_size = 256
BurnerMining.effects = {
    {type = "unlock-recipe", recipe = "burner-mining-drill"}
}
BurnerMining.research_trigger = {type = "craft-item", item = "coal", count = 50}
BurnerMining.prerequisites = {"li_metallurgy"}
data:extend{BurnerMining}

remove_effect(data.raw["technology"]["electronics"], {type = "unlock-recipe", recipe = "small-electric-pole"})
remove_effect(data.raw["technology"]["electronics"], {type = "unlock-recipe", recipe = "inserter"})

local ElectricInfrastructure = {}
ElectricInfrastructure.name = "li_electric-infrastructure"
ElectricInfrastructure.type = "technology"
---@cast ElectricInfrastructure data.TechnologyPrototype
ElectricInfrastructure.icon = image("__base__/graphics/technology/electric-energy-distribution-1.png")
ElectricInfrastructure.icon_size = 256
ElectricInfrastructure.effects = {
    {type = "unlock-recipe", recipe = "small-electric-pole"},
    {type = "unlock-recipe", recipe = "inserter"}
}
ElectricInfrastructure.research_trigger = {type = "craft-item", item = "electronic-circuit", count = 10}
ElectricInfrastructure.prerequisites = {"electronics", "li_metallurgy"}
data:extend{ElectricInfrastructure}

remove_effect(data.raw["technology"]["electronics"], {type = "unlock-recipe", recipe = "lab"})

data.raw["technology"]["automation"].unit = nil
data.raw["technology"]["automation"].research_trigger = {type = "craft-item", item = "inserter", count = 4}
data.raw["technology"]["automation"].prerequisites = {"li_electric-infrastructure", "li_metallurgy"}

data.raw["assembling-machine"]["assembling-machine-1"].fluid_boxes = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes)
data.raw["assembling-machine"]["assembling-machine-1"].fluid_boxes_off_when_no_fluid_recipe = true
data.raw["assembling-machine"]["assembling-machine-2"].fluid_boxes_off_when_no_fluid_recipe = false
data.raw["assembling-machine"]["assembling-machine-3"].fluid_boxes_off_when_no_fluid_recipe = false

local GlassProductsCategory = {}
GlassProductsCategory.name = "li_glass-products"
GlassProductsCategory.type = "item-subgroup"
GlassProductsCategory.group = "intermediate-products"
GlassProductsCategory.order = "c"
data:extend{GlassProductsCategory}

---@type data.ItemPrototype
local Sand = table.deepcopy(data.raw["item"]["stone"])
Sand.name = "li_sand"
Sand.pictures = nil
Sand.icon = image("__ModLightorio__/graphics/icons/sand.png")
Sand.auto_recycle = mods["quality"] and false or nil
Sand.order = "a[li_sand]"
Sand.subgroup = "li_glass-products"
Sand.weight = 200
data:extend{Sand}

local SandRecipe = {}
SandRecipe.name = "li_sand"
SandRecipe.type = "recipe"
---@cast SandRecipe data.RecipePrototype
SandRecipe.ingredients = {
    {amount = 2, name = "stone", type = "item"}
}
SandRecipe.results = {
    {amount = 5, name = "li_sand", type = "item"}
}
SandRecipe.energy_required = 2.6
SandRecipe.enabled = false
data:extend{SandRecipe}

---@type data.ItemPrototype
local Glass = table.deepcopy(data.raw["item"]["iron-plate"])
Glass.name = "li_glass"
Glass.icons = {
    {
        icon = image("__base__/graphics/icons/iron-plate.png"),
        tint = {r = 0.5, g = 0.5, b = 0.5, a = 0.099}
    }
}
Glass.auto_recycle = mods["quality"] and false or nil
Glass.order = "b[li_glass]"
Glass.subgroup = "li_glass-products"
Glass.weight = 585
data:extend{Glass}

local GlassRecipe = {}
GlassRecipe.name = "li_glass"
GlassRecipe.type = "recipe"
---@cast GlassRecipe data.RecipePrototype
GlassRecipe.ingredients = {
    {amount = 3, name = "li_sand", type = "item"}
}
GlassRecipe.results = {
    {amount = 1, name = "li_glass", type = "item"}
}
GlassRecipe.category = "smelting"
GlassRecipe.energy_required = 7
GlassRecipe.enabled = false
data:extend{GlassRecipe}

---@type data.ItemPrototype
local HotGlass = table.deepcopy(data.raw["item"]["iron-plate"])
HotGlass.name = "li_hot-glass"
HotGlass.icons = {
    {
        icon = image("__base__/graphics/icons/copper-plate.png"),
        tint = {r = 1, g = 0.939, b = 0.103, a = 1}
    }
}
HotGlass.auto_recycle = mods["quality"] and false or nil
HotGlass.order = "c[li_hot-glass]"
HotGlass.subgroup = "li_glass-products"
data:extend{HotGlass}

local HotGlassRecipe = {}
HotGlassRecipe.name = "li_hot-glass"
HotGlassRecipe.type = "recipe"
---@cast HotGlassRecipe data.RecipePrototype
HotGlassRecipe.ingredients = {
    {amount = 9, name = "li_glass", type = "item"}
}
HotGlassRecipe.results = {
    {amount = 8, name = "li_hot-glass", type = "item"}
}
HotGlassRecipe.category = "smelting"
HotGlassRecipe.energy_required = 10
HotGlassRecipe.enabled = false
data:extend{HotGlassRecipe}

local LowGradeChromomixture = {}
LowGradeChromomixture.name = "li_chromomixture-1"
LowGradeChromomixture.type = "item"
LowGradeChromomixture.stack_size = 25
---@cast LowGradeChromomixture data.ItemPrototype
LowGradeChromomixture.icons = {
    {
        icon = image("__ModLightorio__/graphics/icons/sand.png"),
        tint = {r = 0.457, g = 0.507, b = 0.640, a = 1}
    }
}
LowGradeChromomixture.auto_recycle = mods["quality"] and false or nil
LowGradeChromomixture.order = "d[li_chromomixture-1]"
LowGradeChromomixture.subgroup = "li_glass-products"
data:extend{LowGradeChromomixture}

data:extend{{name = "basic-crafting-with-fluid", type = "recipe-category"}}

table.insert(data.raw["assembling-machine"]["assembling-machine-1"].crafting_categories, "basic-crafting-with-fluid")
table.insert(data.raw["assembling-machine"]["assembling-machine-2"].crafting_categories, "basic-crafting-with-fluid")
table.insert(data.raw["assembling-machine"]["assembling-machine-3"].crafting_categories, "basic-crafting-with-fluid")

local LowGradeChromomixtureRecipe = {}
LowGradeChromomixtureRecipe.name = "li_chromomixture-1"
LowGradeChromomixtureRecipe.type = "recipe"
---@cast LowGradeChromomixtureRecipe data.RecipePrototype
LowGradeChromomixtureRecipe.ingredients = {
    {amount =   4, name = "li_hot-glass", type = "item"},
    {amount =  17, name = "li_sand", type = "item"},
    {amount = 125, name = "water", type = "fluid"},
    {amount =   1, name = "copper-ore", type = "item"}
}
LowGradeChromomixtureRecipe.results = {
    {amount = 12, name = "li_chromomixture-1", type = "item"}
}
LowGradeChromomixtureRecipe.category = "basic-crafting-with-fluid"
LowGradeChromomixtureRecipe.energy_required = 30
LowGradeChromomixtureRecipe.enabled = false
data:extend{LowGradeChromomixtureRecipe}

local GlassBottle = {}
GlassBottle.name = "li_glass-bottle"
GlassBottle.type = "item"
GlassBottle.stack_size = 50
---@cast GlassBottle data.ItemPrototype
GlassBottle.order = "e[li_glass-bottle]"
GlassBottle.subgroup = "li_glass-products"
GlassBottle.icons = {
    {
        icon = image("__ModLightorio__/graphics/icons/glass_bottle.png")
    }
}
data:extend{GlassBottle}

local GlassBottleRecipe = {}
GlassBottleRecipe.name = "li_glass-bottle"
GlassBottleRecipe.type = "recipe"
---@cast GlassBottleRecipe data.RecipePrototype
GlassBottleRecipe.ingredients = {
    {amount =   3, name = "li_hot-glass", type = "item"},
    {amount = 100, name = "water", type = "fluid"}
}
GlassBottleRecipe.results = {
    {amount = 1, name = "li_glass-bottle", type = "item"}
}
GlassBottleRecipe.category = "basic-crafting-with-fluid"
GlassBottleRecipe.energy_required = 24
GlassBottleRecipe.enabled = false
data:extend{GlassBottleRecipe}

data.raw["recipe"]["lab"].ingredients = {
    {amount = 30, name = "iron-stick", type = "item"},
    {amount = 10, name = "li_glass", type = "item"},
    {amount = 15, name = "electronic-circuit", type = "item"},
    {amount = 8, name = "transport-belt", type = "item"},
    {amount = 20, name = "iron-gear-wheel", type = "item"}
}

local ScientificEquipment = {}
ScientificEquipment.name = "li_scientific-equipment"
ScientificEquipment.type = "technology"
---@cast ScientificEquipment data.TechnologyPrototype
ScientificEquipment.icons = {
    {
        icon = image("__base__/graphics/technology/space-science-pack.png"),
        icon_size = 256,
        tint = {r = 0.500, g = 0.500, b = 0.500, a = 0.750}
    }
}
ScientificEquipment.effects = {
    {type = "unlock-recipe", recipe = "lab"},
    {type = "unlock-recipe", recipe = "li_sand"},
    {type = "unlock-recipe", recipe = "li_glass"},
    {type = "unlock-recipe", recipe = "li_hot-glass"},
    {type = "unlock-recipe", recipe = "li_glass-bottle"},
    {type = "unlock-recipe", recipe = "li_chromomixture-1"}
}
ScientificEquipment.research_trigger = {type = "craft-item", item = "stone", count = 60}
ScientificEquipment.prerequisites = {"automation", "steam-power", "li_electric-infrastructure"}
data:extend{ScientificEquipment}

local LightExposure = {}
LightExposure.name = "light-exposure"
LightExposure.type = "recipe-category"
data:extend{LightExposure}

---@type data.AssemblingMachinePrototype
local ExposureChamber = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-1"])
ExposureChamber.name = "li_exposure-chamber"
ExposureChamber.crafting_categories = {"light-exposure"}
ExposureChamber.fluid_boxes = nil
ExposureChamber.fluid_boxes_off_when_no_fluid_recipe = true
if mods["QualityAssurance"] then
    ExposureChamber.no_ams = true
    ExposureChamber.no_bq = true
end
ExposureChamber.allowed_effects = {}
ExposureChamber.crafting_speed = 1
ExposureChamber.minable = {count = 1, mining_time = data.raw["assembling-machine"]["assembling-machine-1"].minable.mining_time, result = "li_exposure-chamber"}
data:extend{ExposureChamber}

local ExposureChamberItem = table.deepcopy(data.raw["item"]["assembling-machine-1"])
ExposureChamberItem.name = "li_exposure-chamber"
ExposureChamberItem.order = "az[li_exposure-chamber]"
ExposureChamberItem.place_result = "li_exposure-chamber"
data:extend{ExposureChamberItem}

local ExposureChamberRecipe = {}
ExposureChamberRecipe.name = "li_exposure-chamber"
ExposureChamberRecipe.type = "recipe"
---@cast ExposureChamberRecipe data.RecipePrototype
ExposureChamberRecipe.ingredients = {
    {amount = 40, name = "li_glass", type = "item"},
    {amount = 25, name = "iron-gear-wheel", type = "item"},
    {amount = 10, name = "electronic-circuit", type = "item"},
    {amount = 32, name = "iron-plate", type = "item"}
}
ExposureChamberRecipe.results = {
    {amount = 1, name = "li_exposure-chamber", type = "item"}
}
ExposureChamberRecipe.energy_required = 6
ExposureChamberRecipe.enabled = false
data:extend{ExposureChamberRecipe}

local ChromomixtureCategory = {}
ChromomixtureCategory.name = "li_chromomixture"
ChromomixtureCategory.type = "item-subgroup"
ChromomixtureCategory.group = "intermediate-products"
ChromomixtureCategory.order = "xzzzzzza"
data:extend{ChromomixtureCategory}

local MundaneExposedChromomixture = {}
MundaneExposedChromomixture.name = "li_exposed-chromomixture-1"
MundaneExposedChromomixture.type = "item"
MundaneExposedChromomixture.stack_size = LowGradeChromomixture.stack_size
---@cast MundaneExposedChromomixture data.ItemPrototype
MundaneExposedChromomixture.auto_recycle = false
MundaneExposedChromomixture.order = "a[li_exposed-chromomixture-1]"
MundaneExposedChromomixture.subgroup = "li_chromomixture"
MundaneExposedChromomixture.icons = {
    {
        icon = image("__ModLightorio__/graphics/icons/sand.png"),
        tint = {r = 0.714, g = 0.793, b = 1.000, a = 1}
    }
}
data:extend{MundaneExposedChromomixture}

local MundaneExposedChromomixtureRecipe = {}
MundaneExposedChromomixtureRecipe.name = "li_exposed-chromomixture-1"
MundaneExposedChromomixtureRecipe.type = "recipe"
---@cast MundaneExposedChromomixtureRecipe data.RecipePrototype
MundaneExposedChromomixtureRecipe.ingredients = {
    {amount = 15, name = "li_chromomixture-1", type = "item"}
}
MundaneExposedChromomixtureRecipe.results = {
    {amount = 15, name = "li_exposed-chromomixture-1", type = "item"}
}
MundaneExposedChromomixtureRecipe.category = "light-exposure"
MundaneExposedChromomixtureRecipe.required_light = {light_type = "none", amount = 0, specific_direction = false}
MundaneExposedChromomixtureRecipe.energy_required = 240
MundaneExposedChromomixtureRecipe.enabled = false
data:extend{MundaneExposedChromomixtureRecipe}

local WhoLeftTheShutterOpen = {}
WhoLeftTheShutterOpen.name = "li_overexposure"
WhoLeftTheShutterOpen.type = "produce-achievement"
---@cast WhoLeftTheShutterOpen data.ProduceAchievementPrototype
WhoLeftTheShutterOpen.limited_to_one_game = true
WhoLeftTheShutterOpen.amount = 1
WhoLeftTheShutterOpen.item_product = "li_exposed-chromomixture-1"
WhoLeftTheShutterOpen.icon = image("__base__/graphics/achievement/research-with-automation.png")
WhoLeftTheShutterOpen.icon_size = 128
data:extend{WhoLeftTheShutterOpen}

data.raw["recipe"]["automation-science-pack"].ingredients = {
    {amount = 125, name = "water", type = "fluid"},
    {amount =   9, name = "li_exposed-chromomixture-1", type = "item"},
    {amount =   2, name = "li_glass-bottle", type = "item"}
}
data.raw["recipe"]["automation-science-pack"].results = {
    {amount = 2, name = "automation-science-pack", type = "item"}
}
data.raw["recipe"]["automation-science-pack"].category = "basic-crafting-with-fluid"

data.raw["technology"]["automation-science-pack"].research_trigger = {type = "craft-item", item = "li_chromomixture-1", amount = 1}
data.raw["technology"]["automation-science-pack"].effects = {
    {type = "unlock-recipe", recipe = "li_exposure-chamber"},
    {type = "unlock-recipe", recipe = "li_exposed-chromomixture-1"},
    {type = "unlock-recipe", recipe = "automation-science-pack"}
}
data.raw["technology"]["automation-science-pack"].icons = {
    {
        icon = image("__base__/graphics/technology/space-science-pack.png"),
        icon_size = 256,
        tint = {r = 0.588, g = 0.588, b = 0.588, a = 1.000}
    }
}

data.raw["technology"]["automation-science-pack"].prerequisites = {"li_scientific-equipment", "automation", "li_electric-infrastructure"}

data.raw["research-with-science-pack-achievement"]["research-with-automation"].icons = {
    {
        icon = image("__base__/graphics/achievement/research-with-space.png"),
        icon_size = 128,
        tint = {r = 0.588, g = 0.588, b = 0.588, a = 1.000}
    }
}