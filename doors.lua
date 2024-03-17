-- Custom door implementation because I don't want to depend on other mods for content.
-- Registers only 2 nodes per door. Relies on front and back faces being identical. Locked doors implemented via param2.

local function can_interact(pos, player)
    local meta = minetest.get_meta(pos)
    local owner = meta:get_string("owner")
    -- Not locked, is owner, or has valid key
    return owner == "" or player:get_player_name() == owner or meta:get_string("secret") == player:get_wielded_item():get_meta():get_string("secret")
end

local function toggle_door(pos)
    local node = minetest.get_node(pos)
    local meta = minetest.get_meta(pos)

    local door, flip = node.name:match("^(.+_)(%w)$")
    local yaw = minetest.dir_to_yaw(minetest.facedir_to_dir(node.param2))
    local rot = minetest.dir_to_facedir(minetest.yaw_to_dir(yaw + math.rad(flip == "a" and -90 or 90)))

    minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "greek:door_blank", param2 = rot})
    minetest.swap_node(pos, {name = door .. (flip == "a" and "b" or "a"), param2 = rot + (meta:get_string("owner") ~= "" and 128 or 0)})

    local state = (meta:get_int("state") + 1) % 2
    meta:set_int("state", state)
    if minetest.get_modpath("doors") then minetest.sound_play("doors_door_" .. ({"close", "open"})[state + 1], {pos = pos}, true) end
end

minetest.register_node("greek:door_blank", {
    drawtype = "airlike",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    walkable = true,
    pointable = false,
    diggable = false,
    buildable_to = false,
    floodable = false,
    drop = "",
    groups = {not_in_creative_inventory = 1},
    collision_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, -6 / 16},
    },
})

local door_count = 4

