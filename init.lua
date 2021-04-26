greek = {}

local MODNAME = minetest.get_current_modname()
local MODPATH = minetest.get_modpath(MODNAME)

minetest.log("action", "[greek] Loading ...")

local function include(filename)
    minetest.log("info", "[greek] Loading " .. filename .. " ...")
    return dofile(MODPATH .. "/" .. filename), minetest.log("info", "[greek] Loaded " .. filename)
end

local function convert(value, type)
    return ({number = tonumber(value), string = tostring(value), boolean = value == "true"})[type]
end

-- Manually parse defaults because minetest.settings:get() wont return them
local settingtypes = {}
for line in io.lines(MODPATH .. "/settingtypes.txt") do
    if not line:match("^%s*#") and not line:match("^%s*$") then
        local name, _, stype, default = line:match("%s*(%S-) (%(.*%)) (%w+) ?(.*)")
        -- Convert string value to type (int = number, boolean = bool, else string)
        settingtypes[name] = convert(default, ({int = "number", bool = "boolean"})[stype] or "string")
    end
end

function greek.settings_get(key)
    key = "greek." .. key
    local default = settingtypes[key]
    local setting = minetest.settings:get(key)
    return (setting ~= nil and {convert(setting, type(default))} or {default})[1]
end

-- Convert comma-deliminated string setting to table
function greek.settings_list(key)
    return greek.settings_get(key):gsub("%s", ""):split(",")
end

-- Return default sounds if available
function greek.default_sounds(name)
    if default and default[name] then return default[name]() end
end

local register_stairs = include("stairs.lua")
function greek.register_node_and_stairs(name, definition)
    minetest.register_node(name, definition)
    return {name, unpack(register_stairs(name, definition, name))}
end

-- Add custom group to item
local function add_group(item, group)
    local def = minetest.registered_items[item]
    if def then
        local groups = table.copy(def.groups or {})
        groups["greek:" .. group] = 1
        minetest.override_item(item, {groups = groups})
    end
end

local overrides = {}
local loaded = false

function greek.add_group(item, group)
    if not loaded then
        overrides[item] = group
    else
        add_group(item, group)
    end
end

minetest.register_on_mods_loaded(function()
    for item, group in pairs(overrides) do
        add_group(item, group)
    end
    loaded = true
end)

-- Registers recipes to make a sequence of items by using a single item type to get the next item type
-- `item` is a string that can be formatted with a given number or name from `total_or_table`
-- 1 -> 2, n -> n + 1, last -> first
-- Also registers crafts for copying one type to another (2 target type + 1 other type = 3 target type)
function greek.register_craftring(item, total_or_table)
    if tonumber(total_or_table) then
        -- If total, make table filled with number sequence
        total_or_table = (function(a, b) for i = 1, b do a[i] = i end return a end)({}, total_or_table)
    end

    for i = 1, #total_or_table do
        local itemname = item:format(total_or_table[i])
        minetest.register_craft({
            output = itemname,
            recipe = {item:format(total_or_table[(i - 2) % #total_or_table + 1])},
            type = "shapeless",
        })

        -- Type copying using groups
        local groups = table.copy(minetest.registered_items[itemname].groups)
        groups[item] = 1

        minetest.override_item(itemname, {
            groups = groups,
        })

        minetest.register_craft({
            output = itemname,
            recipe = {itemname, itemname, "group:" .. item}, -- Use 2 to set target
            type = "shapeless",
            replacements = {{itemname, itemname}, {itemname, itemname}}, -- Keep targets
        })
    end
end

-- Colorize node on punch
-- `dyes` is a map of palette indexes indexed by dye itemstring
function greek.dye_punch(dyes)
    return function(pos, node, puncher, pointed)
        if not minetest.is_protected(pos, puncher:get_player_name()) then
            local stack = puncher:get_wielded_item():get_name()
            if dyes[stack] then
                minetest.swap_node(pos, {name = node.name, param2 = (dyes[stack] * 32) + (node.param2 % 32)})
                if greek.settings_get("consume_dye") then
                    local wielded = puncher:get_wielded_item()
                    wielded:take_item()
                    puncher:set_wielded_item(wielded)
                end
            end
        end
        return minetest.node_punch(pos, node, puncher, pointed)
    end
end

include("marble.lua")
include("decor.lua")
include("doors.lua")
include("vases.lua")
include("lighting.lua")
if greek.settings_get("greeknodes_aliases") then include("compat.lua") end

minetest.log("action", "[greek] Loaded.")
