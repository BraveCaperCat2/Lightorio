-- Enable/disable placeholder graphics
-- Does not work if the placeholder graphics are not present, which will be the case in the released version
-- Remember to set this to false before releasing the mod
local use_prerelease_placeholder_graphics = false

-- Modifies paths to point to placeholder graphics if applicable
---@param path data.FileName
---@return data.FileName
function image(path)
    if use_prerelease_placeholder_graphics and string.find(path, "^__Lightorio__") then
        return (string.gsub(path, "/([a-zA-Z0-9_-]+)%.png$", "/delete_before_upload/%1.png", 1))
    end
    return path
end

-- Renames a science pack externally, sets a new icon and changes the order.
---@param old_pack data.ToolPrototype
---@param new_info {name: string, order: string, icon: data.IconData?, colour: data.Color?}
---@return nil
function update_pack(old_pack, new_info)
    old_pack.localised_name = {"item-name." .. new_info.name}
    old_pack.localised_description = {"item-description." .. new_info.name}
    old_pack.order = new_info.order .. "[" .. new_info.name .. "]"

    if new_info.icon then
        old_pack.icons = {
            {
                icon = image("__Lightorio__/graphics/icons/glass_bottle.png")
            },
            new_info.icon
        }
    else
        old_pack.icons = {
            {
                icon = image("__Lightorio__/graphics/icons/glass_bottle.png")
            },
            {
                icon = image("__Lightorio__/graphics/icons/bottle_filler.png"),
                tint = new_info.colour
            }
        }
    end
end

-- Removes an effect from a technology
---@param tech data.TechnologyPrototype
---@param effect data.Modifier
---@return nil
function remove_effect(tech, effect)
    local soft_remove = {}
    for i,other_effect in pairs(tech.effects) do
        if table.compare(effect, other_effect) then
            table.remove(tech.effects, i)
            break
        end
    end
end

local FakeLight = {}
FakeLight.name = "li_fake-light"
FakeLight.type = "simple-entity-with-owner"
FakeLight.picture = {
        east = table.deepcopy(data.raw["pipe"]["pipe"].pictures.straight_horizontal),
        north = table.deepcopy(data.raw["pipe"]["pipe"].pictures.straight_vertical_single),
        west = table.deepcopy(data.raw["pipe"]["pipe"].pictures.straight_horizontal),
        south = table.deepcopy(data.raw["pipe"]["pipe"].pictures.straight_vertical_single)
    }

FakeLight.collision_box = {left_top = {-0.4, -0.4}, right_bottom = {0.4, 0.4}}
FakeLight.collision_mask = {
    layers = {
        is_lower_object = true,
        object = true
    }
}

FakeLight.selection_box = {left_top = {-0.5, -0.5}, right_bottom = {0.5, 0.5}}
FakeLight.flags = {
    "not-rotatable",
    "placeable-neutral",
    "player-creation",
    "get-by-unit-number",
    "not-repairable",
    "not-deconstructable",
    "not-blueprintable",
    "not-upgradable",
    "not-in-kill-statistics",
    "not-in-made-in"
}

FakeLight.icon = "__base__/graphics/icons/pipe.png"

for _,sprite in pairs(FakeLight.picture) do
    sprite.tint = {r = 0, g = 0, b = 0, a = 1}
end

FakeLight.hidden = true
FakeLight.hidden_in_factoriopedia = true

data:extend{FakeLight}

function make_light(colour, name, hazard_info)
    local Light = {}
    Light.name = "li_light-" .. name
    Light.type = "simple-entity-with-owner"
    ---@diagnostic disable-next-line: unknown-cast-variable
    ---@cast Light data.SimpleEntityWithOwnerPrototype
    
    local HorizontalBase = image("__Lightorio__/graphics/entity/light_horizontal.png")
    local EastOverlay = image("__Lightorio__/graphics/entity/light_overlay_east.png")
    local WestOverlay = image("__Lightorio__/graphics/entity/light_overlay_west.png")
    local VerticalBase = image("__Lightorio__/graphics/entity/light_vertical.png")
    local NorthOverlay = image("__Lightorio__/graphics/entity/light_overlay_north.png")
    local SouthOverlay = image("__Lightorio__/graphics/entity/light_overlay_south.png")
    
    Light.picture = {
        east = {
            layers = {
                {filename = HorizontalBase, tint = colour, height = 128, width = 128, scale = 0.25},
                {filename = EastOverlay, height = 128, width = 128, scale = 0.25}
            },
            height = 128,
            width = 128
        },
        north = {
            layers = {
                {filename = VerticalBase, tint = colour, height = 128, width = 128, scale = 0.25},
                {filename = NorthOverlay, height = 128, width = 128, scale = 0.25}
            },
            height = 128,
            width = 128
        },
        west = {
            layers = {
                {filename = HorizontalBase, tint = colour, height = 128, width = 128, scale = 0.25},
                {filename = WestOverlay, height = 128, width = 128, scale = 0.25}
            },
            height = 128,
            width = 128
        },
        south = {
            layers = {
                {filename = VerticalBase, tint = colour, height = 128, width = 128, scale = 0.25},
                {filename = SouthOverlay, height = 128, width = 128, scale = 0.25}
            },
            height = 128,
            width = 128
        }
    }

    Light.collision_box = {left_top = {-0.4, -0.4}, right_bottom = {0.4, 0.4}}
    Light.collision_mask = {
        layers = {}
    }

    Light.selection_box = {left_top = {-0.5, -0.5}, right_bottom = {0.5, 0.5}}
    --[[ Light.flags = {
        "not-rotatable",
        "placeable-neutral",
        "player-creation",
        "get-by-unit-number",
        "not-repairable",
        "not-deconstructable",
        "not-blueprintable",
        "not-upgradable",
        "not-in-kill-statistics",
        "not-in-made-in"
    } ]]--

    Light.hazard_properties = hazard_info

    Light.icon = "__base__/graphics/icons/pipe.png"

    Light.hidden = true
    Light.hidden_in_factoriopedia = true

    data:extend{Light}
end