require("util")
---@diagnostic disable: missing-return

---@param object any
---@param other_object any
function compare(object, other_object)
    if type(object) ~= type(other_object) then
        return false
    end
    if type(object) ~= "table" then
        return object == other_object
    end
    for k,v in pairs(object) do
        if not other_object[k] then
            return false
        end
        if compare(v, other_object[k]) == false then
            return false
        end
    end
    for ok,ov in pairs(other_object) do
        if not other_object[ok] then
            return false
        end
        if compare(ov, object[ok]) == false then
            return false
        end
    end
    return true
end

---@param table table
---@param object any
function is_in(table, object)
    if type(table) ~= "table" then return false end
    for _,other_object in pairs(table) do
        if compare(object, other_object) then
            return true
        end
    end
    return false
end

---@param table table|any
---@param object string|number|boolean
---@return boolean
function is_in_cheap(table, object)
    if type(table) ~= "table" then return false end
    for _,other_object in pairs(table) do
        if object == other_object then
            return true
        end
    end
    return false
end

---@generic T
---@param set table<T, boolean>
---@param object T
---@return boolean
function is_in_cheaper(set, object)
    if type(set) ~= "table" then return false end
    return set[object]
end

---@param table table
---@param other_table table
---@return table
function table_add(table, other_table)
    if type(table) ~= "table" and type(other_table) ~= "table" then
        return table + other_table
    end

    if #table ~= other_table then
        error("Cannot add tables of different sizes")
    end

    local new_table = {}
    for k,v in pairs(table) do
        if type(table[k]) ~= type(other_table[k]) then
            goto continue
        end
        new_table[k] = table_add(v, other_table[k])
        ::continue::
    end

    return new_table
end

---@param str string
---@return string
function pattern_escape(str)
    return (string.gsub(str, "([^%w])", "%%%1"))
end

---@param num number
---@return number
function round(num)
    if num - math.floor(num) < 0.5 then
        return math.floor(num)
    else
        return math.ceil(num)
    end
end

---@param position {[1]: number, [2]: number}
---@param box {[1]: {[1]: number, [2]: number}, [2]: {[1]: number, [2]:number}}
---@return {[1]: number, [2]: number}
function get_closest_point_in_box(position, box)
    local clamped_x = math.max(box[1][1], math.min(box[2][1], position[1]))
    local clamped_y = math.max(box[1][2], math.min(box[2][2], position[2]))

    local candidate_x_1 = math.floor(clamped_x) + 0.5
    local candidate_x_2 = candidate_x_1 < clamped_x and candidate_x_1 - 1 or candidate_x_1 + 1

    local rounded_x = (candidate_x_1 - clamped_x <= 0.5 and candidate_x_1 or candidate_x_2)

    local candidate_y_1 = math.floor(clamped_y) + 0.5
    local candidate_y_2 = candidate_y_1 < clamped_y and candidate_y_1 - 1 or candidate_y_1 + 1

    local rounded_y = (candidate_y_1 - clamped_y <= 0.5 and candidate_y_1 or candidate_y_2)

    return {rounded_x, rounded_y}
end

---@param position {[1]: number, [2]: number}
---@param other_position {[1]: number, [2]: number}
---@return number angle A number in the range [0,1]. Used to represent an angle in the unit of turns, measured counter-clockwise from the positive x axis.
function get_direction(position, other_position)
    local diff_x =       other_position[1] - position[1]
    local diff_y = -1 * (other_position[2] - position[2])

    local angle = (math.atan2(diff_y, diff_x) / (2 * math.pi))
    if angle < 0 then
        angle = angle + 1
    end

    return angle
end

---@param t table
---@param ot table
---@return table
function merge_tables(t, ot)
    local new_table = table.deepcopy(t)
    for k,v in pairs(ot) do
        new_table[k] = v
    end
    return new_table
end

---@param t table
---@param ot table
function merge_tables_cheap(t, ot)
    for k,v in pairs(ot) do
        t[k] = v
    end
end

---@param t table
---@param ot table
function merge_into_table(t, ot)
    local index = #t
    for _,v in pairs(ot) do
        index = index + 1
        t[index] = v
    end
end

---@param val1 number
---@param val2 number
---@param factor number
---@return number
function interpolation(val1, val2, factor)
    return (val1 * factor) + (val2 * (1 - factor))
end

---@param direction defines.direction
---@return {[1]: number, [2]: number}
function offset_from_direction(direction)
    if direction == defines.direction.east then
        return {1, 0}
    elseif direction == defines.direction.north then
        return {0, -1}
    elseif direction == defines.direction.west then
        return {-1, 0}
    elseif direction == defines.direction.south then
        return {0, 1}
    end
end

---@param direction defines.direction
---@param other_direction defines.direction
---@return defines.direction
function add_directions(direction, other_direction)
    if direction == defines.direction.east then
        return other_direction
    elseif direction == defines.direction.north then
        if other_direction == defines.direction.east then
            return defines.direction.north
        elseif other_direction == defines.direction.north then
            return defines.direction.west
        elseif other_direction == defines.direction.west then
            return defines.direction.south
        elseif other_direction == defines.direction.south then
            return defines.direction.east
        end
    elseif direction == defines.direction.west then
        if other_direction == defines.direction.east then
            return defines.direction.west
        elseif other_direction == defines.direction.north then
            return defines.direction.south
        elseif other_direction == defines.direction.west then
            return defines.direction.east
        elseif other_direction == defines.direction.south then
            return defines.direction.north
        end
    elseif direction == defines.direction.south then
        if other_direction == defines.direction.east then
            return defines.direction.south
        elseif other_direction == defines.direction.north then
            return defines.direction.east
        elseif other_direction == defines.direction.west then
            return defines.direction.north
        elseif other_direction == defines.direction.south then
            return defines.direction.west
        end
    end
end

---@param direction defines.direction
---@param mirroring boolean
---@return defines.direction
function handle_mirroring(direction, mirroring)
    if not mirroring then
        return direction
    end

    if direction == defines.direction.east then
        return defines.direction.east
    elseif direction == defines.direction.north then
        return defines.direction.south
    elseif direction == defines.direction.west then
        return defines.direction.west
    elseif direction == defines.direction.south then
        return defines.direction.north
    end
end

---@param position {[1]: number, [2]: number}
---@param box {[1]: {[1]: number, [2]: number}, [2]: {[1]: number, [2]:number}}
---@return boolean
function is_in_box(position, box)
    if position[1] < box[1][1] then
        return false
    elseif position[2] < box[1][2] then
        return false
    elseif position[1] > box[2][1] then
        return false
    elseif position[2] > box[2][2] then
        return false
    end
    return true
end