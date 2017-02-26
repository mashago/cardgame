

function init_lua_path()
	local all_path = {}
	table.insert(all_path, package.path)
	table.insert(all_path, "./card/?.lua")
	package.path = table.concat(all_path, ';')
	print(package.path)
end
init_lua_path()

require("util")
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

function game_start(origin_card_list, deck_list)

	local world = World:new(origin_card_list)

	-- if not world:logic_init(deck_list) then
	if not world:logic_init_test() then
		return nil
	end

	return world
end

test_map =
{
	[1] = function()
		local ret = split_num('aa dd22 33 44ff ee5 6ii 88')
		for __, v in ipairs(ret) do
			print(v)
		end
		return 0
	end,
}

function main()

	load_card()
	local deck_list = get_deck_list()
	local world = game_start(g_origin_card_list, deck_list)
	if not world then
		printf("game_start fail\n")		
		return
	end

	world:print()

	local running = true
	while running do
		local input = io.read()
		local input_list = split_num(input)
		
		repeat -- {
		if #input_list == 0 or input_list[1] == 'help' then

			break
		end

		if input_list[1] == 'test' then
			local index = input_list[2]
			if index ~= nil and test_map[index] ~= nil then
				test_map[index](input_list)
			else
				printf("invalid test case\n")
			end
			break
		end

		if input_list[1] == 'p' or input_list[1] == 'print' then
			world:print()
			break
		end

		if input_list[1] == 'x' -- sacrifice
		or input_list[1] == 's' -- summon
		or input_list[1] == 't' -- attack
		or input_list[1] == 'b' -- ability
		or input_list[1] == 'n' -- next
		then
			local flag, err = world:play_cmd(input_list)
			if flag == false then
				LOG(err)
				break
			end
			print_eff_list(world.eff_list)
			break
		end
		
		printf('??? Unknown command\n')
		until true -- }
	end

end

main()
