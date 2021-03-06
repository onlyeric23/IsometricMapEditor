local TileSprite = require("sprites.TileSprite")

local Action = {}

Action.TYPE_PASTE_TILE = 1
Action.TYPE_CLEAN_TILE = 2

Action.list = {}

Action.currentIdx = 0
Action.size = 0

Action.add = function(action)
	if Action.size == Action.currentIdx then
		Action.size = Action.size+1
	else
		Action.size = Action.currentIdx+1
	end
	Action.currentIdx = Action.currentIdx+1
	Action.list[Action.currentIdx] = action
	--print("action list size:", #Action.list)
end

Action.exec = function(action)
	if action.type == Action.TYPE_CLEAN_TILE then
		action.world[action.layerId]:cleanAt(action.posX, action.posY)
	elseif action.type == Action.TYPE_PASTE_TILE then
		local tile = TileSprite.new(action.tileTag, action.tileName)
		action.world[action.layerId]:setTileAt(tile, action.posX, action.posY)
	end
end

Action.reverse = function(action)
	local t = nil
	local tag = nil
	local name = nil

	if action.preTileTag and action.preTileName then
		t = Action.TYPE_PASTE_TILE
		tag = action.preTileTag
		name = action.preTileName
	else
		t = Action.TYPE_CLEAN_TILE
	end
	return Action.new(
		t, 
		action.world, 
		action.layerId, 
		action.posX, 
		action.posY, 
		{
			tileTag = tag,
			tileName = name
		}
	)
end

Action.todo = function(action)
	Action.exec(action)
	Action.add(action)
end

Action.undo = function()
	if Action.currentIdx == 0 then
		print("no action can be undo")
		return
	end
	Action.exec(Action.reverse(Action.list[Action.currentIdx]))
	Action.currentIdx = Action.currentIdx-1
end

Action.redo = function()
	if Action.currentIdx == Action.size then
		print("no action can be redo")
		return
	end
	Action.currentIdx = Action.currentIdx+1
	Action.exec(Action.list[Action.currentIdx])
end

Action.new = function(type, world, layerId, posX, posY, options)
	local tileTag = options and options.tileTag or nil
	local tileName = options and options.tileName or nil
	local preTileTag = options and options.preTileTag or nil
	local preTileName = options and options.preTileName or nil

	local action = {}
	action.type = type
	action.world = world
	action.layerId = layerId
	action.posX = posX
	action.posY = posY
	action.tileTag = tileTag
	action.tileName = tileName
	action.preTileTag = preTileTag
	action.preTileName = preTileName
	return action
end

return Action