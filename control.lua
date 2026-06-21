require("utils")

function on_init()
    -- Configure starting resources
    if not remote.interfaces["freeplay"] then
        return
    end
    remote.call("freeplay", "set_created_items", {
        ["iron-plate"] = 8,
        ["wood"] = 4,
        ["pistol"] = 1,
        ["firearm-magazine"] = 30
    })

    load_prototype_data()
end

-- Setup storage variables
function setup()
    storage.tracked_light_entities = {}
    storage.cached_entities = {}
end

function load_prototype_data()
    ---@type table<RecipeID, {light_type: string, amount: int64, specific_direction: defines.direction|false}?>
    storage.exposure_data_table = prototypes.mod_data["li_exposure-data"].data
    ---@type table<EntityID, true?>
    storage.solar_data_table = prototypes.mod_data["li_solar-data"].data
    ---@type table<EntityID, {active: boolean, offset: int64, rotation: defines.direction}?>
    storage.machine_light_data_table = prototypes.mod_data["li_light-data"].data["machine"]
    ---@type table<RecipeID, {active: true, light: string}?>
    storage.recipe_light_data_table = prototypes.mod_data["li_light-data"].data["recipe"]
    ---@type table<EntityID, {player: string, other: string}?>
    storage.hazard_data_table = prototypes.mod_data["li_hazard-data"].data
end

script.on_init(function()
    on_init()
    setup()
end)
script.on_configuration_changed(on_init)

