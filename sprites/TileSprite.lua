local Sprite = require("sprites.Sprite")

local TileInfo = require("TileInfo")

local TileSprite = {}

TileSprite.new = function(tag, name)
	local sprite = Sprite[tag].new(name)

	sprite.anchorY = (sprite.height - TileInfo.height/2) /sprite.height
	sprite.name = name

	return sprite
end

return TileSprite