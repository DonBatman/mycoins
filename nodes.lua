
local function has_home_computer_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end
 
function default.home_computer_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"list[nodemeta:".. spos .. ";main;1,3;8,1;]"..
		"list[current_player;main;1,6;8,4;]"
	return formspec
end

local function has_game_computer_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end
 
function default.game_computer_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"list[nodemeta:".. spos .. ";main;1,3;8,1;]"..
		"list[current_player;main;1,6;8,4;]"
	return formspec
end

local function has_alien_computer_privilege(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end
 
function default.alien_computer_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"list[nodemeta:".. spos .. ";main;1,3;8,1;]"..
		"list[current_player;main;1,6;8,4;]"
	return formspec
end



-- Home Computer

minetest.register_node("bitcoins:home_computer",{
	drawtype = "nodebox",
	description = "Home Computer",
	tiles = {"bitcoins_home_computer_tp.png",
	      "bitcoins_home_computer_bt.png",
			"bitcoins_home_computer_rt.png",
			"bitcoins_home_computer_lt.png",
			"bitcoins_home_computer_bk.png",
			"bitcoins_home_computer_ft_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "bitcoins:home_computer",
	groups = {cracky=2},
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
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Home Computer (owner "..
		meta:get_string("owner")..")")
		-- hacky_swap_node(pos,"bitcoins:game_computer_active")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.game_computer_formspec(pos))
		meta:set_string("infotext", "Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_home_computer_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_home_computer_privilege(meta, player) then
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
		if not has_home_computer_privilege(meta, player) then
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
		if not has_home_computer_privilege(meta, player) then
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

minetest.register_node("bitcoins:home_computer_active",{
	drawtype = "nodebox",
	description = "Home Computer",
	tiles = {"bitcoins_home_computer_tp.png",
	      "bitcoins_home_computer_bt.png",
			"bitcoins_home_computer_rt.png",
			"bitcoins_home_computer_lt.png",
			"bitcoins_home_computer_bk.png",
			"bitcoins_home_computer_ft.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	drop = "bitcoins:home_computer",
	groups = {cracky=2, not_in_creative_inventory=1},
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
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Home Computer (owner "..
		meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.home_computer_formspec(pos))
		meta:set_string("infotext", "Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		minetest.get_node_timer(pos):start(1300,0)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_home_computer_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_home_computer_privilege(meta, player) then
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
		if not has_home_computer_privilege(meta, player) then
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
		if not has_home_computer_privilege(meta, player) then
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

minetest.register_node("bitcoins:game_computer",{
	drawtype = "nodebox",
	description = "Gaming Computer",
	tiles = {"bitcoins_game_computer_tp.png",
	      "bitcoins_game_computer_bt.png",
			"bitcoins_game_computer_rt.png",
			"bitcoins_game_computer_lt.png",
			"bitcoins_game_computer_bk.png",
			"bitcoins_game_computer_ft_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "bitcoins:game_computer",
	groups = {cracky=2},
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
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Gaming Computer (owner "..
		meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.game_computer_formspec(pos))
		meta:set_string("infotext", "Gaming Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_game_computer_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_game_computer_privilege(meta, player) then
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
		if not has_game_computer_privilege(meta, player) then
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
		if not has_game_computer_privilege(meta, player) then
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

minetest.register_node("bitcoins:game_computer_active",{
	drawtype = "nodebox",
	description = "Home Computer",
	tiles = {"bitcoins_game_computer_tp.png",
	      "bitcoins_game_computer_bt.png",
			"bitcoins_game_computer_rt.png",
			"bitcoins_game_computer_lt.png",
			"bitcoins_game_computer_bk.png",
			"bitcoins_game_computer_ft.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	drop = "bitcoins:game_computer",
	groups = {cracky=2, not_in_creative_inventory=1},
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
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Gaming Computer (owner "..
		meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.game_computer_formspec(pos))
		meta:set_string("infotext", "Gaming Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		minetest.get_node_timer(pos):start(800,0)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_game_computer_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_game_computer_privilege(meta, player) then
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
		if not has_game_computer_privilege(meta, player) then
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
		if not has_game_computer_privilege(meta, player) then
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

minetest.register_node("bitcoins:alien_computer",{
	drawtype = "nodebox",
	description = "Alienware Computer",
	tiles = {"bitcoins_alien_computer_tp.png",
	      "bitcoins_alien_computer_bt.png",
			"bitcoins_alien_computer_rt.png",
			"bitcoins_alien_computer_lt.png",
			"bitcoins_alien_computer_bk.png",
			"bitcoins_alien_computer_ft_off.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "bitcoins:alien_computer",
	groups = {cracky=2},
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
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Alienware Computer (owner "..
		meta:get_string("owner")..")")
		-- hacky_swap_node(pos,"bitcoins:game_computer_active")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.game_computer_formspec(pos))
		meta:set_string("infotext", "Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_alien_computer_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_alien_computer_privilege(meta, player) then
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
		if not has_alien_computer_privilege(meta, player) then
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
		if not has_alien_computer_privilege(meta, player) then
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

minetest.register_node("bitcoins:alien_computer_active",{
	drawtype = "nodebox",
	description = "Alienware Computer",
	tiles = {"bitcoins_alien_computer_tp.png",
	      "bitcoins_alien_computer_bt.png",
			"bitcoins_alien_computer_rt.png",
			"bitcoins_alien_computer_lt.png",
			"bitcoins_alien_computer_bk.png",
			"bitcoins_alien_computer_ft.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 8,
	drop = "bitcoins:alien_computer",
	groups = {cracky=2, not_in_creative_inventory=1},
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
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Alienware Computer (owner "..
		meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.alien_computer_formspec(pos))
		meta:set_string("infotext", "Computer")
		local inv = meta:get_inventory()
		inv:set_size("main", 4*2)
		minetest.get_node_timer(pos):start(600,0)
		end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_alien_computer_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_alien_computer_privilege(meta, player) then
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
		if not has_alien_computer_privilege(meta, player) then
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
		if not has_alien_computer_privilege(meta, player) then
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



