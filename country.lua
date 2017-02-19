
Country = {}
Country =
{
	side = -1,
	resource = 0,
	resource_max = 0,
	field = {},

	new = function (self)
		local object = {}
		setmetatable(object, self)
		return object
	end,

	init = function (self, _side)
		self.side = _side
		self.field = {}
		self.field[T_HERO] = {}
		self.field[T_HAND] = {}
		self.field[T_ALLY] = {}
		self.field[T_SUPPORT] = {}
		self.field[T_GRAVE] = {}
		self.field[T_DECK] = {}
	end,

	add_card = function (self, card, field_index)
		local t = self.field[field_index]
		t[#t+1] = card
	end,

	print = function (self)
		printf("side=%d resource=%d resoruce_max=%d\n"
				, self.side, self.resource, self.resource_max)
		for k, v in ipairs(self.field) do
			printf("%s :\n", g_field_name_map[k])
			for __, card in ipairs(v) do
				card:print()
			end
		end

	end,
}
Country.__index = Country
