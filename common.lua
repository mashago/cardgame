
PHASE_SACRIFICE = 1
PHASE_PLAY		= 2

-- JOB
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
assert(WARRIOR>0 and MAGE>0 and PRIEST>0 and ROGUE>0)
assert(WULVEN>0 and ELEMENTAL>0 and HUMAN>0 and SHADOW>0)

camp_map = {
	[256] = 'human',	
	[512] = 'shadow',
	[999] = 'c_c',
}

-- DAMAGE
damage_map = {
	[1] = 'normal', -- 1=normal sword
	[4] = 'penetration', --4=penetration attack,ignore armor,Uprooted Tree(197)
	[5] = 'magic', 
	[6] = 'fire',
	[7] = 'ice',
	[8] = 'electrical',
	[9] = 'arcane',
	[10] = 'poison',
	[50] = 'direct', --direct attack,ignore ally ability,King Pride(165) leave
	[999] = 'd_d',
}

r_damage_map = {}
for k, v in pairs(damage_map) do
	r_damage_map[v] = k
end

D_NORMAL = r_damage_map['normal']
D_PENETRATION = r_damage_map['penetration']
D_MAGIC = r_damage_map['magic']
D_FIRE = r_damage_map['fire']
D_ICE = r_damage_map['ice']
D_ELECTRICAL = r_damage_map['electrical']
D_ARCANE	= r_damage_map['arcane']
D_POISON = r_damage_map['poison']
D_DIRECT = r_damage_map['direct']

-- FIELD
F_HERO 			= 1
F_HAND 			= 2
F_ALLY 			= 3
F_SUPPORT 		= 4
F_GRAVE 		= 5
F_DECK 			= 6
F_RES			= 7
F_ATTACH		= 8

g_field_name_map =
{
	'hero',  	-- [1]
	'hand',     -- [2]
	'ally',  	-- [3]
	'support',  -- [4]
	'grave',  	-- [5]
	'deck',  	-- [6]
	'res',  	-- [7]
	'attach',	-- [8]
}

-- CARD TYPE
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