for i = 1, door_count do
    local def = {
        description = "Blue Door " .. i,
        drawtype = "mesh",
        mesh = "greek_door.obj",
        tiles = {{name = "greek_door_" .. i .. ".png", backface_culling = true, color = "white"}},
        overlay_tiles = {"greek_door_handle.png"},
        paramtype = "light",
        sunlight_propagates = true,
        paramtype2 = "colorfacedir",
        palette = "greek_door_palette.png",
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, -6 / 16},
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 1.5, -6 / 16},
        },
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, door = 1},
        on_rightclick = function(pos, _, clicker) if can_interact(pos, clicker) then toggle_door(pos) end end,
        on_key_use = function(pos, player) if can_interact(pos, player) then toggle_door(pos) end end,
        on_skeleton_key_use = function(pos, player, newsecret)
            local meta = minetest.get_meta(pos)
            local name = player:get_player_name()
            local owner = meta:get_string("owner")

            if owner ~= name then
                if owner ~= "" then minetest.chat_send_player(name, "You do not own this door.") end
                return
            end

            local secret = meta:get_string("secret")
            secret = secret ~= "" and secret or newsecret
            meta:set_string("secret", secret)

            return secret
        end,
        on_punch = function(pos, node, puncher, pointed)
            -- Allow binding a key to multiple doors
            local stack = puncher:get_wielded_item()
            print(stack:get_name())
            if minetest.get_item_group(stack:get_name(), "key") == 1 then
                local meta = minetest.get_meta(pos)
                local name = puncher:get_player_name()

                if meta:get_string("owner") == name then
                    local current = meta:get_string("secret")
                    local new = stack:get_meta():get_string("secret")

                    if current == "" then
                        meta:set_string("secret", new)
                    elseif current ~= new then
                        minetest.chat_send_player(name, "This door has already been bound to a key.")
                    end
                end
            end
            minetest.node_punch(pos, node, puncher, pointed)
        end,
        on_rotate = function() return false end,
        on_dig = function(pos, node, digger)
            minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
            minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "air"})
            return minetest.node_dig(pos, node, digger)
        end,
        on_blast = function(pos)
            if minetest.get_meta(pos):get_string("owner") ~= "" then return end
            local name = minetest.get_node(pos).name
            minetest.remove_node(pos)
            minetest.remove_node({x = pos.x, y = pos.y + 1, z = pos.z})
            return {name}
        end,
        use_texture_alpha = door_count == 4 and "clip" or nil, -- Door no. 4 has a transparent texture
    }

    do -- Register normal version
        local defcopy = table.copy(def)

        -- Check for obstructions and place invisible node
        defcopy.on_place = function(itemstack, placer, pointed)
            local pos

            if pointed.type ~= "node" then return itemstack end

            local node = minetest.get_node(pointed.under)
            local pdef = minetest.registered_nodes[node.name]

            if pdef and pdef.on_rightclick and not placer:get_player_control().sneak then
                return pdef.on_rightclick(pointed.under, node, placer, itemstack, pointed)
            end

            if pdef and pdef.buildable_to then
                pos = pointed.under
            else
                pos = pointed.above
                node = minetest.get_node(pos)
                pdef = minetest.registered_nodes[node.name]
                if not pdef or not pdef.buildable_to then return itemstack end
            end

            local above = {x = pos.x, y = pos.y + 1, z = pos.z}
            local top_node = minetest.get_node_or_nil(above)
            local topdef = top_node and minetest.registered_nodes[top_node.name]

            if not topdef or not topdef.buildable_to then return itemstack end

            local pn = placer and placer:get_player_name() or ""
            if minetest.is_protected(pos, pn) or minetest.is_protected(above, pn) then return itemstack end

            return minetest.item_place_node(itemstack, placer, pointed)
        end

        -- Set metadata and rotate door
        defcopy.after_place_node = function(pos, placer)
            local node = minetest.get_node(pos)
            local meta = minetest.get_meta(pos)

            -- Check if door is locked
            if math.floor(node.param2 / 32) >= 4 then
                local name = placer:get_player_name()
                meta:set_string("owner", name)
                meta:set_string("infotext", "Blue Door\nOwned by " .. name)
            end

            meta:set_int("state", 0)

            local dir = node.param2 % 32
            local ref = {
                {x = -1, y = 0, z = 0},
                {x = 0, y = 0, z = 1},
                {x = 1, y = 0, z = 0},
                {x = 0, y = 0, z = -1},
            }

            local aside = {
                x = pos.x + ref[dir + 1].x,
                y = pos.y + ref[dir + 1].y,
                z = pos.z + ref[dir + 1].z,
            }

            if minetest.get_item_group(minetest.get_node(aside).name, "door") == 1 then
                minetest.swap_node(pos, {name = node.name:match("^(.+_)%w$") .. "b", param2 = node.param2})
            end

            minetest.set_node({x = pos.x, y = pos.y + 1, z = pos.z}, {name = "greek:door_blank", param2 = node.param2})
        end

        defcopy.color = "#242424"

        -- Use overlay for door because it wont be colored
        defcopy.inventory_overlay = "greek_door_" .. i .. "_inv.png"
        defcopy.inventory_image = "greek_door_inv_handle.png"

        defcopy.wield_overlay = "greek_door_" .. i .. "_inv.png"
        defcopy.wield_image = "greek_door_inv_handle.png"

        minetest.register_node("greek:door_" .. i .. "_a", defcopy)
    end

    do -- Register mirrored version (should not be obtainable normally)
        local defcopy = table.copy(def)
        -- Fancy flipping
        local front = "([combine\\:16x32\\:0,0=%s\\^[transformFX)"
        local back = "([combine\\:16x32\\:-16,0=%s\\^[transformFX)"
        local sides = "([combine\\:4x32\\:-32,0=%s\\^[transformFX)"
        local tops = "([combine\\:2x32\\:-36,0=%s\\^[transformFX)"

        defcopy.tiles[1].name = (("[combine:38x32:0,0=%s:16,0=%s:32,0=%s:36,0=%s"):format(front, back, sides, tops):gsub("%%s", def.tiles[1].name))
        defcopy.overlay_tiles = {(("[combine:38x32:0,0=([combine\\:16x32\\:0,0=%s\\^[transformFX):16,0=([combine\\:16x32\\:-16,0=%s\\^[transformFX)"):gsub("%%s", def.overlay_tiles[1]))}

        defcopy.groups.not_in_creative_inventory = 1

        defcopy.drop = "greek:door_" .. i .. "_a"
        defcopy.preserve_metadata = function(_, node, oldmeta, drops)
            -- Preserve locked state
            if oldmeta.owner then
                local meta = drops[1]:get_meta()
                meta:set_int("palette_index", 128)
                meta:set_string("description", "Locked " .. minetest.registered_items[node.name].description)
                meta:set_string("color", "#dcdcdc")
            end
        end

        minetest.register_node("greek:door_" .. i .. "_b", defcopy)
    end
