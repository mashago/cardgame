
Country = {}
Country =
{
	side = -1,
	resource = 0,
	resource_max = 0,
	field_list = nil,
	world = nil,

	new = function (self)
		local object = {}
		setmetatable(object, self)
		return object
	end,

	init = function (self, world, side)
		self.world = world
		self.side = side
		self.field_list = {}
		self.field_list[F_HERO] = {}
		self.field_list[F_HAND] = {}
		self.field_list[F_ALLY] = {}
		self.field_list[F_SUPPORT] = {}
		self.field_list[F_GRAVE] = {}
		self.field_list[F_DECK] = {}
		-- self.field_list[F_ATTACH] = {}
	end,

	print = function (self)
		printf("side=%d resource=%d resoruce_max=%d\n"
				, self.side, self.resource, self.resource_max)
		for k, v in ipairs(self.field_list) do
			printf("%s :\n", g_field_name_map[k])
			for __, card in ipairs(v) do
				card:print()
			end
		end

	end,
}
Country.__index = Country

function Country:index_card(index) --{
	for _, f in ipairs(self.field_list) do
		for _, card in ipairs(f) do
			if card.index == index then
				return card
			end
		end
	end
	return nil
end --}

function Country:card_add(card, field_index)
	local t = self.field_list[field_index]
	t[#t+1] = card
	card.residence = self
	card.field = field_index
end

function Country:card_remove(card) --{
	if card.ctype == ATTACH and card.parent then
		-- TODO
		-- card_remove_attach
		return 
	end

	local f = self.field_list[card.field]
	for k, v in ipairs(f) do
		if v == card then
			table.remove(f, k)
			break
		end
	end
	card.field = 0

end --}
