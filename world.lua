
require("util")
require("common")
require("cardfactory")
require("country")

--[[
game world
include 2 country


--]]

World = {}
World =
{
	round = 1,
	current = 1,
	card_factory = {},	
	country_list = {},

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
				printf("country[%d] init fail\n", side)
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
			printf("deck list error\n")
			return false
		end

		local card_factory = self.card_factory

		if not self:country_init() then
			printf("country_init fail\n")
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

			-- TODO shuffle card

			-- create and add hero card
			local cid = deck[1][1]
			local hero = card_factory:create_card(cid)
			if hero == nil then
				printf("country[%d] hero%d nil\n", side, cid)
				return false
			end
			country:add_card(hero, T_HERO)

			-- create and add normal card
			for __, cid in ipairs(deck[2]) do
				local card = card_factory:create_card(cid)
				if card == nil then
					printf("country[%d] card%d nil\n", side, cid)
					return false
				end
				country:add_card(card, T_DECK)
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
				printf("country[%d] card%d nil\n", side, cid)
				return false
			end
			country:add_card(card, field_index)
		end
		return true

	end, -- }

	logic_init_test = function(self)
	-- {
		local card_factory = self.card_factory

		if not self:country_init() then
			printf("country_init fail\n")
		end

		local side = 1
		self:card_init_field(side, T_HERO, {1})
		self:card_init_field(side, T_DECK, {22, 22, 22, 22, 22, 22, 22, 22, 22})
		self:card_init_field(side, T_HAND, {22, 22, 22, 22, 22})
		self:card_init_field(side, T_ALLY, {22, 22, 22, 22, 22})

		side = 2
		self:card_init_field(side, T_HERO, {1})
		self:card_init_field(side, T_DECK, {26, 26, 26, 26, 26, 26, 26, 26, 26})
		self:card_init_field(side, T_HAND, {26, 26, 26, 26, 26})
		self:card_init_field(side, T_ALLY, {26, 26, 26, 26, 26})

		return true
	end, -- }
	
	print = function (self)
		for k, v in ipairs(self.country_list) do
			v:print()
			printf("\n")
		end
		printf("round=%d current=%d\n", self.round, self.current)
	end,
}
World.__index = World
