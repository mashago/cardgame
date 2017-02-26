
require("cardbase")

Card1 = {}
Card1 =
{
	new = function (self)
		local object = {}
		object = CardBase:new()
		setmetatable(object, self)
		return object
	end,

	id = 1,
	ctype = HERO,
	cost = 10,
	name = 'Boris Skullcrusher',
	star = 5,
	job = WARRIOR + HUMAN,
	camp = HUMAN,
	hp = 30, -- consider: fix and runtime
	power = 0, 
	skill_cost_energy = 4, -- how many energy to trigger skill
	skill_desc = 'ENERGY:4  Target opposing ally with cost 4 or less is killed',
	energy = 0,  -- need 3 round to 

	-- target is the target card
	-- tid is the num id, correspond to target_list[tid]
	-- normally, we should check something out of the scope
	-- in target_list[tid]
	trigger_target_validate = function(self, target, tid)
	end,

	trigger_skill = function(self)
		print("call Card1 trigger_skill")
	end,

}
setmetatable(Card1, CardBase)
Card1.__index = Card1
