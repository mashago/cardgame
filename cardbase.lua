
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
		str = string.format("[%d]%s(%d) cost:%d power:%d[%d] hp:%d "
		, self.index
		, self.name or "nil"
		, self.id
		, self.cost or -1
		, self:get_power()
		, self:get_dtype()
		, self.hp or -1
		)

		if self:is_ambush() then
			str = str .. '[AM]'
		end
		if self:is_defender() then
			str = str .. '[DEF]'
		end

		str = str .. string.format(" [r:%d f:%d h:%d]"
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

function CardBase:is_ambush() --{
	local ambush = self.ambush or false
	if self.ctype == ATTACH then
		return ambush
	end

	if self.ctype == HERO then
		local country = self.residence
		for k, v in ipairs(country.field_list[F_SUPPORT]) do
			if v.ctype == WEAPON then
				-- assume only one weapon
				ambush = v:is_ambush() or ambush
				break;
			end
		end
	end

	for k, v in ipairs(self.attach_list or {}) do
		ambush = v:is_ambush() or ambush
	end

	return ambush
end --}

function CardBase:is_defender() --{
	local defender = self.defender or false
	if self.ctype == ATTACH then
		return defender
	end

	if self.ctype == HERO then
		local country = self.residence
		for k, v in ipairs(country.field_list[F_SUPPORT]) do
			if v.ctype == WEAPON then
				-- assume only one weapon
				defender = v:is_defender() or defender
				break;
			end
		end
	end

	for k, v in ipairs(self.attach_list or {}) do
		defender = v:is_defender() or defender
	end

	return defender
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
