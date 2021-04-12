-- Pretty vases that can also hold a few things.
-- Can hold liquid from buckets as well.

local VASE_MAX = greek.settings_get("vase_max")

-- Check if given stack is a bucket with liquid
local function get_liquid_or_stack(stack)
    local name = stack:get_name()
    if minetest.global_exists("bucket") then
        for _, def in pairs(bucket.liquids) do
            if def.itemname == name then
                return def.source
            end
        end
    end
    return stack
end

-- Add stack to player hand first, then inventory, and return leftover ItemStack
local function give_to_player(player, stack)
    -- Add as much as possible to hand
    local wield = player:get_wielded_item()
    stack = ItemStack(stack) -- Just in case we were given a string
    if wield:get_name() == "" or wield:get_name() == stack:get_name() then
        stack = wield:add_item(stack)
        player:set_wielded_item(wield)
    end

    -- Add as much as possible to inventory
    if stack:get_count() > 0 then
        stack = player:get_inventory():add_item("main", stack)
    end

    return stack
end

-- Change vase contents, infotext, and visuals
local function update_vase(pos, contents)
    local meta = minetest.get_meta(pos)
    local count = contents:get_count()
    local def = minetest.registered_items[contents:get_name()]

    -- Only update the visual if the vase just was or is now empty
    if ItemStack(meta:get_string("contents")):get_count() == 0 or count == 0 then
        local node = minetest.get_node(pos)
        minetest.swap_node(pos, {
            name = node.name,
            -- Set filled texture color to blue (liquid), grey or tan (solid), or black (empty)
            param2 = ((minetest.global_exists("bucket") and bucket.liquids[contents:get_name()] and 192) or (count > 0 and ({64, 128})[math.random(2)]) or 0) + node.param2 % 32
        })
    end

    -- Update contents and infotext
    meta:set_string("contents", count > 0 and contents:to_string() or "")
    meta:set_string("infotext", count > 0 and ("Vase with %s %s"):format(count, def.description) or " ")
end

-- Vase on_rightclick
local function vase_put(pos, _, _, stack)
    local meta = minetest.get_meta(pos)
    local contents = ItemStack(meta:get_string("contents"))

    if stack:get_name() ~= "" then
        -- Make a copy of the stack
        local put = ItemStack(get_liquid_or_stack(stack))

        -- Limit volume to VASE_MAX or stack_max
        -- Only add to vase if there is room
        if contents:get_count() == 0 or (contents:get_name() == put:get_name() and contents:get_count() < math.min(contents:get_stack_max(), VASE_MAX)) then
            contents:add_item(put:take_item())
            update_vase(pos, contents)

            -- If names are different, this was a liquid. Return a bucket
            stack = contents:get_name() ~= stack:get_name() and "bucket:bucket_empty" or put
        end
    end

    return stack
end

-- Vase on_punch
local function vase_take(pos, _, puncher)
    local meta = minetest.get_meta(pos)
    local contents = ItemStack(meta:get_string("contents"))

    if contents:get_count() > 0 then
        local take = contents:take_item()

        if bucket and bucket.liquids[take:get_name()] then
            local wielded = puncher:get_wielded_item()
            local original = ItemStack(wielded)
            -- If liquid, require a bucket
            if wielded:get_name() ~= "bucket:bucket_empty" then return end

            -- Take an empty bucket
            wielded:take_item()
            puncher:set_wielded_item(wielded)

            -- Try to give player the full bucket
            if give_to_player(puncher, bucket.liquids[take:get_name()].itemname):get_count() ~= 0 then
                -- If it didn't fit, give back the empty bucket and stop
                puncher:set_wielded_item(original)
                return
            end

            -- If the return worked, remove one from the take
            take:take_item()
        else
            -- If holding sneak, attempt to take the rest of the contents
            if puncher:get_player_control().sneak then
                take:add_item(contents:take_item(contents:get_count()))
            end

            -- Give as much to the player as possible
            take = give_to_player(puncher, take)
        end

        -- Put back remaining items, if any
        contents:add_item(take)
        update_vase(pos, contents)
    end
end

local shapes = {
    amphora = {
        total = 4,
        box = {{-5 / 16, -0.5, -5 / 16, 5 / 16, 0.5, 5 / 16}},
    },
    stamnos = {
        total = 4,
        box = {{-6 / 16, -0.5, -6 / 16, 6 / 16, 3 / 16, 6 / 16}},
    },
}

for shape, def in pairs(shapes) do
    for i = 1, def.total do
        local name = ("vase_%s_%s"):format(shape, i)
        minetest.register_node("greek:" .. name, {
            description = ("%s Vase %s"):format(shape:gsub("^%l", string.upper), i),
            drawtype = "mesh",
            mesh = "greek_vase_" .. shape .. ".obj",
            tiles = {{name = "greek_" .. name .. ".png", color = "white"}},
            overlay_tiles = {"greek_vase_" .. shape .. "_contents.png"},
            paramtype = "light",
            sunlight_propagates = true,
            paramtype2 = "colorfacedir",
            palette = "greek_vase_palette.png",
            color = "black",
            selection_box = {
                type = "fixed",
                fixed = def.box,
            },
            collision_box = {
                type = "fixed",
                fixed = def.box,
            },
            groups = {cracky = 3, oddly_breakable_by_hand = 2},
            sounds = greek.default_sounds("node_sound_glass_defaults"),
            on_rightclick = vase_put,
            on_punch = vase_take,
            can_dig = function(pos) return minetest.get_meta(pos):get_int("count") == 0 end
        })
    end

    greek.register_craftring("greek:vase_" .. shape .. "_%s", def.total)
end

minetest.register_craft({
    output = "greek:vase_amphora_1 2",
    recipe = {
        {"group:greek:red_clay", "", "group:greek:red_clay"},
        {"group:greek:red_clay", "", "group:greek:red_clay"},
        {"group:greek:red_clay", "group:greek:red_clay", "group:greek:red_clay"},
    }
})

minetest.register_craft({
    output = "greek:vase_stamnos_1 2",
    recipe = {
        {"group:greek:red_clay", "", "group:greek:red_clay"},
        {"group:greek:red_clay", "group:greek:red_clay", "group:greek:red_clay"},
    }
})