-- Runs every tick
function on_tick(event)
    local machines = get_entities_with_type({["assembling-machine"] = true, ["furnace"] = true, ["rocket-silo"] = true, ["boiler"] = true})

    local ExposureDataTable = storage.exposure_data_table
    local SolarDataTable = storage.solar_data_table
    local MachineLightDataTable = storage.machine_light_data_table
    local RecipeLightDataTable = storage.recipe_light_data_table
    local HazardDataTable = storage.hazard_data_table

    if not ExposureDataTable or not SolarDataTable or not MachineLightDataTable or not RecipeLightDataTable or not HazardDataTable then
        load_prototype_data()
        ExposureDataTable = storage.exposure_data_table
        SolarDataTable = storage.solar_data_table
        MachineLightDataTable = storage.machine_light_data_table
        RecipeLightDataTable = storage.recipe_light_data_table
        HazardDataTable = storage.hazard_data_table
    end

    for _,machine in pairs(machines) do
        -- Check that the machine is valid
        if not (machine.valid) then
            goto next4
        end

        -- Store a reference to the machine's surface
        local surface = machine.surface

        -- Day-night cycle stuff
        local is_day = false
        if surface.always_day then
            is_day = true
        end

        local time = surface.daytime
        local prop = surface.daytime_parameters

        local factor = 0.75

        if interpolation(prop.dawn, prop.morning, factor) < time or time < interpolation(prop.dusk, prop.evening, factor) then
            is_day = true
        end

        -- Set up variables for disabling machines
        local disable_machine = false
        local reasons = {}

        local output_light_type_if_any = false

        -- Only do light exposure calculations if the machine is one of the supported types
        if not is_in_cheaper({["assembling-machine"] = true, furnace = true, ["rocket-silo"] = true}, machine.type) then
            goto next1
        else

        local recipe = machine.get_recipe()
        if recipe == nil then
            goto next1
        end

        -- Load in exposure data
        local ExposureData = ExposureDataTable[recipe.name]
        if not ExposureData or ExposureData.light_type == "none" then
            goto next1
        end
        
        -- Direction stuff
        local position = machine.position

        local top_left
        local bottom_right

        local machine_box = machine.prototype.collision_box

        if ExposureData.specific_direction == false then
            top_left = {x = machine_box["left_top"]["x"] - 1, y = machine_box["left_top"]["y"] - 1}
            bottom_right = {x = machine_box["right_bottom"]["x"] + 1, y = machine_box["right_bottom"]["y"] + 1}
        else
            local direction = add_directions(handle_mirroring(ExposureData.specific_direction, machine.mirroring), machine.direction)
            if direction == defines.direction.east then
                top_left = {x = machine_box["right_bottom"]["x"] + 1, y = machine_box["left_top"]["y"]}
                bottom_right = {x = machine_box["right_bottom"]["x"] + 1, y = machine_box["right_bottom"]["y"]}
            elseif direction == defines.direction.north then
                top_left = {x = machine_box["left_top"]["x"], y = machine_box["left_top"]["y"] - 1}
                bottom_right = {x = machine_box["right_bottom"]["x"], y = machine_box["left_top"]["y"] - 1}
            elseif direction == defines.direction.west then
                top_left = {x = machine_box["left_top"]["x"] - 1, y = machine_box["left_top"]["y"]}
                bottom_right = {x = machine_box["left_top"]["x"] - 1, y = machine_box["right_bottom"]["y"]}
            elseif direction == defines.direction.south then
                top_left = {x = machine_box["left_top"]["x"], y = machine_box["right_bottom"]["y"] + 1}
                bottom_right = {x = machine_box["right_bottom"]["x"], y = machine_box["right_bottom"]["y"] + 1}
            else
                error("Lightorio currently does not support machines with more than 4 rotation states.")
            end
        end

        top_left = {x = position["x"] + top_left["x"], y = position["y"] + top_left["y"]}
        bottom_right = {x = position["x"] + bottom_right["x"], y = position["y"] + bottom_right["y"]}

        local entities = surface.find_entities_filtered{area = {top_left, bottom_right}, type = "simple-entity-with-owner"}

        local found_light = 0
        local found_incorrect_light = 0

        local light_types_found = {}

        for _,entity in pairs(entities) do
            -- Don't count the entity if it's the machine itself
            if entity.unit_number == machine.unit_number then
                goto continue_2
            end

            -- Ensure that the entity we found is a light entity
            if not string.find(entity.name, "li%_light%-") then
                goto continue_2
            end

            -- More direction stuff
            local collision_box = {
                {
                    machine.prototype.collision_box["left_top"]["x"] + position["x"],
                    machine.prototype.collision_box["left_top"]["y"] + position["y"]
                },
                {
                    machine.prototype.collision_box["right_bottom"]["x"] + position["x"],
                    machine.prototype.collision_box["right_bottom"]["y"] + position["y"]
                }
            }

            local num_pos = {[1] = entity.position["x"], [2] = entity.position["y"]}

            local angle = get_direction(num_pos, get_closest_point_in_box(num_pos, collision_box))

            local snapped_direction
            if angle < 0.0625 or angle > 0.9375 then
                snapped_direction = defines.direction.east
            elseif angle < 0.3125 and angle > 0.1875 then
                snapped_direction = defines.direction.north
            elseif angle < 0.5625 and angle > 0.4375 then
                snapped_direction = defines.direction.west
            elseif angle < 0.8125 and angle > 0.6875 then
                snapped_direction = defines.direction.south
            end

            if not snapped_direction then
                goto continue_2
            end

            local light_type = (string.match(entity.name, "li%_light%-(.-)$"))

            -- Count light entities pointing at this machine
            if entity.direction == snapped_direction then
                if entity.name == "li_light-" .. ExposureData.light_type or ExposureData.light_type == "any" then
                    found_light = found_light + 1
                else
                    found_incorrect_light = found_incorrect_light + 1
                end
                light_types_found[light_type] = (light_types_found[light_type] or 0) + 1
            end

            ::continue_2::
        end

        local current_record = 0

        for light_type,count in pairs(light_types_found) do
            if count > current_record then
                current_record = count
                output_light_type_if_any = light_type
            end
        end

        -- Check if the amount of correct light is less than the amount required
        if found_light < ExposureData.amount then
            disable_machine = true
            table.insert(reasons, {type = "red", priority = 1, label = "not-enough-light"})
        end

        -- Check if the machine is recieving at least as much incorrect light than regular light and at least 0 of each
        if found_incorrect_light >= found_light and found_incorrect_light > 0 then
            disable_machine = true
            table.insert(reasons, {type = "red", priority = 2, label = "incorrect-light"})
        end
        end
        ::next1::
        -- Load in power source data
        local SolarData = SolarDataTable[machine.name]
        if not SolarData then
            goto next2
        end

        -- Check that it's daytime on the machine's surface
        if not is_day then
            disable_machine = true
            table.insert(reasons, {type = "yellow", priority = 3, label = "no-solar-power"})
        end

        ::next2::
        if not disable_machine then
            -- Enable the machine again and reset the custom status if the machine isn't being turned off this tick
            machine.disabled_by_script = false
            machine.custom_status = nil
            goto next3
        else

        -- Search through the provided reasons for turning the machine off and pick the best one for display
        local best_reason
        for _,reason in pairs(reasons) do
            if not best_reason then
                best_reason = reason
                goto continue
            end
            if reason.priority < best_reason.priority then
                goto continue
            end

            if reason.priority == best_reason.priority then
                if best_reason.type == "red" then
                    goto continue
                elseif best_reason.type == "yellow" and reason.type ~= "red" then
                    goto continue
                elseif best_reason.type == "green" and reason.type == "green" then
                    goto continue
                end
            end

            best_reason = reason

            ::continue::
        end

        -- Turn off the machine and apply the appropriate statuses
        local status = {}

        if best_reason.type == "red" then
            status.diode = defines.entity_status_diode.red
        elseif best_reason.type == "yellow" then
            status.diode = defines.entity_status_diode.yellow
        else
            status.diode = defines.entity_status_diode.green
        end

        status.label = {"li_custom-label." .. best_reason.label}

        machine.disabled_by_script = true
        machine.custom_status = status
        end
        ::next3::
        -- Only do light generation calculations on supported prototype types
        if not is_in_cheaper({["assembling-machine"] = true, furnace = true, ["rocket-silo"] = true}, machine.type) then
            goto next4
        end

        local MachineLightData = MachineLightDataTable[machine.name]
        if not MachineLightData or not MachineLightData.active then
            goto next4
        end

        -- Position stuff
        local position = machine.position
        local collision_box = machine.prototype.collision_box
        local direction = add_directions(handle_mirroring(MachineLightData.rotation, machine.mirroring), machine.direction)

        local offset = MachineLightData.offset

        if direction == defines.direction.east then
            position = {x = position["x"] + collision_box.right_bottom["x"], y = position["y"] + offset}
        elseif direction == defines.direction.north then
            position = {x = position["x"] - offset, y = position["y"] + collision_box.left_top["y"]}
        elseif direction == defines.direction.west then
            position = {x = position["x"] + collision_box.left_top["x"], y = position["y"] - offset}
        elseif direction == defines.direction.south then
            position = {x = position["x"] + offset, y = position["y"] + collision_box.right_bottom["y"]}
        else
            goto next4
        end

        local offset2 = offset_from_direction(direction)
        position = {x = position["x"] + offset2[1], y = position["y"] + offset2[2]}

        -- Load in recipe data for the current recipe
        local recipe = machine.get_recipe()
        local RecipeLightData
        if recipe then
            RecipeLightData = RecipeLightDataTable[recipe.name]
        end

        local target_light_name = "none"

        if RecipeLightData then
            target_light_name = RecipeLightData.light
        end

        if target_light_name == "any" and output_light_type_if_any ~= false then
            target_light_name = output_light_type_if_any
        end

        local found_entities = surface.find_entities_filtered({area = {left_top = {math.floor(position["x"]), math.floor(position["y"])}, right_bottom = {math.ceil(position["x"]), math.ceil(position["y"])}}, type = "simple-entity-with-owner"})

        -- Search through light entities
        local found_right_entity = false
        for _,entity in pairs(found_entities) do
            if not string.find(entity.name, "light%-") then
                goto continue
            end

            if entity.direction ~= direction then
                goto continue
            end

            if not entity.name == "li_light-" .. target_light_name then
                entity.destroy()
            else
                found_right_entity = true
            end

            ::continue::
        end

        -- Don't create a new entity if the machine is inactive or not producing light with the current recipe
        if machine.active == false or target_light_name == "none" then
            found_right_entity = true
        end

        -- If the light doesn't already exist, create it and add it to the tracking list
        if not found_right_entity then
            local new_entity = surface.create_entity{
                name = "li_light-" .. target_light_name,
                position = position,
                direction = direction,
                force = "neutral",
                source = machine.position,
                raise_built = true
            }

            if not new_entity then
                error("Could not create new light entity.")
            end

            storage.tracked_light_entities = storage.tracked_light_entities or {}

            table.insert(storage.tracked_light_entities, {source = machine.unit_number, entity = new_entity.unit_number, distance = 1})
        end
        ::next4::
    end

    storage.tracked_light_entities = storage.tracked_light_entities or {}

    local light_entities = storage.tracked_light_entities
    local soft_removed = {}

    local new_light_entities = {}

    local seen_distances = {}

    for i,tracked_light_entity in pairs(light_entities) do
        -- Backwards compattibility with old system
        if type(tracked_light_entity) ~= "table" then
            table.insert(soft_removed, i)
            goto continue
        end
        local source = get_entity_unit_number(tracked_light_entity.source)

        if not storage.cached_entities["simple-entity-with-owner"] then goto continue end
        local entity = storage.cached_entities["simple-entity-with-owner"][tracked_light_entity.entity].entity

        -- Ensure that our entities exist and are valid
        if (not source) or (not source.valid) or (not entity) or (not entity.valid) then
            if entity and entity.valid then
                entity.destroy()
            end
            table.insert(soft_removed, i)
            goto continue
        end
        ---@cast source LuaEntity
        ---@cast entity LuaEntity
        
        -- Check that the source is still active and pointing in the right direction

        local is_right_direction = add_directions(handle_mirroring(MachineLightDataTable[source.name].rotation, source.mirroring), source.direction) == entity.direction

        if not source.active or not is_right_direction then
            entity.destroy()
            table.insert(soft_removed, i)
            goto continue
        end

        if not entity.surface.can_place_entity{
            name = "li_fake-light",
            position = entity.position,
            direction = entity.direction
        } then
            entity.destroy()
            table.insert(soft_removed, i)
            goto continue
        end

        seen_distances[source.unit_number] = seen_distances[source.unit_number] or {}
        seen_distances[source.unit_number][tracked_light_entity.distance] = true

        -- Propagate light for this entity
        propagate_light(tracked_light_entity, new_light_entities)

        ::continue::
    end

    -- Prevent beams of light from travelling through walls
    local first_gaps = {}

    for source,distances in pairs(seen_distances) do
        local first_gap = 1
        while distances[first_gap] ~= nil do
            first_gap = first_gap + 1
        end
        first_gaps[source] = first_gap
    end

    for i,tracked_light_entity in pairs(light_entities) do
        local source = tracked_light_entity.source

        if not storage.cached_entities["simple-entity-with-owner"] then goto continue end
        local entity = storage.cached_entities["simple-entity-with-owner"][tracked_light_entity.entity].entity
        
        local distance = tracked_light_entity.distance
        if first_gaps[source] and (first_gaps[source] <= distance) then
            if entity and entity.valid then
                ---@cast entity LuaEntity
                entity.destroy()
                table.insert(soft_removed, i)
            end
        end
        ::continue::
    end

    -- Remove invalid light entities
    local removed_entity_count = 0
    for _,to_remove in pairs(soft_removed) do
        table.remove(light_entities, to_remove - removed_entity_count)
        removed_entity_count = removed_entity_count + 1
    end

    -- Load newly propagated light entities
    merge_into_table(light_entities, new_light_entities)

    -- Process collisions with other entities
    for _,tracked_light_entity in pairs(light_entities) do
        light_collisions(tracked_light_entity, HazardDataTable)
    end
