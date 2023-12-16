-- Lit nodes.

minetest.register_node("greek:fire_bowl", {
    description = "Fire Bowl",
    drawtype = "mesh",
    mesh = "greek_fire_bowl.obj",
    tiles = {"greek_fire_bowl.png", "blank.png"},
    inventory_image = "greek_fire_bowl_inv.png",
    use_texture_alpha = "clip",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    place_param2 = 0,
    selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}},
    collision_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}},
    groups = {cracky = 3, oddly_breakable_by_hand = 2},
    sounds = greek.default_sounds("node_sound_glass_defaults"),
    on_place = function(stack, placer, pointed)
        -- If placed against ceiling, set to hanging fire bowl
        if pointed.under.y > pointed.above.y then stack:set_name("greek:fire_bowl_hanging") end
        local leftover = minetest.item_place(stack, placer, pointed)
        leftover:set_name("greek:fire_bowl")
        return leftover
    end,
    on_punch = function(pos, _, puncher)
        for _, group in pairs({"fire", "igniter", "torch"}) do
            if minetest.get_item_group(puncher:get_wielded_item():get_name(), group) > 0 then
                return minetest.swap_node(pos, {name = "greek:fire_bowl_lit"})
            end
        end
    end,
})

minetest.register_node("greek:fire_bowl_lit", {
    description = "Fire Bowl (Lit)",
    drawtype = "mesh",
    mesh = "greek_fire_bowl.obj",
    tiles = {"greek_fire_bowl.png", {name = "greek_fire.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1}}},
    inventory_image = "greek_fire_bowl_lit_inv.png",
    use_texture_alpha = "clip",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    place_param2 = 0,
    selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}},
    collision_box = {type = "fixed", fixed = {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}},
    light_source = 12,
    drop = greek.settings_get("fire_bowl_dig_snuff") and "greek:fire_bowl" or nil,
    groups = {cracky = 3, oddly_breakable_by_hand = 2, torch = 1},
    sounds = greek.default_sounds("node_sound_glass_defaults"),
    on_place = function(stack, placer, pointed)
        if pointed.under.y > pointed.above.y then stack:set_name("greek:fire_bowl_hanging_lit") end
        local leftover = minetest.item_place(stack, placer, pointed)
        leftover:set_name("greek:fire_bowl_lit")
        return leftover
    end,
    on_punch = function(pos, _, puncher)
        for _, group in pairs({"water", "liquid", "water_bucket"}) do
            if minetest.get_item_group(puncher:get_wielded_item():get_name(), group) > 0 then
                return minetest.swap_node(pos, {name = "greek:fire_bowl"})
            end
        end
    end,
})

minetest.register_node("greek:fire_bowl_hanging", {
    description = "Hanging Fire Bowl (You hacker, you)",
    drawtype = "mesh",
    mesh = "greek_fire_bowl_hanging.obj",
    tiles = {"greek_fire_bowl.png", "blank.png", "greek_chain.png"},
    use_texture_alpha = "clip",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    selection_box = {type = "fixed", fixed = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5}},
    collision_box = {type = "fixed", fixed = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5}},
    groups = {cracky = 3, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
    sounds = greek.default_sounds("node_sound_glass_defaults"),
    drop = "greek:fire_bowl",
    on_punch = function(pos, _, puncher)
        for _, group in pairs({"fire", "igniter", "torch"}) do
            if minetest.get_item_group(puncher:get_wielded_item():get_name(), group) > 0 then
                return minetest.swap_node(pos, {name = "greek:fire_bowl_hanging_lit"})
            end
        end
    end,
})

minetest.register_node("greek:fire_bowl_hanging_lit", {
    description = "Hanging Fire Bowl (Lit) (You hacker, you)",
    drawtype = "mesh",
    mesh = "greek_fire_bowl_hanging.obj",
    tiles = {"greek_fire_bowl.png", {name = "greek_fire.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 1}}, "greek_chain.png"},
    use_texture_alpha = "clip",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    selection_box = {type = "fixed", fixed = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5}},
    collision_box = {type = "fixed", fixed = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5}},
    light_source = 12,
    groups = {cracky = 3, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
    sounds = greek.default_sounds("node_sound_glass_defaults"),
    drop = greek.settings_get("fire_bowl_dig_snuff") and "greek:fire_bowl" or "greek:fire_bowl_lit",
    on_punch = function(pos, _, puncher)
        for _, group in pairs({"water", "liquid", "water_bucket"}) do
            if minetest.get_item_group(puncher:get_wielded_item():get_name(), group) > 0 then
                return minetest.swap_node(pos, {name = "greek:fire_bowl_hanging"})
            end
        end
    end,
})

minetest.register_craft({
    output = "greek:fire_bowl 2",
    recipe = {
        {"greek:marble_polished", "", "greek:marble_polished"},
        {"", "greek:gilded_gold", ""},
    },
})

minetest.register_node("greek:lamp", {
    description = "Lamp",
    drawtype = "mesh",
    mesh = "greek_lamp.obj",
    tiles = {
        {name = "greek_lamp.png"},
        {name = "greek_lamp.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 4, length = 1}}
    },
    inventory_image = "greek_lamp_inv.png",
    wield_image = "greek_lamp_inv.png",
    use_texture_alpha = "clip",
    paramtype = "light",
    sunlight_propagates = true,
    paramtype2 = "facedir",
    selection_box = {type = "fixed", fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -0.25, 6 / 16}},
    collision_box = {type = "fixed", fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -0.25, 6 / 16}},
    light_source = 8,
    groups = {cracky = 3, oddly_breakable_by_hand = 2, torch = 1},
    sounds = greek.default_sounds("node_sound_glass_defaults"),
})

minetest.register_craft({
    output = "greek:lamp 2",
    recipe = {
        {"group:greek:red_clay", "", "group:greek:red_clay"},
        {"", "group:greek:red_clay", ""},
    },
})
