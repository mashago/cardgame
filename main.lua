
require("card1")
require("card22")
require("card26")
require("world")

-- store all card class
local g_origin_card_list = {}

function load_card()
	g_origin_card_list[1] = Card1
	g_origin_card_list[22] = Card22
	g_origin_card_list[26] = Card26
end

function card_test()
	local c1 = card1:new()
	c1:print()

	local c2 = card1:new()
	c2:print()

	c1.hp = 10
	c1:print()
	c2:print()

	c1:trigger_attack()
	c1:trigger_skill()
end

-- two country deck
function get_deck_list()

	local deck_list = {}
	deck_list[1] = {}
	deck_list[1][1] = {1}
	deck_list[1][2] = {22, 22, 22, 22, 22, 22, 22, 22, 22}

	deck_list[2] = {}
	deck_list[2][1] = {1}
	deck_list[2][2] = {26, 26, 26, 26, 26, 26, 26, 26, 26}

	return deck_list
end

function game_start(origin_card_list)

	local deck_list = get_deck_list()
	local world = World:new(origin_card_list)

	-- if not world:logic_init(deck_list) then
	if not world:logic_init_test() then
		return false;
	end
	world:print()

	return true
end

function main()
	load_card()
	game_start(g_origin_card_list)

end

main()