end

greek.register_craftring("greek:door_%s_a", door_count)

for _, item in pairs(greek.settings_list("blue_wood")) do
    -- Only bother registering our own if it is used
    if item == "greek:blue_wood" then
        greek.register_node_and_stairs("greek:blue_wood", {
            description = "Blue Wood",
            tiles = {"greek_blue_wood.png"},
            groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2, wood = 2},
            sounds = greek.default_sounds("node_sound_wood_defaults"),
        })

        minetest.register_craft({
            output = "greek:blue_wood",
            recipe = {"group:wood", "dye:blue"},
            type = "shapeless",
        })
    end

    greek.add_group(item, "blue_wood")
end

minetest.register_craft({
    output = "greek:door_1_a 2",
    recipe = {
        {"greek:blue_wood", "greek:blue_wood"},
        {"greek:blue_wood", "greek:blue_wood"},
        {"greek:blue_wood", "greek:blue_wood"},
    },
})

for _, item in pairs(greek.settings_list("door_lock")) do
    greek.add_group(item, "door_lock")
end

minetest.register_craft({
    output = ItemStack({
        name = "greek:door_1_a",
        meta = {
            description = "Locked " .. minetest.registered_items["greek:door_1_a"].description,
            color = "#dcdcdc",
            palette_index = 128,
        },
    }):to_string(),
    recipe = {"greek:door_1_a", "group:greek:door_lock"},
    type = "shapeless",
})

local shutter_count = 3

for i = 1, shutter_count do
    local def = {
        description = "Blue Shutters " .. i,
        drawtype = "mesh",
        mesh = "greek_shutters.obj",
        tiles = {{name = "greek_shutters_" .. i .. ".png", backface_culling = true}, "blank.png"},
        paramtype = "light",
        sunlight_propagates = true,
        paramtype2 = "facedir",
        use_texture_alpha = "clip",
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, 6 / 16, 0.5, 0.5, 0.5},
        },
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, 6 / 16, 0.5, 0.5, 0.5},
        },
        groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
        on_rightclick = function(pos, node)
            minetest.swap_node(pos, {name = "greek:shutters_" .. i .. "_open", param2 = node.param2})
            if minetest.get_modpath("doors") then minetest.sound_play("doors_door_open", {pos = pos}, true) end
        end,
    }

    minetest.register_node("greek:shutters_" .. i, def)

    def = table.copy(def)
    def.tiles = {"blank.png", def.tiles[1]}
    def.groups.not_in_creative_inventory = 1
    def.drop = "greek:shutters_" .. i
    def.on_rightclick = function(pos, node)
        minetest.swap_node(pos, {name = "greek:shutters_" .. i, param2 = node.param2})
        if minetest.get_modpath("doors") then minetest.sound_play("doors_door_close", {pos = pos}, true) end
    end

    minetest.register_node("greek:shutters_" .. i .. "_open", def)
end

greek.register_craftring("greek:shutters_%s", shutter_count)

minetest.register_craft({
    output = "greek:shutters_1 2",
    recipe = {
        {"greek:blue_wood", "", "greek:blue_wood"},
        {"greek:blue_wood", "", "greek:blue_wood"},
    },
})
