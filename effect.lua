
function eff_resource_value(value, s)
	return {'resource_value', value=value, side=s}
end

function eff_resource_offset(side, offset)
	return {'resource', side=side, offset=offset}
end

function eff_resource_max_offset(side, offset)
	return {'resource_max', side=side, offset=offset}
end

function eff_leave(index)
	return {'remove', index=index}
end

function eff_join(index, side, field)
	return {'join', index=index, side=side, field=field}
end

function eff_attack(src_index, target_index, power, dtype)
	return {'attack', src_index=src_index, target_index=target_index, power=power, dtype=dtype}
end

function eff_defend(src_index, target_index, power, dtype)
	return {'defend', src_index=src_index, target_index=target_index, power=power, dtype=dtype}
end

function eff_energy_offset(offset, s)
	return {'energy', offset=offset, side=s}
end

function eff_energy_value(value, s)
	return {'energy_value', value=value, side=s}
end

----- card move related

function eff_add(id, index) -- obsolete ?
	return {'add', id=id, index=index}
end

function eff_remove(index)  -- obsolete ?
	return {'remove', index=index}
end

function eff_move(index, field)
	return {'move', index=index, field=field}
end

function eff_view_top(index)
	return {'view_top', index=index}
end

function eff_hide_top(index)
	return {'hide_top', index=index}
end

function eff_view_oppo(index)
	return {'view_oppo', index=index}
end

function eff_hide_oppo(index)
	return {'hide_oppo', index=index}
end

-- index = target card to attach ( Puwen )
-- attach = attach card index(Extra Sharp), for virtual card set 0
function eff_attach(index, attach)
	return {'attach', index=index, target_index=target_index}
end

function eff_card(index, id) -- for display only
	return {'card', index=index, id=id}
end

function eff_trap(index, id) -- for display only
	return {'trap', index=index, id=id}
end

function eff_anim(index, id, atype, target_list) -- for display only
	local eff = {'anim', index=index, id=id, atype=atype, total=#target_list}
	for i=1,#target_list do
		eff['target' .. i] = target_list[i]
	end
	return eff
end

function eff_damage(src_index, target_index, dtype, atype, power)
	return {'damage', src_index=src_index, target_index=target_index, 
		dtype=dtype, atype=atype, power=power}
end

function eff_fight_start(src_index, target_index)
	return {'fight_start', src_index=src_index, target_index=target_index}
end

function eff_fight_end()
	return {'fight_end'}
end

function eff_hp(index, offset)
	return {'hp', index=index, offset=offset}
end

function eff_power_offset(index, offset)
	return {'power', index=index, offset=offset}
end

function eff_win(s)
	return {'win', side=s}
end

function eff_phase(phase)
	return {'phase', value=phase}
end

function effect_append(t, eff)
	if eff == nil or type(eff) ~= 'table' then
		return
	end
	t = t or {}
	t[#t+1] = eff
end
