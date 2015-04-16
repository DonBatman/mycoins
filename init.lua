
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- mycoins by MilesDyson@DistroGeeks.com                                              +
--                                                                                     +
-- LICENSE: WTFPL DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE; applies to all parts,   +
-- Including all images.                                                               +
--                                                                                     +
-- email me at milesdyson@distrogeeks.com                                              +
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


dofile(minetest.get_modpath("mycoins").."/nodes.lua")
dofile(minetest.get_modpath("mycoins").."/items.lua")
dofile(minetest.get_modpath("mycoins").."/crafts.lua")
dofile(minetest.get_modpath("mycoins").."/modrecipes.lua")


--= Change Home/Game/Alien Computer that isn't yours to active position

minetest.register_abm({
	nodenames = {"mycoins:home_computer", "mycoins:game_computer", "mycoins:alien_computer"},
	interval = 60.0,
	chance = 1,

	action = function(pos, node, active_object_count, active_object_count_wider)

		local meta = minetest.get_meta(pos)
		local owner = meta:get_string("owner")
		local name = minetest.get_node(pos).name
		local mine = minetest.get_player_by_name(owner)

		if name == "mycoins:home_computer" or name == "mycoins:game_computer" or name == "mycoins:alien_computer" then
			if mine then
				minetest.swap_node(pos, {name = name.."_active"})
			end
		end

	end,
})


--= Change Home/Game/Alien Computer that isn't yours back to inactive, if yours then collect coinage

minetest.register_abm({
	nodenames = {"mycoins:home_computer_active", "mycoins:game_computer_active", "mycoins:alien_computer_active"},
	interval = 2.0,
	chance = 1,

	action = function(pos, node, active_object_count, active_object_count_wider)

		local meta = minetest.get_meta(pos)
		local owner = meta:get_string("owner")
		local name = minetest.get_node(pos).name
		local mine = minetest.get_player_by_name(owner)
		local running = minetest.get_node_timer(pos)

		if name == "mycoins:home_computer_active" then
			if not mine then
				minetest.swap_node(pos, {name = "mycoins:home_computer"})
			else if (mine and running) then
				minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
				minetest.get_node_timer(pos):set(1300,0)
			end
		end
		end

		if name == "mycoins:game_computer_active" then
			if not mine then
				minetest.swap_node(pos, {name = "mycoins:game_computer"})
			else if (mine and running) then
				minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
				minetest.get_node_timer(pos):set(800,0)
			end
		end
		end


		if name == "mycoins:alien_computer_active" then
			if not mine then
				minetest.swap_node(pos, {name = "mycoins:alien_computer"})
			else if (mine and running) then
				minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
				minetest.get_node_timer(pos):set(600,0)
			end
		end
		end
	end,
})

print("mycoins mod loaded!")
