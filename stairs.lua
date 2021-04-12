-- Mostly-custom stair implementation because I don't want to depend on other mods for content and
-- the default stairs implementation doesn't allow callbacks or return registered itemnames.

-- Rotation functions taken from minetest_game/stairs 2021/04/21
local function rotate_and_place(itemstack, placer, pointed_thing)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end

		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1

		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end

local function slab_place(itemstack, placer, pointed_thing)
    local under = minetest.get_node(pointed_thing.under)
    local wield_item = itemstack:get_name()
    local player_name = placer and placer:get_player_name() or ""

    if under and under.name:find("^stairs:slab_") then
        -- place slab using under node orientation
        local dir = minetest.dir_to_facedir(vector.subtract(
            pointed_thing.above, pointed_thing.under), true)

        local p2 = under.param2

        -- Placing a slab on an upside down slab should make it right-side up.
        if p2 >= 20 and dir == 8 then
            p2 = p2 - 20
        -- same for the opposite case: slab below normal slab
        elseif p2 <= 3 and dir == 4 then
            p2 = p2 + 20
        end

        -- else attempt to place node with proper param2
        minetest.item_place_node(ItemStack(wield_item), placer, pointed_thing, p2)
        if not minetest.is_creative_enabled(player_name) then
            itemstack:take_item()
        end
        return itemstack
    else
        return rotate_and_place(itemstack, placer, pointed_thing)
    end
end

-- Use up-to-date stairs function if found
if minetest.global_exists("stairs") then
    stairs.register_stair("_", nil, {}, {})
    stairs.register_slab("_", nil, {}, {})

    rotate_and_place = minetest.registered_nodes["stairs:stair__"].on_place
    slab_place = minetest.registered_nodes["stairs:slab__"].on_place

    minetest.unregister_item("stairs:stair__")
    minetest.unregister_item("stairs:slab__")
end

local stairdefs = {
    ["stair"] = {
        description = "%s Stair",
        node_box = {
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
        },
        on_place = rotate_and_place,
        recipes = {{
            {0, 0, 1},
            {0, 1, 1},
            {1, 1, 1},
        }, {
            {1, 0, 0},
            {1, 1, 0},
            {1, 1, 1},
        }},
        craft_total = 8,
    },
    ["slab"] = {
        description = "%s Slab",
        node_box = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
        on_place = slab_place,
        recipes = {{{1, 1, 1}}},
        craft_total = 6,
    },
    ["stair_inner"] = {
        description = "Inner %s Stair",
        node_box = {
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
            {-0.5, 0.0, -0.5, 0.0, 0.5, 0.0},
        },
        on_place = rotate_and_place,
        recipes = {{
            {0, 1, 0},
            {1, 1, 1},
            {1, 1, 1},
        }},
        craft_total = 8,
    },
    ["stair_outer"] = {
        description = "Outer %s Stair",
        node_box ={
            {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
            {-0.5, 0.0, 0.0, 0.0, 0.5, 0.5},
        },
        on_place = rotate_and_place,
        recipes = {{
            {0, 1, 0},
            {1, 1, 1},
        }},
        craft_total = 6,
    },
}

return function(node, definition, craftitem)
    for shape, data in pairs(stairdefs) do
        local itemname = node:gsub(":", ":" .. shape .. "_")
        local def = table.copy(definition)

        def.description = data.description:format(definition.description)
        def.drawtype = "nodebox"
        def.paramtype = "light"
        def.sunlight_propagates = definition.sunlight_propagates ~= false
        def.paramtype2 = definition.paramtype2:find("color") and "colorfacedir" or "facedir"
        def.node_box = {
            type = "fixed",
            fixed = data.node_box
        }
        def.on_place = data.on_place

        minetest.register_node(itemname, def)
        minetest.register_alias((itemname:gsub("^.+:", "stairs:")), itemname)

        if craftitem and data.recipes and data.craft_total then
            local items = {[0] = "", craftitem}
            local count = 0
            for _, recipe in pairs(data.recipes) do
                count = 0
                local filled = {}

                 -- Fill recipe template with items
                for row in pairs(recipe) do
                    filled[row] = {}
                    for col in pairs(recipe[row]) do
                        count = count + recipe[row][col] -- will be 0 or 1
                        filled[row][col] = items[recipe[row][col]]
                    end
                end

                minetest.register_craft({
                    output = itemname .. " " .. data.craft_total,
                    recipe = filled,
                })
            end

            -- Calculate reverse recipe (stair -> craftitem)
            local divbycount = data.craft_total % count == 0 -- GCF:1 ratio
            local divby2 = data.craft_total % 2 == 0 and count % 2 == 0 -- 2:1 ratio
            local rev = {} -- Reverse recipe
            for i = 1, ((divbycount and data.craft_total / count) or (divby2 and data.craft_total / 2) or data.craft_total) do
                rev[i] = itemname
            end

            minetest.register_craft({
                output = craftitem .. " " .. ((divbycount and 1) or (divby2 and count / 2) or count),
                recipe = rev,
                type = "shapeless",
            })
        end
    end
end
