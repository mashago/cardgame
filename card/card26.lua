
require("cardbase")

Card26 = {}
Card26 =
{
	new = function (self)
		local object = {}
		object = CardBase:new()
		setmetatable(object, self)
		return object
	end,

	id = 26,
	ctype = ALLY,
	job = HUMAN,
	camp = HUMAN,
	name = 'Puwen Bloodhelm',
	star = 2,
	cost = 2,  
	power = 2,
	hp = 3,  
	skill_desc = '',
}
setmetatable(Card26, CardBase)
Card26.__index = Card26
