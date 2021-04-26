# Greek
_It's all Greek to me._  

This mod is completely dependency-agnostic, meaning no extra mods are required to have any content. Some mods are optionally required to provide certain crafting recipes (see [Dependencies](#dependencies)). All non-`greek` recipe items are configurable (see [Configuration](#configuration)).

![screenshot.png](screenshot.png)

## Contents
* Polished marble
* Carved marble tiles
* Painted marble tiles
* Marble pillars
* Marble detailing (acroterions, triglyphs, metopes)
* Gilded gold
* Vases
* Lamps and fire bowls
* Blue doors and shutters
* Stairs for most listed nodes

See [the complete item list](#full-lists) for more details.

## Dependencies
All listed dependencies are only defaults and are configurable unless noted otherwise.
* `stairs`: May provide more up-to-date stair placement functionality. Not required for stairs.
* `dye`: Used in numerous color recipes, mainly render and painted tiles (non-configurable).
* `darkage`: Provides marble and chalk (used in polished marble and cement, respectively).
* `building_blocks`: Provides marble for polished marble.
* `technic_worldgen`: Provides marble for polished marble.
* `default`: Provides silver sandstone (for cement), gold block (for gilded gold), clay (for red clay), and steel ingot (for locked doors). Also provides various `group:wood`s.
* `basic_materials`: Provides padlock for locked doors.

## Configuration
All craftitems are configurable via the `minetest.conf` using settings listed in [settingtypes.txt](settingtypes.txt). Craftitem settings use a comma-deliminated list of itemstrings. Each item listed, if available, will be used as a valid item in crafting recipes using that item type. Some `greek` implementations are included by default, but may be disabled by removing the items from their lists.  

Configurable item types:
* Marble: Used to craft polished marble. Polished marble is in turn used to craft all other marble-related items.   
  NOTE: If [greeknodes compaitibility](#compatibility) is enabled, at least one registered item must be in this list.
* Limestone: Used to craft cement for render.
* Cement: Used to craft render.
* Gold block: Used to craft gilded gold.
* Clay: Used to craft red clay.
* Blue wood: Used to craft doors and shutters.
* Lock: Used to craft locked doors.

Other settings:
* Stairs in creative inventory
* Dye consumption upon coloring
* Maximum vase capacity
* Snuff fire bowls on dig
* Enable `greeknodes` aliases
* Alias `greeknodes` marble to polished marble
* Alias `greeknodes` tar to building_blocks equivalents

See [settingtypes.txt](settingtypes.txt) for defaults.  

## Compatibility
This mod is the successor to my old `greeknodes` mod. Aliases are registered by default to convert old `greeknodes` items to `greek` items. For this to be successful, at least one valid marble item must be configured, or aliasing to polished marble must be enabled. Compatibility can be [disabled](#configuration) entirely, of course.

## Implementations
### Coloring
Some nodes (render, painted tiles) have 8 available colors variants. They can be obtained by combining them with a dye (dye is consumed by default) or punching a colorable node with a dye.

### Stairs
I need to be able to use dye punch-coloring on certain stairs (painted tile, render). Default stairs has two issues:
* Takes explicit definition values instead of a whole definition
* Doesn't return what items were actually registered

As such, I've rolled my own implementation near-identical to that of default stairs, but a bit more succinct and generic. I've used the rotation functions from default stairs, and it will poll for a more up-to-date function if default stairs is enabled.

### Doors
Depending on external mods for content would not be very dependency-agnostic, so I've opted to roll my own doors as simply as I could manage. My implementation is smaller and in some ways more naive than default doors, but it works as well as I'd like.

Doors are implemented using only 2 (a, b) nodes per type rather than 8 (a, b, c, d, for unlocked and locked). An open A door is identical to a closed B door, and vise-versa, provided the front and back of the door texture is identical. Locked doors are implemented using param2 palette index (locked doors have a silver handle). They can only be obtained via crafting.

Doors also support skeleton keys. As an extended key feature, you can bind already-bound keys to unbound doors.

### Craftrings
Some nodes have many near-identical variants (such as metopes). Rather than making a unique crafting recipe for each node, a "craftring" is registered to loop through all possible variants. Placing one version of the item in the crafting grid will output the next version. The last variant will return the first variant (to form the loop).

As crafting large amounts of certain variants can be tedious, variants can be copied. Placing 2 of a target variant in the crafting grid with another variant will output the target variant and keep the other 2 target variants.

```
+-+-+-+    +-+-+-+  +-+
|A|A|B| -> |A|A| |  |A|
+-+-+-+    +-+-+-+  +-+
```

## Todo
* Configurable sounds
* Translation support
* Posable statues
* ???

## Full Lists
<details><summary>Items</summary>

`*`: Has stairs  
`+`: Has colors  
`#`: Not craftable (but may be placable)  
`!`: Not obainable at all  

* `greek:acroterion`
* `greek:acroterion_corner`
* `greek:blue_wood`*
* `greek:cement`*+
* `greek:chain`
* `greek:door_<1-4>_<a,b>`
* `greek:door_blank`!
* `greek:fire_bowl`
* `greek:fire_bowl_hanging`#
* `greek:fire_bowl_hanging_lit`#
* `greek:fire_bowl_lit`#
* `greek:gilded_gold`*
* `greek:lamp`
* `greek:marble_cobble`*
* `greek:marble_painted_center_<1-12>`*+
* `greek:marble_painted_corner_<1-12>`*+
* `greek:marble_painted_edge_<1-12>`*+
* `greek:marble_pillar`*
* `greek:marble_pillar_base_corinthian`
* `greek:marble_pillar_base_doric`
* `greek:marble_pillar_base_ionic`
* `greek:marble_pillar_head_corinthian`
* `greek:marble_pillar_head_doric`
* `greek:marble_pillar_head_ionic`
* `greek:marble_polished`*
* `greek:marble_polished_block`*
* `greek:marble_tile_<1-6>`*
* `greek:metope_centaur_and_man`
* `greek:metope_chariot`
* `greek:metope_crowd`
* `greek:metope_gaurd`
* `greek:metope_horse`
* `greek:metope_horses`
* `greek:metope_man_kneeling`
* `greek:metope_man_laying`
* `greek:metope_man_standing`
* `greek:metope_rider`
* `greek:metope_three_men`
* `greek:metope_two_men`
* `greek:red_clay`
* `greek:red_clay_fired`*
* `greek:render`*+
* `greek:shutters_<1-3>[_closed]`
* `greek:triglyph`
* `greek:triglyph_blue`
* `greek:vase_amphora_<1-4>`
* `greek:vase_stamnos_<1-4>`
  
</details>


<details><summary>Recipes</summary>

`greek:acroterion 2`:  
```
M = greek:marble_polished
+-+-+-+
| |M| |
+-+-+-+
| |M| |
+-+-+-+
|M|M|M|
+-+-+-+

or

Shapeless (1) = greek:acroterion_corner
```

`greek:acroterion_corner 2`:  
```
M = greek:marble_polished
+-+-+-+
|M| | |
+-+-+-+
|M| | |
+-+-+-+
|M|M|M|
+-+-+-+
(Reversable)

or

Shapeless (1) = greek:acroterion
```

`greek:blue_wood`:  
```
Shapeless: dye:blue, group:wood
```

`greek:cement`:  
```
Cooking: group:greek:limestone
```

`greek:chain 12`:  
```
G = greek:gilded_gold
+-+
|G|
+-+
|G|
+-+
|G|
+-+
```

`greek:door_1_a 2`:  
```
W = group:greek:blue_wood
+-+-+
|W|W|
+-+-+
|W|W|
+-+-+
|W|W|
+-+-+
```

`greek:fire_bowl 2`:  
```
M = greek:marble_polished
G = greek:gilded_gold
+-+-+-+
|M| |M|
+-+-+-+
| |G| |
+-+-+-+
```

`greek:gilded_gold`:  
```
Cooking: group:greek:gold_block
```

`greek:lamp 2`:  
```
C = group:greek:red_clay
+-+-+-+
|C| |C|
+-+-+-+
| |C| |
+-+-+-+
```

`greek:marble_cobble 5`:  
```
M = greek:marble_polished
+-+-+-+
|M| |M|
+-+-+-+
| |M| |
+-+-+-+
|M| |M|
+-+-+-+
```

`greek:marble_painted_center_1 4`:  
```
M = greek:marble_polished
D = dye:*
+-+-+-+
|M|D|M|
+-+-+-+
|D|D|D|
+-+-+-+
|M|D|M|
+-+-+-+
```

`greek:marble_painted_corner_1 4`:  
```
M = greek:marble_polished
D = dye:*
+-+-+-+
|D|M|M|
+-+-+-+
|D|M|M|
+-+-+-+
|D|D|D|
+-+-+-+
(Rotatable)
```

`greek:marble_painted_edge_1 4`:  
```
M = greek:marble_polished
D = dye:*
+-+-+-+
|D|M|D|
+-+-+-+
|M|D|M|
+-+-+-+
|D|M|D|
+-+-+-+
```

`greek:marble_pillar 2`:  
```
M = greek:marble_polished
+-+
|M|
+-+
|M|
+-+
```

`greek:marble_pillar_base_doric 4`:  
```
M = greek:marble_polished
P = greek:marble_pillar
+-+-+-+
| |P| |
+-+-+-+
|P|M|P|
+-+-+-+
```

`greek:marble_pillar_head_doric 4`:  
```
M = greek:marble_polished
P = greek:marble_pillar
+-+-+-+
|P|M|P|
+-+-+-+
| |P| |
+-+-+-+
```

`greek:marble_polished 9`:  
```
M = group:greek:marble
+-+-+-+
|M|M|M|
+-+-+-+
|M|M|M|
+-+-+-+
|M|M|M|
+-+-+-+
```

`greek:marble_polished_block 4`:  
```
M = greek:marble_polished
+-+-+
|M|M|
+-+-+
|M|M|
+-+-+
```

`greek:marble_tile_1 4`:  
```
B = greek:marble_polished_block
+-+-+
|B|B|
+-+-+
|B|B|
+-+-+
```

`greek:metope_man_standing 2`:  
```
Shapeless: greek:marble_polished, group:greek:red_clay
```

`greek:red_clay 8`:  
```
C = group:greek:clay_lump
D = dye:red
+-+-+-+
|C|C|C|
+-+-+-+
|C|D|C|
+-+-+-+
|C|C|C|
+-+-+-+
```

`greek:red_clay_fired`:  
```
Cooking: group:greek:red_clay
```

`greek:render 2`:  
```
Shapeless: greek:cement, group:sand, group:water_bucket
Replacements: (group:water_bucket, bucket:bucket_empty)
```

`greek:shutters_1 2`:  
```
W = group:greek:blue_wood
+-+-+-+
|W| |W|
+-+-+-+
|W| |W|
+-+-+-+
```

`greek:triglyph 4`:  
```
M = greek:marble_polished
+-+-+-+
|M| |M|
+-+-+-+
|M| |M|
+-+-+-+

or

Shapeless (1): greek:triglyph_blue, dye:white
```

`greek:triglyph_blue`:  
```
Shapeless: greek:triglyph, dye:blue
```

`greek:vase_amphora_1 2`:  
```
C = group:greek:red_clay
+-+-+-+
|C| |C|
+-+-+-+
|C| |C|
+-+-+-+
|C|C|C|
+-+-+-+
```

`greek:vase_stamnos_1 2`:  
```
C = group:greek:red_clay
+-+-+-+
|C| |C|
+-+-+-+
|C|C|C|
+-+-+-+
```

Craftrings:
* `greek:door_*_a`
* `greek:marble_painted_center_*`
* `greek:marble_painted_corner_*`
* `greek:marble_painted_edge_*`
* `greek:marble_pillar_base_*`
* `greek:marble_pillar_head_*`
* `greek:marble_tile_*`
* `greek:metope_*`
* `greek:shutters_*`
* `greek:vase_amphora_*`
* `greek:vase_stamnos_*`

</details>
