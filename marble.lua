-- Polished marble nodes

greek.marble_groups = {cracky = 2}
greek.marble_sounds = greek.default_sounds("node_sound_stone_defaults")

greek.register_node_and_stairs("greek:marble_polished", {
    description = "Polished Marble",
    tiles = {"greek_marble_polished.png"},
    groups = greek.marble_groups,
    sounds = greek.marble_sounds,
})

for _, item in pairs(greek.settings_list("marble")) do
    greek.add_group(item, "marble")
end

minetest.register_craft({
    output = "greek:marble_polished 9",
    recipe = {
        {"group:greek:marble", "group:greek:marble", "group:greek:marble"},
        {"group:greek:marble", "group:greek:marble", "group:greek:marble"},
        {"group:greek:marble", "group:greek:marble", "group:greek:marble"},
    },
})

minetest.register_craft({
    output = "greek:marble_polished",
    recipe = "greek:marble_cobble",
    type = "cooking",
    cooktime = 5,
})

greek.register_node_and_stairs("greek:marble_polished_block", {
    description = "Polished Marble Block",
    tiles = {"greek_marble_polished_block.png"},
    groups = greek.marble_groups,
    sounds = greek.marble_sounds,
})

minetest.register_craft({
    output = "greek:marble_polished_block 4",
    recipe = {
        {"greek:marble_polished", "greek:marble_polished"},
        {"greek:marble_polished", "greek:marble_polished"},
    }
})

greek.register_node_and_stairs("greek:marble_cobble", {
    description = "Marble Cobble",
    tiles = {"greek_marble_cobble.png"},
    groups = greek.marble_groups,
    sounds = greek.marble_sounds,
})

minetest.register_craft({
    output = "greek:marble_cobble 5",
    recipe = {
        {"greek:marble_polished", "", "greek:marble_polished"},
        {"", "greek:marble_polished", ""},
        {"greek:marble_polished", "", "greek:marble_polished"},
    },
})

-- Marble pillars
greek.register_node_and_stairs("greek:marble_pillar", {
    description = "Marble Pillar",
    tiles = {"greek_marble_pillar_top.png", "greek_marble_pillar_top.png", "greek_marble_pillar_side.png"},
    paramtype2 = "facedir",
    groups = greek.marble_groups,
    sounds = greek.marble_sounds,
    on_place = minetest.rotate_node,
})

minetest.register_craft({
    output = "greek:marble_pillar 2",
    recipe = {
        {"greek:marble_polished"},
        {"greek:marble_polished"},
    },
})

local pillar_heads = {"doric", "ionic", "corinthian"}

for _, head in pairs(pillar_heads) do
    minetest.register_node("greek:marble_pillar_head_" .. head, {
        description = head:gsub("^%l", string.upper) .. " Marble Pillar Head",
        tiles = {"greek_marble_pillar_top.png", "greek_marble_pillar_top.png", "greek_marble_pillar_head_" .. head .. ".png"},
        paramtype2 = "facedir",
        groups = greek.marble_groups,
        sounds = greek.marble_sounds,
        on_place = minetest.rotate_node,
    })

    minetest.register_node("greek:marble_pillar_base_" .. head, {
        description = head:gsub("^%l", string.upper)  .. " Marble Pillar Base",
        tiles = {"greek_marble_pillar_top.png", "greek_marble_pillar_top.png", "greek_marble_pillar_base_" .. head .. ".png"},
        paramtype2 = "facedir",
        groups = greek.marble_groups,
        sounds = greek.marble_sounds,
        on_place = minetest.rotate_node,
    })
end

-- Ionic pillar head has some special side tiles
minetest.override_item("greek:marble_pillar_head_ionic", {
    tiles = {
        "greek_marble_pillar_top.png", "greek_marble_pillar_top.png",
        "greek_marble_pillar_head_ionic_side.png", "greek_marble_pillar_head_ionic_side.png",
        "greek_marble_pillar_head_ionic.png", "greek_marble_pillar_head_ionic.png",
    },
})

greek.register_craftring("greek:marble_pillar_head_%s", pillar_heads)
greek.register_craftring("greek:marble_pillar_base_%s", pillar_heads)

