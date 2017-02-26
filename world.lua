
require('util')
require('common')
require('cardfactory')
require('country')
require('effect')

--[[
game world
include 2 country


--]]

World = {}
World =
{
	round = 1,
	current = 1,
	phase = PHASE_SACRIFICE,
	card_factory = {},	
	country_list = {},
	all_card_map = {},
	eff_list = {},

	new = function (self, origin_card_list)
		local object = {}
		setmetatable(object, self)
		self.card_factory = CardFactory:new(origin_card_list)
		return object
	end,
	
	
	print = function (self)
		LOG_DEBUG('#all_card_map=%d', #self.all_card_map)
		--[[
		for k, v in ipairs(self.all_card_map) do
			v:print()
		end
		--]]

		for _, v in ipairs(self.country_list) do
			v:print()
			printf('\n')
		end
		printf('round=%d current=%d phase=%d\n', self.round, self.current, self.phase)

	end,
}
World.__index = World

World.country_init = nil
World.logic_init = nil
World.card_init_field = nil
World.logic_init_test = nil

World.add_effect = nil
World.clean_effect = nil

World.index_card = nil

World.broadcast_card_leave = nil
World.broadcast_card_join = nil
World.broadcast_card_calculate_attack = nil
World.broadcast_card_be_killed = nil

World.phase_change = nil

World.play_sacrifice = nil
World.play_attack = nil
World.play_ability = nil
World.play_next = nil
World.play_cmd = nil

function World:country_init() --{
	for side = 1, 2 do
		-- country new and init
		local country = Country:new()
		if false == country:init(self, side) then
			printf('country[%d] init fail\n', side)
			return false
		end
		self.country_list[side] = country
	end
	return true
end --}

-- deck_list = {{{1[as hero]},{22, 25, 27,...[as normal]}}, {{hero},{normal}}}
function World:logic_init(deck_list) -- {
	if deck_list == nil or #deck_list < 2 then
		printf('deck list error\n')
		return false
	end

	local card_factory = self.card_factory

	if not self:country_init() then
		printf('country_init fail\n')
	end

	for side = 1, #deck_list do
		local deck = deck_list[side]
		if deck[1] == nil or #deck[1] ~= 1 then
			return false
		end
		if deck[2] == nil or #deck[2] == 0 then
			return false
		end
		
		local country = self.country_list[side]

		-- TODO 
		-- shuffle card
		-- create card
		-- add into hero and deck field
		-- draw card from field

		-- create and add hero card
		local cid = deck[1][1]
		local hero = card_factory:create_card(cid, self, country)
		if hero == nil then
			printf('country[%d] hero%d nil\n', side, cid)
			return false
		end
		self.all_card_map[hero.index] = hero
		country:card_add(hero, F_HERO)

		-- create and add normal card
		for __, cid in ipairs(deck[2]) do
			local card = card_factory:create_card(cid, self, country)
			if card == nil then
				printf('country[%d] card%d nil\n', side, cid)
				return false
			end
			self.all_card_map[card.index] = card
			country:card_add(card, F_DECK)
		end
	end
	
	return true
end -- }

function World:card_init_field(side, field_index, card_list) -- {
	local card_factory = self.card_factory
	local country = self.country_list[side]
	for __, cid in ipairs(card_list) do
		local card = card_factory:create_card(cid, self, country)
		if card == nil then
			printf('country[%d] card%d nil\n', side, cid)
			return false
		end
		self.all_card_map[card.index] = card
		country:card_add(card, field_index)
	end
	return true

end -- }

function World:logic_init_test() -- {
	local card_factory = self.card_factory

	if not self:country_init() then
		printf('country_init fail\n')
	end

	local side = 1
	self:card_init_field(side, F_HERO, {1})
	self:card_init_field(side, F_DECK, {22, 22, 22, 22, 22})
	self:card_init_field(side, F_HAND, {22, 22, 22})
	self:card_init_field(side, F_ALLY, {22, 26})

	side = 2
	self:card_init_field(side, F_HERO, {1})
	self:card_init_field(side, F_DECK, {26, 26, 26, 26, 26})
	self:card_init_field(side, F_HAND, {26, 26, 26})
	self:card_init_field(side, F_ALLY, {22, 26})

	return true
end -- }

-- EFFECT --{
function World:add_effect(eff) --{
	self.eff_list = self.eff_list or {}
	effect_append(self.eff_list, eff)
end --}

function World:clean_effect() --{
	self.eff_list = {}
end --}
-- EFFECT --}
	
function World:index_card(index) --{
	return self.all_card_map[index]
end --}

-- BROADCAST --{
function World:broadcast_card_leave(card) --{
end --}

function World:broadcast_card_join(card) --{
end --}

function World:broadcast_card_calculate_attack(card, power) --{
	
end --}

function World:broadcast_card_be_killed(card, residence)
	
end --}

-- BROADCAST --}

