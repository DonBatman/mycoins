
function default.isp_off_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[2,2;Powered Off...]"..
		"list[nodemeta:".. spos .. ";main;1,3;1,1;]"..
		"list[current_player;main;1,6;8,4;]"..
		"button_exit[4,5;2,1;exit;Exit]"
	return formspec
end

function default.isp_on_formspec(pos)
	local active_computers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:home_computer_active","mycoins:game_computer_active","mycoins:alien_computer_active"})
	local inactive_computers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:home_computer","mycoins:game_computer","mycoins:alien_computer"})
	local active_routers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:router_on"})
	local inactive_routers = minetest.find_nodes_in_area({x=pos.x-30, y=pos.y-30, z=pos.z-30}, {x=pos.x+30, y=pos.y+30, z=pos.z+30}, {"mycoins:router"})
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec = "size[10,10]"..
		"label[1,0;Powered On...]"..
		"label[2,0.6;Computers:]"..
		"label[2,0.8;Active: "..#active_computers.."]"..
		"label[2,1;Inactive: "..#inactive_computers.."]"..
		"label[4,0.6;Routers:]"..
		"label[4,0.8;Active: "..#active_routers.."]"..
		"label[4,1;Inactive: "..#inactive_routers.."]"..
		"label[1,2.6;Payment:]"..
		"list[nodemeta:".. spos .. ";main;1,3;1,1;]"..
		"list[current_player;main;1,6;8,4;]"..
		"button_exit[4,5;2,1;exit;Exit]"
	return formspec
end

-- ISP

minetest.register_node("mycoins:isp", {
	description = "Internet Service Provider",
	tiles = {
		"mycoins_isp_tp.png",
		"mycoins_isp_bt.png",
		"mycoins_isp_rt.png",
		"mycoins_isp_lt.png",
		"mycoins_isp_bk.png",
		"mycoins_isp_ft_off.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = true,
	groups = {snappy=3},
	sound = default.node_sound_wood_defaults(),
	drop = "mycoins:isp",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
				{-0.153531, -0.5, -0.405738, 0.153531, -0.315951, 0.405738}, -- NodeBox1
			{-0.122825, -0.315951, -0.374616, 0.122825, 0.371166, 0.375}, -- NodeBox2
			},
		},
	on_punch = function(pos)
		local timer = minetest.get_node_timer(pos)
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		minetest.swap_node(pos, {name = 'mycoins:isp_on', param2 = node.param2})
		meta:set_string("formspec", default.isp_on_formspec(pos))
		meta:set_string("infotext", "Internet Service Provider")
		local inv = meta:get_inventory()
		inv:set_size("main", 1*1)
		timer:stop()
	end,
	on_construct = function(pos)
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.isp_off_formspec(pos))
		meta:set_string("infotext", "Internet Service Provider")
		local inv = meta:get_inventory()
		inv:set_size("main", 1*1)
	end,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		local timer = minetest.get_node_timer(pos)
		meta:set_string("formspec", default.isp_on_formspec(pos))
		meta:set_string("infotext", "Internet Service Provider")
		local inv = meta:get_inventory()
		inv:set_size("main", 1*1)
		timer:start(60)
	end,
})

minetest.register_node("mycoins:isp_on", {
	description = "Internet Service Provider",
	tiles = {
		"mycoins_isp_tp.png",
		"mycoins_isp_bt.png",
		"mycoins_isp_rt.png",
		"mycoins_isp_lt.png",
		"mycoins_isp_bk.png",
		{name="mycoins_isp_f_animated.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.0}},}, --"mycoins_isp_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = true,
	groups = {snappy=3, not_in_creative_inventory = 1},
	sound = default.node_sound_wood_defaults(),
	drop = "mycoins:isp",
	drawtype = "nodebox",
	light_source = 4,
	node_box = {
		type = "fixed",
		fixed = {
				{-0.153531, -0.5, -0.405738, 0.153531, -0.315951, 0.405738}, -- NodeBox1
			{-0.122825, -0.315951, -0.374616, 0.122825, 0.371166, 0.375}, -- NodeBox2
			},
		},
	on_punch = function(pos)
		local timer = minetest.get_node_timer(pos)
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		minetest.swap_node(pos, {name = 'mycoins:isp', param2 = node.param2})
		meta:set_string("formspec", default.isp_off_formspec(pos))
		meta:set_string("infotext", "Internet Service Provider")
		local inv = meta:get_inventory()
		inv:set_size("main", 1*1)
		timer:start(5)
	end,

	on_timer = function(pos,from_list)
		local timer = minetest.get_node_timer(pos)
		local meta = minetest.get_meta(pos)
		minetest.get_meta(pos):get_inventory():add_item("main", "mycoins:bitcent")
		
		
		timer:start(5)
	end,

})