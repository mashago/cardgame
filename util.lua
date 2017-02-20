
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
