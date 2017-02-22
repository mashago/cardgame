

function ERROR_MSG(format, ...)
	return 'ERROR ' .. string.format(format, ...)
end

function LOG(format, ...)
	return print(string.format(format, ...))
end

function LOG_DEBUG(format, ...)
	return print('DEBUG ' .. string.format(format, ...))
end

function LOG_WARN(format, ...)
	return print('WARN ' .. string.format(format, ...))
end

function LOG_ERROR(format, ...)
	return print('ERROR ' .. string.format(format, ...))
end

function printf(format, ...)
	return io.stdout:write(string.format(format, ...))
end

function split_num(str)
	local ret = {}
	if str == nil or str == '' then
		return {}
	end
	str = string.gsub(str, '(%a+)(%d+)', '%1 %2')
	str = string.gsub(str, '(%d+)(%a+)', '%1 %2')
	for w in string.gmatch(str, "[%w,.-;]+") do
		local x = tonumber(w)
		if x ~= nil then
			w = x
		end
		table.insert(ret, w)
	end
	return ret
end

function table_append(t1, t2)
	if t2 == nil or #t2 == 0 then
		return t1
	end

	if t1 == nil then
		LOG_WARN('table_append t1=nil')
		t1 = {}
	end

	for i = 1, #t2 do
		t1[#t1+1] = t2[i]
	end
	return t1
end

function print_eff(eff, tabstop)
	tabstop = tabstop or 1
	local str = 'EFF '
	for i=1, tabstop do
		str = '    ' .. str
	end
	
	if eff[1]=='win' then
		LOG_DEBUG('WIN side=', eff.side)
	end
	for k, v in pairs(eff) do 
		if type(k) == 'number' then
			-- do nothing
		else
			str = str .. k .. '=' 
		end

		if type(v) == 'table' then
			str = str .. table_str(v) .. ', '
		else
			if v==nil then v = '_nil_' end
			str = str .. v .. ', '
		end
	end
	str = str .. '|'

	LOG(str)
end

function print_eff_list(eff_list)
	if eff_list == nil then
		LOG_WARN('print_eff_list nil')
		return
	end
	LOG('eff_list: %d', #eff_list)
	for k,v in ipairs(eff_list) do
		print_eff(v, 1)
	end
end

