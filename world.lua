
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

	new = function (self, origin_card_list)
		local object = {}
		setmetatable(object, self)
		self.card_factory = CardFactory:new(origin_card_list)
		return object
	end,

	country_init = function(self)
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
	end,

	-- deck_list = {{{1[as hero]},{22, 25, 27,...[as normal]}}, {{hero},{normal}}}
	logic_init = function (self, deck_list)
	-- {
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
			local hero = card_factory:create_card(cid, country)
			if hero == nil then
				printf('country[%d] hero%d nil\n', side, cid)
				return false
			end
			self.all_card_map[hero.index] = hero
			country:card_add(hero, F_HERO)

			-- create and add normal card
			for __, cid in ipairs(deck[2]) do
				local card = card_factory:create_card(cid, country)
				if card == nil then
					printf('country[%d] card%d nil\n', side, cid)
					return false
				end
				self.all_card_map[card.index] = card
				country:card_add(card, F_DECK)
			end
		end
		
		return true
	end, -- }


	card_init_field = function(self, side, field_index, card_list)
	-- {
		local card_factory = self.card_factory
		local country = self.country_list[side]
		for __, cid in ipairs(card_list) do
			local card = card_factory:create_card(cid, country)
			if card == nil then
				printf('country[%d] card%d nil\n', side, cid)
				return false
			end
			self.all_card_map[card.index] = card
			country:card_add(card, field_index)
		end
		return true

	end, -- }

	logic_init_test = function(self)
	-- {
		local card_factory = self.card_factory

		if not self:country_init() then
			printf('country_init fail\n')
		end

		local side = 1
		self:card_init_field(side, F_HERO, {1})
		self:card_init_field(side, F_DECK, {22, 22, 22, 22, 22})
		self:card_init_field(side, F_HAND, {22, 22, 22})
		self:card_init_field(side, F_ALLY, {22, 22})

		side = 2
		self:card_init_field(side, F_HERO, {1})
		self:card_init_field(side, F_DECK, {26, 26, 26, 26, 26})
		self:card_init_field(side, F_HAND, {26, 26, 26})
		self:card_init_field(side, F_ALLY, {26, 26})

		return true
	end, -- }
	
	
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

function World:play_cmd(cmd_list) --{
	local eff_list, err
	local cmd = cmd_list[1]
	table.remove(cmd_list, 1)

	if cmd == 's' then
		eff_list, err = self:action_sacrifice(cmd_list[1])
	elseif cmd == 't' then
		eff_list, err = self:action_attack(cmd_list[1], cmd_list[2])
	elseif cmd == 'b' then
		eff_list, err = self:action_ability(cmd_list)
	elseif cmd == 'n' then
		eff_list, err = self:action_next()
	end
	return eff_list, err
end --}
	
function World:index_card(index) --{
	--[[
	for _, country in ipairs(self.country_list) do
		local card = country:index_card(index)	
		if card ~= nil then
			return card
		end
	end
	return nil
	--]]
	return self.all_card_map[index]
end --}

function World:card_remove(card) --{

	local country = card.residence
	if country == nil then
		return
	end

	country:card_remove(card)

end --}


function World:action_phase(phase) --{
	self.phase = phase
	local eff_list = eff_phase(phase)
	return eff_list
end --}

function World:action_sacrifice(index) --{

	index = index or 0

	if self.phase ~= PHASE_SACRIFICE then
		return nil, ERROR_MSG('non sac phase')
	end

	local eff_list = {}
	-- sacrifice nothing
	if index == 0 then
		effect_append(eff_list, self:action_phase(PHASE_PLAY))
		return eff_list
	end

	-- get sac card
	local card = self:index_card(index)
	if card == nil then
		return nil, ERROR_MSG('sac card nil')
	end

	if card.residence.side ~= self.current then
		return nil, ERROR_MSG('sac oppo card')
	end

	if card.field ~= F_HAND then
		return nil, ERROR_MSG('sac non hand')
	end

	-- card remove
	self:card_remove(card)
	effect_append(eff_list, eff_move(card.index, F_RES))

	-- update res
	local country = self.country_list[self.current]
	country.resource_max = country.resource_max + 1
	country.resource = country.resource_max

	effect_append(eff_list, eff_resource_max_offset(self.current, 1))
	effect_append(eff_list, eff_resource_offset(self.current, 1))

	-- change phase
	effect_append(eff_list, self:action_phase(PHASE_PLAY))

	return eff_list
end --}

function World:check_playable(card, is_ability) --{
	return true
end --}

function World:check_target(card, is_ability) --{
	return true
end --}

function World:action_damage(src, target, power) --{
end --}

function World:action_attack_one(src, target, is_defend) --{
	local eff_list = {}
	local eff_list2 = {}

	local power = src:get_power()
	local dtype = src:get_dtype()

	src:trigger_attack()

	for _, country in ipairs(self.country_list) do
		for __, card in ipairs(country.field_list[F_HERO]) do
			card:trigger_other_attack()
		end
		for __, card in ipairs(country.field_list[F_ALLY]) do
			card:trigger_other_attack()
		end
		for __, card in ipairs(country.field_list[F_SUPPORT]) do
			card:trigger_other_attack()
		end
	end
	
	self:action_damage(src, target, power)

end --}

function World:action_attack(src_index, target_index) --{

	if src_index == nil or src_index == 0 then
		return nil, ERROR_MSG('attack: no src')
	end
	if target_index == nil or target_index == 0 then
		return nil, ERROR_MSG('attack: no target')
	end

	local src = self:index_card(src_index)
	if src == nil then
		return nil, ERROR_MSG('attack: src nil')
	end
	local target = self:index_card(target_index)
	if target == nil then
		return nil, ERROR_MSG('attack: target nil')
	end

	local flag, msg = self:check_playable(src, false)
	if flag == false then
		return nil, ERROR_MSG('attack: %s', msg)
	end

	flag, msg = self:check_target(target, false)
	if flag == false then
		return nil, ERROR_MSG('attack: %s', msg)
	end

	local eff_list = {}
	local eff_list2 = {}

	local src_ambush = src:is_ambush()
	local target_defender = target:is_defender()

	if target_defender ~= true or (src_ambush == true and target_defender == true) then
		eff_list2 = self:action_attack_one(src, target, false)
		table_append(eff_list, eff_list2)

		if src_ambush then
			-- target cannot defend
			return eff_list
		end

		if target:can_defend() ~= true then
			return eff_list
		end

		eff_list2 = self:action_attack_one(target, src, true)
		table_append(eff_list, eff_list2)
	else
		-- defender defend first
		if target:can_defind() then
			eff_list2 = self:action_attack_one(target, src, true)
			table_append(eff_list, eff_list2)
		end

		if src:can_attack() ~= true then
			return eff_list
		end

		eff_list2 = self:action_attack_one(src, target, false)
		table_append(eff_list, eff_list2)
	end

	return eff_list
end --}

function World:action_ability(cmd_list) --{
end --}

function World:action_next() --{
end --}