end

-- Streches out light beams as far as possible and tracks them
---@param tracked_light_entity {source: uint64, entity: uint64, distance: uint32}
---@param t {source: uint64, entity: uint64}[]
function propagate_light(tracked_light_entity, t)
    if not storage.cached_entities["simple-entity-with-owner"] then return end
    local light_entity = storage.cached_entities["simple-entity-with-owner"][tracked_light_entity.entity].entity

    -- Check that the light entity provided to us isn't nil
    if light_entity == nil then
        return
    end

    -- Position stuff
    local position = light_entity.position
    local offset = offset_from_direction(light_entity.direction)

    local new_position = {position["x"] + offset[1], position["y"] + offset[2]}
    local dest_entities = light_entity.surface.find_entities_filtered({
        area = {
            left_top = {math.floor(new_position[1]), math.floor(new_position[2])},
            right_bottom = {math.ceil(new_position[1]), math.ceil(new_position[2])}
        }, 
        type = light_entity.type
    })

    -- Destroy any incorrect light beams in the same direction as us
    for _,dest_entity in pairs(dest_entities) do
        if dest_entity.direction == light_entity.direction and dest_entity.name == light_entity.name then
            if light_entity.surface.can_place_entity{
                name = "li_fake-light",
                position = new_position,
                direction = light_entity.direction
            } then return
            else
                dest_entity.destroy()
                return
            end
        elseif dest_entity.direction == light_entity.direction and string.find(dest_entity.name, "light%-") then
            dest_entity.destroy()
        end
    end

    -- Check that we're allowed to place a light entity here
    if not light_entity.surface.can_place_entity{
        name = "li_fake-light",
        position = new_position,
        direction = light_entity.direction
    } then return end

    -- Create the entity
    local new_entity = light_entity.surface.create_entity{
        name = light_entity.name,
        position = new_position,
        direction = light_entity.direction,
        force = "neutral",
        source = light_entity.position,
        raise_built = true
    }

    if not new_entity then return end

    -- Start tracking the entity
    local new_tracked_light_entity = {source = tracked_light_entity.source, entity = new_entity.unit_number, distance = tracked_light_entity.distance + 1}

    table.insert(t, new_tracked_light_entity)

    -- Recursively continue propagating
    propagate_light(new_tracked_light_entity, t)
