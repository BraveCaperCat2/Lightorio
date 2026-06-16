require("utils")

local ExposureData = {}
ExposureData.name = "li_exposure-data"
ExposureData.type = "mod-data"
---@cast ExposureData data.ModData
ExposureData.data = {}

for _,recipe in pairs(data.raw["recipe"]) do
    if recipe.required_light then
        ExposureData.data[recipe.name] = recipe.required_light
    end
end

data:extend{ExposureData}

local SolarData = {}
SolarData.name = "li_solar-data"
SolarData.type = "mod-data"
---@cast SolarData data.ModData
SolarData.data = {}

local MachineTypes = {"assembling-machine", "furnace", "rocket-silo", "boiler"}

for _,machine_type in pairs(MachineTypes) do
    for _,machine in pairs(data.raw[machine_type]) do
        if machine.energy_source.type == "solar" then
            SolarData.data[machine.name] = true
            machine.energy_source.type = "void"
        end
    end
end

data:extend{SolarData}

local LightData = {}
LightData.name = "li_light-data"
LightData.type = "mod-data"
---@cast LightData data.ModData
LightData.data = {recipe = {}, machine = {}}

for _,machine_type in pairs(MachineTypes) do
    for _,machine in pairs(data.raw[machine_type]) do
        if machine.type == "boiler" then
            goto continue
        end
        LightData.data["machine"][machine.name] = {active = machine.light_output or false, offset = machine.light_offset or 0, rotation = machine.light_direction or 0}
        ::continue::
    end
end

for _,recipe in pairs(data.raw["recipe"]) do
    local to_remove
    for i,result in pairs(recipe.results or {}) do
        if result.type == "light" then
            LightData.data["recipe"][recipe.name] = {active = true, light = result.name}
            to_remove = i
            break
        end
    end

    if to_remove == nil then
        goto continue
    end

    table.remove(recipe.results, to_remove)
    ::continue::
end

data:extend{LightData}

for _,machine_type in pairs(MachineTypes) do
    for _,machine in pairs(data.raw[machine_type]) do
        if not is_in(machine.flags, "get-by-unit-number") then
            table.insert(machine.flags, "get-by-unit-number")
        end
    end
end

local HazardData = {}
HazardData.name = "li_hazard-data"
HazardData.type = "mod-data"
---@cast HazardData data.ModData
HazardData.data = {}

for _,simple_entity_with_owner in pairs(data.raw["simple-entity-with-owner"]) do
    if simple_entity_with_owner.hazard_properties then
        HazardData.data[simple_entity_with_owner.name] = simple_entity_with_owner.hazard_properties
    end
end

data:extend{HazardData}