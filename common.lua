
-- field index
T_HERO 			= 1
T_HAND 			= 2
T_ALLY 			= 3
T_SUPPORT 		= 4
T_GRAVE 		= 5
T_DECK 			= 6

g_field_name_map =
{
	'hero',  	-- [1]
	'hand',     -- [2]
	'ally',  	-- [3]
	'support',  -- [4]
	'grave',  	-- [5]
	'deck',  	-- [6] newly added
}

-- card type
ctype_map = {
    [10] = 'hero',  
    [20] = 'ally', 
    [30] = 'attach',
    [40] = 'ability',
    [50] = 'support',  -- 50 to 59 are all support items, include weapon etc
    [51] = 'weapon',
    [52] = 'armor',
    [53] = 'artifact',
    [54] = 'trap',
	[999] = 'XTYPE',
}

r_ctype_map = {}
for k, v in pairs(ctype_map) do
	r_ctype_map[v] = k
end

HERO = r_ctype_map['hero']
ALLY = r_ctype_map['ally']
ATTACH = r_ctype_map['attach']
ABILITY = r_ctype_map['ability']
SUPPORT = r_ctype_map['support']
WEAPON = r_ctype_map['weapon'] -- kind of support
ARMOR = r_ctype_map['armor'] -- kind of support
ARTIFACT = r_ctype_map['artifact'] -- kind of support
TRAP = r_ctype_map['trap'] -- kind of support

-- job map
job_map = {
	[1] = 'WARRIOR',  	-- warrior, boris etc
	[2] = 'HUNTER',	-- hunter, victor etc
	[4] = 'MAGE',	-- mage, nishaven etc
	[8] = 'PRIEST',	-- priest, zhanna etc
	[16] = 'ROGUE',	-- rogue
	[32] = 'WULVEN',	-- wulven
	[64] = 'ELEMENTAL',	-- elemental
	[256] = 'HUMAN',  -- human  (this is camp)
	[512] = 'SHADOW',		-- shadow
	[999] = 'j_j',
}

r_job_map = {}
for k, v in pairs(job_map) do
	r_job_map[v] = k
end

WARRIOR	= r_job_map['WARRIOR']	-- 1
HUNTER	= r_job_map['HUNTER']	-- 2
MAGE	= r_job_map['MAGE']	-- 4
PRIEST	= r_job_map['PRIEST']	-- 8 
ROGUE	= r_job_map['ROGUE']	-- 16
WULVEN 	= r_job_map['WULVEN']	-- 32
ELEMENTAL = r_job_map['ELEMENTAL']  -- 64
-- camp
HUMAN	= r_job_map['HUMAN'] 	-- 256
SHADOW	= r_job_map['SHADOW']	-- 512