end

-- Runs collision checks for the light entity
function light_collisions(tracked_light_entity, HazardDataTable)
    if not storage.cached_entities["simple-entity-with-owner"] then return end
    local light_entity = storage.cached_entities["simple-entity-with-owner"][tracked_light_entity.entity].entity

    -- Ensure that the light entity is not nil
    if not light_entity or not light_entity.valid then
        return
    end

    -- Position stuff
    local position = light_entity.position
    local direction = light_entity.direction

    local left_top = {math.floor(position["x"]), math.floor(position["y"])}
    local right_bottom = {math.ceil(position["x"]), math.ceil(position["y"])}

    if direction == defines.direction.east then
        right_bottom = {right_bottom[1] + 1, right_bottom[2]}
    elseif direction == defines.direction.north then
        left_top = {left_top[1], left_top[2] - 1}
    elseif direction == defines.direction.west then
        left_top = {left_top[1] - 1, left_top[2]}
    elseif direction == defines.direction.south then
        right_bottom = {right_bottom[1], right_bottom[2] + 1}
    end

    local target_entities = light_entity.surface.find_entities_filtered({
        area = {
            left_top = left_top,
            right_bottom = right_bottom
        }
    })

    -- This determines which entity types are in which category
    local player_like_entities = {character = true, unit = true, ["unit-spawner"] = true, tree = true, ["segmented-unit"] = true, segment = true}
    -- These entities are removed instead of getting damaged
    local removed_entities = {projectile = true}

    local player_box = {
        {math.floor(position["x"]), math.floor(position["y"])},
        {math.ceil(position["x"]), math.ceil(position["y"])}
    }

    local HazardData = HazardDataTable[light_entity.name]
    
    -- Apply damages
    for _,entity in pairs(target_entities) do
        if string.find(entity.name, "light%-") or not entity.is_entity_with_health then
            goto continue
        end

        local in_player_box = is_in_box({[1] = entity.position["x"], [2] = entity.position["y"]}, player_box)

        local damage = 0
        if removed_entities[entity.type] and in_player_box then
            entity.destroy()
            goto continue
        elseif player_like_entities[entity.type] and in_player_box then
            damage = get_damage_for(HazardData.player)
        elseif not in_player_box then
            damage = get_damage_for(HazardData.other)
        end
        if damage ~= 0 then
            entity.damage(damage, "neutral", "laser", light_entity)
        end
        ::continue::
    end
