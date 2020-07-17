-- Marble
minetest.register_node("greeknodes:marble_cobble", {
	description = "Marble Cobble",
	tiles = {"greeknodes_marble_cobble.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:polished_marble", {
	description = "Polished Marble",
	tiles = {"greeknodes_marble_polished.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:polished_marble_block", {
	description = "Polished Marble Block",
	tiles = {"greeknodes_marble_polished_block.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:pillar", {
	description = "Marble Pillar",
	paramtype2 = "facedir",
	tiles = {"greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_side.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("greeknodes:pillar_head_dioric", {
	description = "Marble Pillar Head (Dioric)",
	tiles = {"greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_head_dioric.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:pillar_head_corinthian", {
	description = "Marble Pillar Head (Corinthian)",
	tiles = {"greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_head_corinthian.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:pillar_head_ionic", {
	description = "Marble Pillar Head (Ionic)",
	paramtype2 = "facedir",
	tiles = {"greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_head_ionic_side.png", "greeknodes_marble_pillar_head_ionic_side.png", "greeknodes_marble_pillar_head_ionic.png", "greeknodes_marble_pillar_head_ionic.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:marble_tile", {
	description = "Marble Tile",
	tiles = {"greeknodes_marble_tile.png"},
	groups = {cracky = 3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("greeknodes:gilded_gold_block", {
	description = "Gilded Gold Block",
	tiles = {"greeknodes_gilded_gold.png"},
	groups = {cracky = 3, oddly_breakable_by_hand = 1},
	sounds = default.node_sound_metal_defaults(),
})

-- Stairs & Slabs
stairs.register_stair_and_slab(
	"marblepillar_stair",
	"greeknodes:pillar",
	{cracky = 3},
	{"greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_top.png", "greeknodes_marble_pillar_side.png"},
	"Marble Pillar Stair",
	"Marble Pillar Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"marblecobble_stair",
	"greeknodes:marble_cobble",
	{cracky = 3},
	{"greeknodes_marble_cobble.png"},
	"Marble Cobble Stair",
	"Marble Cobble Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"polishedmarble_stair",
	"greeknodes:polished_marble",
	{cracky = 3},
	{"greeknodes_marble_polished.png"},
	"Polished Marble Stair",
	"Polished Marble Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"polishedmarbleblock_stair",
	"greeknodes:polished_marble_block",
	{cracky = 3},
	{"greeknodes_marble_polished_block.png"},
	"Polished Marble Block Stair",
	"Polished Marble Block Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"marbletile_stair",
	"greeknodes:marble_tile",
	{cracky = 3},
	{"greeknodes_marble_tile.png"},
	"Marble Tile Stair",
	"Marble Tile Slab",
	default.node_sound_stone_defaults()
)

stairs.register_stair_and_slab(
	"gilded_gold_stair",
	"greeknodes:gilded_gold_block",
	{cracky = 3},
	{"greeknodes_gilded_gold.png"},
	"Gilded Gold Block Stair",
	"Gilded Gold Block Slab",
	default.node_sound_metal_defaults()
)

minetest.register_craft({
	type = "cooking",
	output = "greeknodes:gilded_gold_block",
	recipe = "default:goldblock",
	cooktime = 25,
})

minetest.register_craft({
	output = 'greeknodes:polished_marble 9',
	recipe = {
		{'building_blocks:Marble', 'building_blocks:Marble', 'building_blocks:Marble'},
		{'building_blocks:Marble', 'building_blocks:Marble', 'building_blocks:Marble'},
		{'building_blocks:Marble', 'building_blocks:Marble', 'building_blocks:Marble'},
	}
})

minetest.register_craft({
	output = 'greeknodes:polished_marble_block 4',
	recipe = {
		{'greeknodes:polished_marble', 'greeknodes:polished_marble'},
		{'greeknodes:polished_marble', 'greeknodes:polished_marble'},
	}
})

minetest.register_craft({
	output = 'greeknodes:marble_cobble 5',
	recipe = {
		{'greeknodes:polished_marble', '', 'greeknodes:polished_marble'},
		{'', 'greeknodes:polished_marble', ''},
		{'greeknodes:polished_marble', '', 'greeknodes:polished_marble'},
	}
})

minetest.register_craft({
	output = 'greeknodes:pillar_head_dioric 2',
	recipe = {
		{'greeknodes:pillar'},
		{'greeknodes:pillar'},
	}
})

minetest.register_craft({
	output = 'greeknodes:pillar_head_ionic 4',
	recipe = {
		{'greeknodes:pillar', '', 'greeknodes:pillar'},
		{'', 'greeknodes:pillar', ''},
		{'', 'greeknodes:pillar', ''},
	}
})

minetest.register_craft({
	output = 'greeknodes:pillar_head_corinthian 9',
	recipe = {
		{'greeknodes:pillar', 'greeknodes:pillar', 'greeknodes:pillar'},
		{'greeknodes:pillar', 'greeknodes:pillar', 'greeknodes:pillar'},
		{'greeknodes:pillar', 'greeknodes:pillar', 'greeknodes:pillar'},
	}
})

minetest.register_craft({
	output = 'greeknodes:marble_tile 4',
	recipe = {
		{'building_blocks:Marble', 'building_blocks:Marble'},
		{'building_blocks:Marble', 'building_blocks:Marble'},
	}
})

if minetest.get_modpath("homedecor") then
	minetest.register_craft({
		output = 'greeknodes:pillar 2',
		recipe = {
			{'building_blocks:Marble'},
			{'building_blocks:Marble'},
		}
	})

	minetest.register_alias("greeknodes:marble", "building_blocks:Marble")
	minetest.register_alias("greeknodes:tar", "building_blocks:Tar")
	minetest.register_alias("greeknodes:tar_base", "building_blocks:tar_base")
else
	minetest.register_node("greeknodes:marble", {
		description = "Marble",
		tiles = {"greeknodes_marble.png"},
		is_ground_content = true,
		groups = {cracky = 3, marble = 1},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = 'greeknodes:pillar 2',
		recipe = {
			{'greeknodes:marble'},
			{'greeknodes:marble'},
		}
	})

	minetest.register_craft({
		type = "fuel",
		recipe = "greeknodes:tar",
		burntime = 40,
	})

	minetest.register_craft({
		type = "cooking",
		output = "greeknodes:tar",
		recipe = "greeknodes:tar_base",
	})

	minetest.register_craftitem("greeknodes:tar_base", {
		description = "Tar Base",
		image = "greeknodes_tar_base.png",
	})

	minetest.register_craft({
		output = "greeknodes:marble 9",
		recipe = {
			{"default:clay", "greeknodes:tar", "default:clay"},
			{"greeknodes:tar","default:clay", "greeknodes:tar"},
			{"default:clay", "greeknodes:tar","default:clay"},
		}
	})

	minetest.register_node("greeknodes:tar", {
		description = "Tar",
		tiles = {"greeknodes_tar_block.png"},
		is_ground_content = true,
		groups = {crumbly = 1, tar_block = 1},
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = 'greeknodes:tar_base 2',
		recipe = {
			{"default:coal_lump", "default:gravel"},
			{"default:gravel", "default:coal_lump"}
		}
	})

	minetest.register_craft({
		output = 'greeknodes:tar_base 2',
		recipe = {
			{"default:gravel", "default:coal_lump"},
			{"default:coal_lump", "default:gravel"}
		}
	})

	minetest.register_alias("building_blocks:Marble", "greeknodes:marble")
	minetest.register_alias("building_blocks:Tar", "greeknodes:tar")
	minetest.register_alias("building_blocks:tar_base", "greeknodes:tar_base")
end

