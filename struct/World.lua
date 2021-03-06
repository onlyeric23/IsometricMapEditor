local GameConfig = require("GameConfig")

local Layer = require("struct.Layer")

local World = {}

World.LAYER_SKY = 1
World.LAYER_GROUND = 0
World.LAYER_UNDERGROUND = -1

World.new = function(name, options)
	local world = display.newGroup()
	world.name = name

	local sky = Layer.new("sky", world, options)
	sky.x = 0
	sky.y = -GameConfig.layerDistance
	world:insert(sky)
	world.sky = sky

	local ground = Layer.new("ground", world, options)
	ground.x = 0
	ground.y = 0
	world:insert(ground)
	world.ground = ground

	local underground = Layer.new("underground", world, options)
	underground.x = 0
	underground.y = GameConfig.layerDistance
	world:insert(underground)
	world.underground = underground

	function world:toggleBoardVisible()
		self.sky:toggleBoardVisible()
		self.ground:toggleBoardVisible()
		self.underground:toggleBoardVisible()
	end

	return world
end

return World