end

-- Converts a damage string to a specific value
function get_damage_for(damage_string)
    if damage_string == "low" then
        return 0.2
    else
        return 0
    end
end

-- Refreshes the entities cache
-- Can be called using the command /c __ModLightorio__ refresh_all_entities()
-- Warning: May cause severe lag
function refresh_all_entities()
    storage.cached_entities = {}
    for _,surface in pairs(game.surfaces) do
        local entities = surface.find_entities()
        for _,entity in pairs(entities) do
            on_entity_build{entity = entity, name = -1}
        end
    end
end

-- Adds a new entity to the cache
function on_entity_build(event)
    local entity
    if event.name == defines.events.on_entity_cloned then
        entity = event.destination
    else
        entity = event.entity
    end

    if not entity or not entity.valid then
        return
    end

    if not entity.unit_number then
        return
    end

    local deletion_id = (script.register_on_object_destroyed(entity))

    storage.cached_entities = storage.cached_entities or {}
    storage.cached_entities[entity.type] = storage.cached_entities[entity.type] or {}
    storage.cached_entities[entity.type][entity.unit_number] = {entity = entity, deletion_id = deletion_id}
end

-- Removes an entity from the cache
function on_destroy(event)
    storage.cached_entities = storage.cached_entities or {}

    for t,un_list in pairs(storage.cached_entities) do
        for unit_number,entity in pairs(un_list) do
            if entity.deletion_id == event.registration_number then
                storage.cached_entities[t][unit_number] = nil
                return
            end
        end
    end
