
require("common")

CardBase = {}
CardBase = 
{
	index = 0,
	residence = nil,
	field = 0,
	home = nil,

	new = function (self)

		local object = {}
		setmetatable(object, self)

		return object
	end,

	print = function (self)
		local str = ""
		str = string.format("%s(%d)[%d] cost:%d power:%d[%d] hp:%d [r:%d f:%d h:%d]"
		, self.name or "nil"
		, self.id or -1
		, self.index
		, self.cost or -1
		, self:get_power()
		, self:get_dtype()
		, self.hp or -1
		, self.residence.side
		, self.field
		, self.home.side
		)
		print(str)
	end,
}
CardBase.__index = CardBase

function CardBase:get_power() --{
	local total = 0

	total = self.power or 0
	if self.ctype == ATTACH then
		return total
	end

	-- if card is hero, get weapon power
	if self.ctype == HERO then
		local country = self.residence
		for k, v in ipairs(country.field_list[F_SUPPORT]) do
			if v.ctype == WEAPON then
				-- assume only one weapon
				total = v:get_power()
				break;
			end
		end
	end

	-- get attach list power
	for k, v in ipairs(self.attach_list or {}) do
		local power = v:get_power()
		total  = total + power
	end

	-- TODO check power offset

	if total < 0 then
		total = 0
	end

	return total
end --}

function CardBase:get_dtype() --{
	local dtype = self.dtype
	if self.ctype == ATTACH then
		return dtype
	end

	dtype = self.dtype or D_NORMAL
	if self.ctype == HERO then
		local country = self.residence
		for k, v in ipairs(country.field_list[F_SUPPORT]) do
			if v.ctype == WEAPON then
				-- assume only one weapon
				dtype = v:get_dtype()
				break;
			end
		end
	end

	for k, v in ipairs(self.attach_list or {}) do
		dtype = v:get_dtype() or dtype
	end

	return dtype
end --}

function CardBase:trigger_attack(...)
	print("call CardBase trigger_attack")
end

function CardBase:trigger_defend(...)
	print("call CardBase trigger_defend")
end

function CardBase:trigger_skill()
	print("call CardBase trigger_skill")
end
