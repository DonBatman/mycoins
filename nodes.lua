
local function computer_owner(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end
 
function default.computer_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;Booting a proprietary OS, this could take a while...]" ..
		"list[nodemeta:".. spos .. ";main;1,3;8,1;]"..
		"list[current_player;main;1,6;8,4;]"
	return formspec
end
 
function default.active_computer_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;Mining coins.]" ..
		"label[2,2.5;Upgrade your computer to mine faster.]" ..
		"list[nodemeta:".. spos .. ";main;1,3;8,1;]"..
		"list[current_player;main;1,6;8,4;]"
	return formspec
end

-- Home Computer

minetest.register_node("mycoins:home_computer",{
	drawtype = "nodebox",
	description = "Home Computer",
	tiles = {"mycoins_home_computer_tp.png",
	      "mycoins_home_computer_bt.png",
			"mycoins_home_computer_rt.png",
			"mycoins_home_computer_lt.png",
			"mycoins_home_computer_bk.png",
			"mycoins_home_computer_ft_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "mycoins:home_computer",
	groups = {cracky=2, oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,0.03125,0.500000,0.500000,0.40625},
			{-0.40625,-0.40625,0.40625,0.40625,0.40625,0.50000},
			{-0.500000,-0.500000,-0.500000,0.500000,-0.375,-0.03125},
		},
	},
	
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local timer = minetest.get_node_timer(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Home Computer (owner "..
		meta:get_string("owner")..")")
		timer:start(60)
		end,
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		local meta = minetest.get_meta(pos)
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = 'mycoins:home_computer_active', param2 = node.param2})
		meta:set_string("formspec", default.active_computer_formspec(pos))
		meta:set_string("infotext", "Home Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		timer:start(1300)
		end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.computer_formspec(pos))
		meta:set_string("infotext", "Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		return computer_owner(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a home computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a home computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in home computer at "..minetest.pos_to_string(pos))
	end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to home computer at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from home computer at "..minetest.pos_to_string(pos))
	end,

})

minetest.register_node("mycoins:home_computer_active",{
	drawtype = "nodebox",
	description = "Home Computer",
	tiles = {"mycoins_home_computer_tp.png",
	      "mycoins_home_computer_bt.png",
			"mycoins_home_computer_rt.png",
			"mycoins_home_computer_lt.png",
			"mycoins_home_computer_bk.png",
			"mycoins_home_computer_ft.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	drop = "mycoins:home_computer",
	groups = {cracky=2, not_in_creative_inventory=1, oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,0.03125,0.500000,0.500000,0.40625},
			{-0.40625,-0.40625,0.40625,0.40625,0.40625,0.50000},
			{-0.500000,-0.500000,-0.500000,0.500000,-0.375,-0.03125},
		},
	},
	sounds = default.node_sound_wood_defaults(),
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
		timer:start(1300)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and computer_owner(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a home computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a home computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in home computer at "..minetest.pos_to_string(pos))
	end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to home computer at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from home computer at "..minetest.pos_to_string(pos))
	end,
})

-- Game Computer

minetest.register_node("mycoins:game_computer",{
	drawtype = "nodebox",
	description = "Gaming Computer",
	tiles = {"mycoins_game_computer_tp.png",
	      "mycoins_game_computer_bt.png",
			"mycoins_game_computer_rt.png",
			"mycoins_game_computer_lt.png",
			"mycoins_game_computer_bk.png",
			"mycoins_game_computer_ft_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "mycoins:game_computer",
	groups = {cracky=2, oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,0.03125,0.500000,0.500000,0.40625},
			{-0.40625,-0.40625,0.40625,0.40625,0.40625,0.50000},
			{-0.500000,-0.500000,-0.500000,0.500000,-0.375,-0.03125},
		},
	},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local timer = minetest.get_node_timer(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Gaming Computer (owner "..
		meta:get_string("owner")..")")
		timer:start(50)
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.computer_formspec(pos))
		meta:set_string("infotext", "Gaming Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		return computer_owner(meta, player)
	end,
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		local meta = minetest.get_meta(pos)
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = 'mycoins:game_computer_active', param2 = node.param2})
		meta:set_string("formspec", default.active_computer_formspec(pos))
		meta:set_string("infotext", "Gaming Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		timer:start(800)
		end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a gaming computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a gaming computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in gaming computer at "..minetest.pos_to_string(pos))
	end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to gaming computer at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from gaming computer at "..minetest.pos_to_string(pos))
	end,

})