minetest.register_craft({
    output = "greek:marble_pillar_head_" .. pillar_heads[1] .. " 4",
    recipe = {
        {"greek:marble_pillar", "greek:marble_polished", "greek:marble_pillar"},
        {"", "greek:marble_pillar", ""},
    },
})

minetest.register_craft({
    output = "greek:marble_pillar_base_" .. pillar_heads[1] .. " 4",
    recipe = {
        {"", "greek:marble_pillar", ""},
        {"greek:marble_pillar", "greek:marble_polished", "greek:marble_pillar"},
    },
})

-- Carved marble tiles
local tile_total = 6

for i = 1, tile_total do
    greek.register_node_and_stairs("greek:marble_tile_" .. i, {
        description = "Marble Tile " .. i,
        tiles = {"greek_marble_tile_" .. i .. ".png"},
        paramtype2 = "facedir",
        groups = greek.marble_groups,
        sounds = greek.marble_sounds,
    })
end

greek.register_craftring("greek:marble_tile_%s", tile_total)

minetest.register_craft({
    output = "greek:marble_tile_1 4",
    recipe = {
        {"greek:marble_polished_block", "greek:marble_polished_block"},
        {"greek:marble_polished_block", "greek:marble_polished_block"},
    }
})

-- Painted marble tiles
-- type name = {total, list of recipe shapes}
local types = {
    center = {12, {{
        {0, 1, 0},
        {1, 1, 1},
        {0, 1, 0},
    }}},
    corner = {12, {
        {{1, 0, 0}, {1, 0, 0}, {1, 1, 1}},
        {{0, 0, 1}, {0, 0, 1}, {1, 1, 1}},
        {{1, 1, 1}, {0, 0, 1}, {0, 0, 1}},
        {{1, 1, 1}, {1, 0, 0}, {1, 0, 0}}
    }},
    edge = {12, {{
        {1, 0, 1},
        {0, 1, 0},
        {1, 0, 1},
    }}}
}

-- Palette colors and corresponding dyes
local dyes = {["dye:blue"] = 0, ["dye:yellow"] = 1, ["dye:black"] = 2, ["dye:red"] = 3, ["dye:orange"] = 4, ["dye:green"] = 5, ["dye:violet"] = 6, ["dye:pink"] = 7}

for type, data in pairs(types) do
    local total = data[1]
    for i = 1, total do
        local name = ("greek:marble_painted_%s_%s"):format(type, i)
        local tile = ("greek_marble_painted_%s_%s.png"):format(type, i)

        local registered = greek.register_node_and_stairs(name, {
            description = ("Painted %s Marble %s"):format(type:gsub("^%l", string.upper), i),
            tiles = {{name = "greek_marble_polished.png", color = "white"}},
            overlay_tiles = {tile, tile .. "^[transformFX", tile, tile .. "^[transformFY", tile .. "^[transformFX",  tile .. "^[transformR180"},
            paramtype2 = "colorfacedir",
            palette = "greek_marble_painted_palette.png",
            color = "#0058af", -- This is used for inventory color
            use_texture_alpha = true,
            groups = greek.marble_groups,
            sounds = greek.marble_sounds,
            on_punch = greek.dye_punch(dyes),
        })

        -- Recipes for coloring tiles
        for _, item in pairs(registered) do
            for dye, color in pairs(dyes) do
                minetest.register_craft({
                    output = minetest.itemstring_with_palette(item, color * 32),
                    recipe = {item, dye},
                    replacements = not greek.settings_get("consume_dye") and {{dye, dye}} or nil,
                    type = "shapeless",
                })
            end
        end
    end

    greek.register_craftring("greek:marble_painted_" .. type .. "_%s", total)

    -- Use specific dye to craft colored tile
    -- Is it possible to have a fallback group:dye recipe to output black? (mixed dyes)
    for dye, color in pairs(dyes) do
        -- Fill recipe template with items
        local items = {[0] = "greek:marble_polished", dye}
        for _, recipe in pairs(data[2]) do
            local filled = {}
            for row in pairs(recipe) do
                filled[row] = {}
                for col in pairs(recipe[row]) do
                    filled[row][col] = items[recipe[row][col]]
                end
            end

            minetest.register_craft({
                output = minetest.itemstring_with_palette(("greek:marble_painted_%s_1 4"):format(type), color * 32),
                recipe = filled,
            })
        end
    end
end
