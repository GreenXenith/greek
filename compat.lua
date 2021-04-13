-- Aliases for legacy greeknodes mod

local nodes = {
    {"marble_cobble", "marble_cobble"},
    {"polished_marble", "marble_polished"},
    {"polished_marble_block", "marble_polished_block"},
    {"pillar", "marble_pillar"},
    {"pillar_head_dioric", "marble_pillar_head_doric"},
    {"pillar_head_corinthian", "marble_pillar_head_corinthian"},
    {"pillar_head_ionic", "marble_pillar_head_ionic"},
    {"marble_tile", "marble_tile_1"},
    {"gilded_gold_block", "gilded_gold"},
}

for _, pair in pairs(nodes) do
    minetest.register_alias("greeknodes:" .. pair[1], "greek:" .. pair[2])
end

local stairs = {
    {"marblepillar_stair", "marble_pillar"},
    {"marblecobble_stair", "marble_cobble"},
    {"polishedmarble_stair", "marble_polished"},
    {"polishedmarbleblock_stair", "marble_polished_block"},
    {"marbletile_stair", "marble_tile_1"},
    {"gilded_gold_stair", "gilded_gold"},
}

for _, shape in pairs({"stair_", "slab_", "stair_inner_", "stair_outer_"}) do
    for _, pair in pairs(stairs) do
        minetest.register_alias("stairs:" .. shape .. pair[1], "greek:" .. shape .. pair[2])
    end
end

if greek.settings_get("alias_polished_marble") then
    minetest.register_alias("greeknodes:marble", "greek:marble_polished")
else
    minetest.register_on_mods_loaded(function()
        for _, item in ipairs(greek.settings_list("marble")) do
            if minetest.registered_nodes[item] then
                return minetest.register_alias("greeknodes:marble", item)
            end
        end
        error("\n[greek] Compatibility mode is enabled but no valid marble was found to alias 'greeknodes:marble'." ..
              "\nPlease give greek.marble a valid marble item or disable compatibility mode (greek.greeknodes_aliases = false).\n")
    end)
end

local alias_tar = greek.settings_get("alias_tar")
minetest.register_alias("greeknodes:tar_base", alias_tar and "building_blocks:tar_base" or "")
minetest.register_alias("greeknodes:tar", alias_tar and "building_blocks:Tar" or "")
