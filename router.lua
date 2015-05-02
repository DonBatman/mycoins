function default.router_off_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;Powered Off...]"
	return formspec
end

function default.router_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[1,0;Powered On...]"..
		"label[2,0.5;Computers:]"..
		"label[2,0.8;Active: "..#active_computers.."]"..
		"label[2,1;Inactive: "..#inactive_computers.."]"..
		"label[4,0.5;Routers:]"..
		"label[4,0.8;Active: "..#active_routers.."]"..
		"label[4,1;Inactive: "..#inactive_routers.."]"..
		"label[6,0.5;ISP:]"..
		"label[6,0.8;Active: "..#active_isp.."]"..
		"label[6,1;Inactive: "..#inactive_isp.."]"..
		"button_exit[4,7;2,1;exit;Exit]"
	return formspec
end

function default.router_error_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;No Networks Available...]"
	return formspec
end

function default.find_network(pos)
	active_computers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:home_computer_active","mycoins:game_computer_active","mycoins:alien_computer_active"})
	inactive_computers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:home_computer","mycoins:game_computer","mycoins:alien_computer"})
	active_routers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:router_on"})
	inactive_routers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:router"})	
	active_isp = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:isp_on"})
	inactive_isp = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:isp"})
end

local function router_owner(meta, player)
	if player:get_player_name() ~= meta:get_string("owner") then
		return false
	end
	return true
end

--WIFI Router
minetest.register_node("mycoins:router_on", {
	description = "WIFI Router",
	tiles = {"mycoins_router_t.png","mycoins_router_bt.png","mycoins_router_l.png","mycoins_router_r.png","mycoins_router_b.png",
			{name="mycoins_router_f_animated.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.0}},}, --"mycoins_router_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = true,
	groups = {snappy=3, not_in_creative_inventory = 1},
	sound = default.node_sound_wood_defaults(),
	drop = "mycoins:router",
	drawtype = "nodebox",
	light_source = 4,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.0625, 0.25, -0.375, 0.3125},
			{-0.1875, -0.4375, 0.3125, -0.125, -0.1875, 0.375},
			{0.125, -0.4375, 0.3125, 0.1875, -0.1875, 0.375},
			{-0.0625, -0.4375, 0.3125, 0.0625, -0.25, 0.375},
			},
		},
	on_punch = function(pos)
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = 'mycoins:router', param2 = node.param2})
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.router_off_formspec(pos))
		meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
	end,
	on_timer = function(pos)
		default.find_network(pos)
		local isp = minetest.find_node_near(pos, 30, {"mycoins:isp_on"})
		if isp == nil then
			local timer = minetest.get_node_timer(pos)
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_error', param2 = node.param2})
			meta:set_string("formspec", default.router_error_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
			timer:start(10)
		else
			local timer = minetest.get_node_timer(pos)
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
			meta:set_string("formspec", default.router_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
			timer:start(10)
		end
	end,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local timer = minetest.get_node_timer(pos)
		meta:set_string("formspec", default.router_formspec(pos))
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		timer:start(10)
	end,
	on_construct = function(pos)
		default.find_network(pos)
		local isp = minetest.find_node_near(pos, 30, {"mycoins:isp_on"})
		if isp == nil then
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_error', param2 = node.param2})
			meta:set_string("formspec", default.router_error_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		else
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
			meta:set_string("formspec", default.router_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		end
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos);
		return router_owner(meta, player)
	end,
})

minetest.register_node("mycoins:router", {
	description = "WIFI Router",
	tiles = {"mycoins_router_t.png","mycoins_router_bt.png","mycoins_router_l.png","mycoins_router_r.png","mycoins_router_b.png", "mycoins_router_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = true,
	groups = {snappy=3},
	sound = default.node_sound_wood_defaults(),
	drop = "mycoins:router",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.0625, 0.25, -0.375, 0.3125},
			{-0.1875, -0.4375, 0.3125, -0.125, -0.1875, 0.375},
			{0.125, -0.4375, 0.3125, 0.1875, -0.1875, 0.375},
			{-0.0625, -0.4375, 0.3125, 0.0625, -0.25, 0.375},
			},
		},
	on_punch = function(pos)
		local isp = minetest.find_node_near(pos, 30, {"mycoins:isp_on"})
		default.find_network(pos)
		if isp == nil then
			local timer = minetest.get_node_timer(pos)
			local meta = minetest.get_meta(pos)
			local node = minetest.get_node(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_error', param2 = node.param2})
			meta:set_string("formspec", default.router_error_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
			timer:start(10)
		else
			local timer = minetest.get_node_timer(pos)
			local meta = minetest.get_meta(pos)
			local node = minetest.get_node(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
			meta:set_string("formspec", default.router_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
			timer:start(10)
		end
	end,
	on_timer = function(pos)
		default.find_network(pos)
		local timer = minetest.get_node_timer(pos)
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		minetest.swap_node(pos, {name = 'mycoins:router', param2 = node.param2})
		meta:set_string("formspec", default.router_off_formspec(pos))
		meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		timer:stop()
	end,
	after_place_node = function(pos, placer)
		local timer = minetest.get_node_timer(pos)
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.router_formspec(pos))
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		timer:start(10)
	end,
	on_construct = function(pos)
		default.find_network(pos)
		local isp = minetest.find_node_near(pos, 30, {"mycoins:isp_on"})
		if isp == nil then
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_error', param2 = node.param2})
			meta:set_string("formspec", default.router_error_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		else
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
			meta:set_string("formspec", default.router_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		end
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos);
		return router_owner(meta, player)
	end,
})

minetest.register_node("mycoins:router_error", {
	description = "WIFI Router",
	tiles = {"mycoins_router_t.png","mycoins_router_bt.png","mycoins_router_l.png","mycoins_router_r.png","mycoins_router_b.png",
			{name="mycoins_router_f_error.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.0}},}, --"mycoins_router_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = true,
	groups = {snappy=3, not_in_creative_inventory = 1},
	sound = default.node_sound_wood_defaults(),
	drop = "mycoins:router",
	drawtype = "nodebox",
	light_source = 4,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.0625, 0.25, -0.375, 0.3125},
			{-0.1875, -0.4375, 0.3125, -0.125, -0.1875, 0.375},
			{0.125, -0.4375, 0.3125, 0.1875, -0.1875, 0.375},
			{-0.0625, -0.4375, 0.3125, 0.0625, -0.25, 0.375},
			},
		},
	on_punch = function(pos)
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = 'mycoins:router', param2 = node.param2})
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.router_off_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
	end,
	on_timer = function(pos)
		default.find_network(pos)
		local isp = minetest.find_node_near(pos, 30, {"mycoins:isp_on"})
		if isp == nil then
			local timer = minetest.get_node_timer(pos)
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_error', param2 = node.param2})
			meta:set_string("formspec", default.router_error_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
			timer:start(10)
		else
			local timer = minetest.get_node_timer(pos)
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
			meta:set_string("formspec", default.router_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
			timer:start(10)
		end
		
	end,
	on_construct = function(pos)
		local isp = minetest.find_node_near(pos, 30, {"mycoins:isp_on"})
		if isp == nil then
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_error', param2 = node.param2})
			meta:set_string("formspec", default.router_error_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		else
			local node = minetest.get_node(pos)
			local meta = minetest.get_meta(pos)
			minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
			meta:set_string("formspec", default.router_formspec(pos))
			meta:set_string("infotext", "Router (owner "..meta:get_string("owner")..")")
		end
	end,
	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos);
		return router_owner(meta, player)
	end,
})


