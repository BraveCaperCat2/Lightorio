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

require("prototypes.solar")

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