end

-- Gets all cached entities with specific types.
---@param types table<string, boolean> The types to filter for should be set to true in this table.
---@return LuaEntity[]
function get_entities_with_type(types)
    storage.cached_entities = storage.cached_entities or {}

    local entities = {}
    for t,_ in pairs(types) do
        if not storage.cached_entities[t] then
            goto continue
        end
        merge_tables_cheap(entities, storage.cached_entities[t])
        ::continue::
    end

    local out = {}
    local count = 0

    local inserted_unit_numbers = {}

    for i,entity in pairs(entities) do
        if not entity.entity.valid or inserted_unit_numbers[entity.entity.unit_number] then
            goto continue
        end
        out[count] = entity.entity
        inserted_unit_numbers[entity.entity.unit_number] = true
        count = count + 1
        ::continue::
    end

    return out
end

-- Gets an entity by it's unit number.
-- If cached, it doesn't have to go ask the API for the entity.
---@param unit_number uint64
---@return LuaEntity?
function get_entity_unit_number(unit_number)
    storage.cached_entities = storage.cached_entities or {}

    for _,type in pairs(storage.cached_entities) do
        if type[unit_number] then
            return type[unit_number].entity
        end
    end

    -- Fallback to slow lookup
    return game.get_entity_by_unit_number(unit_number)
end

-- Gets an entity by it's unit number and type.
---@param unit_number uint64
---@return LuaEntity?
function get_entity_unit_number_typed(unit_number, type)
    storage.cached_entities = storage.cached_entities or {}

    if storage.cached_entities[type] and storage.cached_entities[type][unit_number] then
        return storage.cached_entities[type][unit_number].entity
    end
end

-- Register events
local on_build_entities = {
    defines.events.on_built_entity,
    defines.events.on_robot_built_entity,
    defines.events.script_raised_built,
    defines.events.script_raised_revive,
    defines.events.on_space_platform_built_entity,
    defines.events.on_entity_cloned
}
for _,entity_event in pairs(on_build_entities) do
    script.on_event(entity_event, on_entity_build)
end

-- Called whenever the game loads
-- Currently unused
function on_load()

end

script.on_load(on_load)

script.on_event(defines.events.on_object_destroyed, on_destroy)

script.on_event(defines.events.on_tick, on_tick)