
require("common")

CardBase = {}
CardBase = 
{
	index = 0,
	world = nil,
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

function CardBase:init(index, world, home)
	self.index = index
	self.world = world
	self.home = home
end

CardBase.get_power = nil
CardBase.get_dtype = nil
CardBase.is_ambush = nil
CardBase.is_defender = nil

CardBase.leave = nil
CardBase.join = nil
CardBase.attach = nil

CardBase.action_move = nil
CardBase.action_attach = nil

CardBase.trigger_leave = nil
CardBase.trigger_join = nil

CardBase.trigger_calculate_attack = nil
CardBase.trigger_calculate_other_attack = nil
CardBase.trigger_calculate_defend = nil
CardBase.trigger_calculate_other_defend = nil

CardBase.trigger_attack_base = nil
CardBase.trigger_attack = nil
CardBase.trigger_other_attack = nil
CardBase.trigger_defend = nil
CardBase.trigger_skill = nil


-- ATTRIBUTE --{

function CardBase:change_hp(offset) --{
	local total = self:get_hp()

	if total + offset < 0 then
		offset = -total
	end

	self.hp = self.hp + offset

	return offset
end --}

function CardBase:get_hp()
	local total = 0

	total = self.hp or 0
	if self.ctype == ATTACH then
		return total
	end

	-- get attach list hp
	for k, v in ipairs(self.attach_list or {}) do
		local hp = v:get_hp()
		total  = total + hp
	end

	if total < 0 then
		total = 0
	end

	return total
end

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
-- ATTRIBUTE --}

-- STATE --{
function CardBase:is_dead() --{
	if self:get_hp() == 0 then
		return true
	end

	if self.field == F_GRAVE then
		return true
	end

	return false
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
-- STATE --}

-- LOGIC CHECK --{
-- LOGIC CHECK --}

function CardBase:leave()
	self.world:add_effect(eff_leave(self.index))
	self:trigger_leave()
	self.world:broadcast_card_leave(self)
	self.residence:card_remove(self)
end

function CardBase:join(country, field)
	self.world:add_effect(eff_join(self.index, country.side, field))
	country:card_add(self, field)
	self:trigger_join()
	self.world:broadcast_card_join(self)
end

function CardBase:attach(target)
	self.world:add_effect(eff_attach(self.index, target.index))
	country:card_attach(self, target, field)
	self:trigger_attach()
	self.world:broadcast_card_attach(self, target)
end

-- ACTION --{
function CardBase:action_move(target_country, field)
	self:leave()
	self:join(target_country, field)
end

function CardBase:action_attach(target)
	self:leave()
	self:attach(target)
end

function CardBase:action_attack(target, is_defend)
	local power = self:get_power()
	local dtype = self:get_dtype()

	power = self:trigger_calculate_attack(target, power, dtype, is_defend)
	power = target:trigger_calculate_defend(self, power, dtype)

	power = -target:change_hp(-power)

	self.world:add_effect(eff_attack(self.index, target.index, power, dtype))
	-- target:trigger_take_damage(self, power, dtype)

	self:trigger_attack(target, power)
	target:trigger_defend(self, power)
end

function CardBase:action_kill(target)
end

function CardBase:action_be_killed(killer)
	self:trigger_be_killed(killer)	
	local residence = self.residence
	self:action_grave()
	self.world:broadcast_card_be_killed(self, residence)
end

function CardBase:action_grave()
	-- attach card action grave
	-- action move
	self:action_move(self.home, F_GRAVE)
	-- action refresh
end

function CardBase:action_refresh()
end

-- ACTION --}

-- TRIGGER --{

function CardBase:trigger_leave()
end

function CardBase:trigger_join()
end

function CardBase:trigger_calculate_attack_base(target, power, dtype, is_defend)
	return power
end

function CardBase:trigger_calculate_attack(target, power, dtype, is_defend)
	self:trigger_calculate_attack_base(target, power, dtype, is_defend)

	for _, v in ipairs(self.attach_list or {}) do
		v:trigger_calculate_attack_base(target, power,dtype, is_defend)
	end

	-- TODO update power by other card

	return power
end

function CardBase:trigger_calculate_other_attack(...)
	self:trigger_calculate_other_attack_base(...)

	for _, v in ipairs(self.attach_list or {}) do
		v:trigger_calculate_other_attack_base(...)
	end
end

function CardBase:trigger_calculate_defend_base(target, power, dtype)
	return power
end

function CardBase:trigger_calculate_defend(target, power, dtype)
	power = self:trigger_calculate_defend_base(target, power, dtype)

	for _, v in ipairs(self.attach_list or {}) do
		power = v:trigger_calculate_defend_base(target, power, dtype)
	end
	return power
end

function CardBase:trigger_attack_base(target, power)
end

function CardBase:trigger_attack(target, power)
	self:trigger_attack_base(target, power)

	for _, v in ipairs(self.attach_list or {}) do
		v:trigger_attack_base(target, power)
	end
end

function CardBase:trigger_defend_base(target, power)
end

function CardBase:trigger_defend(target, power)
	self:trigger_defend_base(target, power)

	for _, v in ipairs(self.attach_list or {}) do
		v:trigger_defend_base(target, power)
	end
end

function CardBase:trigger_be_killed(killer)
end

function CardBase:trigger_skill()
	print("call CardBase trigger_skill")
end
-- TRIGGER --}
