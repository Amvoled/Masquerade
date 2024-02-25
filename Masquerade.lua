--- STEAMODDED HEADER
--- MOD_NAME: Masquerade
--- MOD_ID: Masquerade
--- MOD_AUTHOR: [Amavoleda]
--- MOD_DESCRIPTION: Allows multiple card sprites to coexist and be randomly picked when displayed

-- Monkeypatching the function picking the sprites from the atlas
local vanilla_set_sprite_pos = Sprite.set_sprite_pos
function Sprite:set_sprite_pos(sprite_pos)
	if sprite_pos and sprite_pos.alts then  -- We only process cards that have a "alt" value in their atlas coordinates
		local choice = math.random(0, #sprite_pos.alts)
		if choice > 0 then  -- If choice is 0, we consider we randomly picked the standard sprite and don't change anything
			sprite_pos = {x = sprite_pos.alts[choice].x, y = sprite_pos.alts[choice].y} -- Creating a new sprite_pos from an alt sprite
		end
	end
	vanilla_set_sprite_pos(self, sprite_pos)  -- Calling the vanilla unmodified function (or the function that a mod loaded before us defined)
end

-- Register an alternative sprite for a given card
function add_card_alt_sprite(card, x, y)
	if not G.P_CENTERS[card].pos.alts then
		G.P_CENTERS[card].pos.alts = {{x = x, y = y}}
		return
	end
	G.P_CENTERS[card].pos.alts.insert({x = x, y = y})
end

-- Delete all alternative sprites for a card
function del_card_alt_sprite(card)
	G[card].pos.alts = nil
end

-- Mod test, add the drunken joker as an alt skin for all jokers
function _drunk_test()
	for k, v in pairs(G.P_CENTERS) do
 		if v.set == "Joker" then
			add_card_alt_sprite(k, 1, 1)
		end
	end
end

function SMODS.INIT.Masquerade()
	--  UNCOMMENT LINE BELOW TO RUN THE DRUNK TEST
	-- _drunk_test()
end
