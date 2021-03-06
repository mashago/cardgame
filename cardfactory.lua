require("util")

CardFactory = {}
CardFactory =
{
	index = 0,
	cards = {},
	new = function (self, origin_card_list)
		local object = {}
		setmetatable(object, self)
		object:init(origin_card_list)
		return object
	end,
	
	init = function (self, origin_card_list)
		self.index = 0
		self.cards = origin_card_list
	end,

	create_card = function (self, card_id, world, country)
		local card_class = self.cards[card_id]
		if card_class == nil then
			printf("create_card: card[%d] not exists\n", card_id)
			return nil
		end
		self.index = self.index	+ 1
		local card = card_class:new()
		card:init(self.index, world, country)
		return card
	end,

}
CardFactory.__index = CardFactory
