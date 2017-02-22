
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
			if false == country:init(side) then
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
			local hero = card_factory:create_card(cid)
			if hero == nil then
				printf('country[%d] hero%d nil\n', side, cid)
				return false
			end
			self.all_card_map[hero.index] = hero
			country:add_card(hero, F_HERO)

			-- create and add normal card
			for __, cid in ipairs(deck[2]) do
				local card = card_factory:create_card(cid)
				if card == nil then
					printf('country[%d] card%d nil\n', side, cid)
					return false
				end
				self.all_card_map[card.index] = card
				country:add_card(card, F_DECK)
			end
		end
		
		return true
	end, -- }


	card_init_field = function(self, side, field_index, card_list)
	-- {
		local card_factory = self.card_factory
		local country = self.country_list[side]
		for __, cid in ipairs(card_list) do
			local card = card_factory:create_card(cid)
			if card == nil then
				printf('country[%d] card%d nil\n', side, cid)
				return false
			end
			self.all_card_map[card.index] = card
			country:add_card(card, field_index)
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

	play_cmd = function(self, cmd_list) --{
		local eff_list, err
		if cmd_list[1] == 's' then
			eff_list, err = self:action_sacrifice(cmd_list[2] or 0)
		end
		return eff_list, err
	end, --}
	
	
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

	local country = self.country_list[card.side]
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

	if card.side ~= self.current then
		return nil, ERROR_MSG('sac oppo card')
	end

	if card.field ~= F_HAND then
		return nil, ERROR_MSG('sac non hand %d')
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