minetest.register_node("mycoins:game_computer_active",{
	drawtype = "nodebox",
	description = "Home Computer",
	tiles = {"mycoins_game_computer_tp.png",
	      "mycoins_game_computer_bt.png",
			"mycoins_game_computer_rt.png",
			"mycoins_game_computer_lt.png",
			"mycoins_game_computer_bk.png",
			"mycoins_game_computer_ft.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	drop = "mycoins:game_computer",
	groups = {cracky=2, not_in_creative_inventory=1, oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,0.03125,0.500000,0.500000,0.40625},
			{-0.40625,-0.40625,0.40625,0.40625,0.40625,0.50000},
			{-0.500000,-0.500000,-0.500000,0.500000,-0.375,-0.03125},
		},
	},
	
	sounds = default.node_sound_wood_defaults(),
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and computer_owner(meta, player)
	end,
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
		timer:start(800)
		end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a gaming computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locked chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a gaming computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in gaming computer at "..minetest.pos_to_string(pos))
	end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to gaming computer at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from gaming computer at "..minetest.pos_to_string(pos))
	end,
})

-- Alienware Computer

minetest.register_node("mycoins:alien_computer",{
	drawtype = "nodebox",
	description = "Alienware Computer",
	tiles = {"mycoins_alien_computer_tp.png",
	      "mycoins_alien_computer_bt.png",
			"mycoins_alien_computer_rt.png",
			"mycoins_alien_computer_lt.png",
			"mycoins_alien_computer_bk.png",
			"mycoins_alien_computer_ft_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "mycoins:alien_computer",
	groups = {cracky=2, oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,0.03125,0.500000,0.500000,0.40625},
			{-0.40625,-0.40625,0.40625,0.40625,0.40625,0.50000},
			{-0.500000,-0.500000,-0.500000,0.500000,-0.375,-0.03125},
		},
	},
	
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local timer = minetest.get_node_timer(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Alienware Computer (owner "..
		meta:get_string("owner")..")")
		timer:start(40)
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.computer_formspec(pos))
		meta:set_string("infotext", "Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		return computer_owner(meta, player)
	end,
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		local meta = minetest.get_meta(pos)
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = 'mycoins:alien_computer_active', param2 = node.param2})
		meta:set_string("formspec", default.active_computer_formspec(pos))
		meta:set_string("infotext", "Alienware Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		timer:start(600)
		end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a alineware computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a alineware computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a alineware computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in alineware computer at "..minetest.pos_to_string(pos))
	end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to alineware computer at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from alineware computer at "..minetest.pos_to_string(pos))
	end,

})

minetest.register_node("mycoins:alien_computer_active",{
	drawtype = "nodebox",
	description = "Alienware Computer",
	tiles = {"mycoins_alien_computer_tp.png",
	      "mycoins_alien_computer_bt.png",
			"mycoins_alien_computer_rt.png",
			"mycoins_alien_computer_lt.png",
			"mycoins_alien_computer_bk.png",
			"mycoins_alien_computer_ft.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	drop = "mycoins:alien_computer",
	groups = {cracky=2, not_in_creative_inventory=1, oddly_breakable_by_hand=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,0.03125,0.500000,0.500000,0.40625},
			{-0.40625,-0.40625,0.40625,0.40625,0.40625,0.50000},
			{-0.500000,-0.500000,-0.500000,0.500000,-0.375,-0.03125},
		},
	},
	
	sounds = default.node_sound_wood_defaults(),
	on_timer = function(pos)
		local timer = minetest.get_node_timer(pos)
		minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
		timer:start(600)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and computer_owner(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a home computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a alineware computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not computer_owner(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a home computer belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in home computer at "..minetest.pos_to_string(pos))
	end,
   on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to alineware computer at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from home computer at "..minetest.pos_to_string(pos))
	end,
})
