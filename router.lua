function default.router_off_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;Powered Off...]"
	return formspec
end


function default.router_formspec(pos)


local active_computers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:home_computer_active","mycoins:game_computer_active","mycoins:alien_computer_active"})


local inactive_computers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:home_computer","mycoins:game_computer","mycoins:alien_computer"})

	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;Powered On...]"..
		"label[2,2.5;Active: "..#active_computers.."]"..
		"label[2,2.8;Inactive: "..#inactive_computers.."]"..
		"button_exit[4,7;2,1;exit;Exit]"
	return formspec
end





--WIFI Router (linksys look-a-like)
minetest.register_node("mycoins:router_on", {
	description = "WIFI Router Powered On",
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
		meta:set_string("infotext", "Router")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.router_formspec(pos))
		meta:set_string("infotext", "Router")
	end,
})

minetest.register_node("mycoins:router", {
	description = "WIFI Router Powered Off",
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
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = 'mycoins:router_on', param2 = node.param2})
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.router_formspec(pos))
		meta:set_string("infotext", "Router")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.router_off_formspec(pos))
		meta:set_string("infotext", "Router")
	end,
})