function World:phase_change(phase) --{
	self.phase = phase
	self:add_effect(eff_phase(phase))
end --}

function World:play_sacrifice(index) --{

	index = index or 0

	if self.phase ~= PHASE_SACRIFICE then
		return false, ERROR_MSG('non sac phase')
	end

	-- sacrifice nothing
	if index == 0 then
		self:phase_change(PHASE_PLAY)
		return true
	end

	-- get sac card
	local card = self:index_card(index)
	if card == nil then
		return false, ERROR_MSG('sac card nil')
	end

	local country = card.residence
	-- check is current side
	if country.side ~= self.current then
		return false, ERROR_MSG('sac oppo card')
	end

	-- check is hand card
	if card.field ~= F_HAND then
		return false, ERROR_MSG('sac non hand')
	end

	-- card move
	card:action_move(country, F_RES)

	-- update res
	country.resource_max = country.resource_max + 1
	country.resource = country.resource_max

	self:add_effect(eff_resource_max_offset(self.current, 1))
	self:add_effect(eff_resource_offset(self.current, 1))

	-- change phase
	self:phase_change(PHASE_PLAY)

	return true
end --}

function World:play_summon(index) --{
	local card = self:index_card(index)
	if card == nil then
		return false, ERROR_MSG('summon card nil')
	end

	card:action_move(card.residence, F_ALLY)
end --}

function World:check_attack(src, target)
	return true
end

function World:play_attack(src_index, target_index) --{

	if src_index == nil or src_index == 0 then
		return false, ERROR_MSG('attack: no src')
	end
	if target_index == nil or target_index == 0 then
		return false, ERROR_MSG('attack: no target')
	end

	local src = self:index_card(src_index)
	if src == nil then
		return false, ERROR_MSG('attack: src nil')
	end
	local target = self:index_card(target_index)
	if target == nil then
		return false, ERROR_MSG('attack: target nil')
	end

	local flag, msg = self:check_attack(src, target)
	if flag == false then
		return false, ERROR_MSG('attack: %s', msg)
	end

	local src_ambush = src:is_ambush()
	local target_defender = target:is_defender()

	repeat
	if target_defender ~= true or (src_ambush == true and target_defender == true) then
		src:action_attack(target, false)

		if target:is_dead() then
			src:action_kill(target)
			target:action_be_killed(src)
			return true
		end

		if src_ambush then
			-- target cannot defend
			break
		end

		target:action_attack(src, true)

		if src:is_dead() then
			target:action_kill(src)
			src:action_be_killed(src)
		end

	else
		-- defender defend first
		target:action_attack(src, true)

		if src:is_dead() then
			target:action_kill(src)
			src:action_be_killed(src)
			return true
		end

		src:action_attack(target, false)

		if target:is_dead() then
			src:action_kill(target)
			target:action_be_killed(src)
			return true
		end

	end
	until true

	-- TODO trigger_combat ?

	return true
end --}

function World:play_ability(cmd_list) --{
end --}

function World:play_next() --{
end --}

function World:play_cmd(cmd_list) --{
	self:clean_effect()
	local flag, err
	local cmd = cmd_list[1]
	table.remove(cmd_list, 1)

	if cmd == 'x' then
		flag, err = self:play_sacrifice(cmd_list[1])
	end

	if self.phase ~= PHASE_PLAY then
		return false, ERROR_MSG('in phase sacrifice')
	end
	if cmd == 's' then
		flag, err = self:play_summon(cmd_list[1])
	elseif cmd == 't' then
		flag, err = self:play_attack(cmd_list[1], cmd_list[2])
	elseif cmd == 'b' then
		flag, err = self:play_ability(cmd_list)
	elseif cmd == 'n' then
		flag, err = self:play_next()
	end
	return flag, err
end --}
