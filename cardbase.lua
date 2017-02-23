
require("common")

CardBase = {}
CardBase = 
{
	index = 0,
	new = function (self)

		local object = {}
		setmetatable(object, self)

		return object
	end,

	print = function (self)
		local str = ""
		str = string.format("%s(%d)[%d] cost:%d power:%d hp:%d s:%d f:%d"
		, self.name or "nil"
		, self.id or -1
		, self.index
		, self.cost or -1
		, self.power or -1
		, self.hp or -1
		, self.side
		, self.field
		)
		print(str)
	end,
}
CardBase.__index = CardBase

function CardBase:trigger_attack(...)
	print("call CardBase trigger_attack")
end

function CardBase:trigger_defend(...)
	print("call CardBase trigger_defend")
end

function CardBase:trigger_skill()
	print("call CardBase trigger_skill")
end
