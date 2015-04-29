--WIFI Router (linksys look-a-like)
minetest.register_node("mycoins:router_on", {
	description = "WIFI Router Powered On",
	tiles = {"mycoins_router_t.png","mycoins_router_bt.png","mycoins_router_l.png","mycoins_router_r.png","mycoins_router_b.png",
			{name="mycoins_router_f_animated.png", animation={type="vertical_frames", aspect_w=32, aspect_h=32, length=1.0}},}, --"mycoins_router_f.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	is_ground_content = true,
	groups = {snappy=3},
	sound = default.node_sound_wood_defaults(),
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
	end,
})




