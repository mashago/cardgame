
require("cardbase")

Card22 = {}
Card22 =
{
	new = function (self)
		local object = {}
		object = CardBase:new()
		setmetatable(object, self)
		return object
	end,

	id = 22,
	ctype = ALLY,
	job = HUMAN, 
	camp = HUMAN,
	name = 'Dirk Saber',
	star = 2,
	cost = 2,
	power = 2,
	hp = 2,  
	skill_desc = 'Ambush (attacks by this ally cannot be defended)',
	ambush = true,

}
setmetatable(Card22, CardBase)
Card22.__index = Card22
