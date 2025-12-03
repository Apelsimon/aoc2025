local get_num = function(line, i)
	return line:sub(i, i)
end

local concat_values = function(line, indices)
	local res = ""
	for _, i in ipairs(indices) do
		res = res .. line:sub(i, i)
	end
	return res
end

local input = assert(io.open("input.txt", "r"))
local sum = 0
local sum2 = 0

for line in input:lines() do
	-- Part one
	local high, low = get_num(line, 1), get_num(line, 2)
	for i = 2, #line do
		local current = get_num(line, i)
		if current > high and i < #line then
			high = current
			low = line:sub(i + 1, i + 1)
		elseif current > low then
			low = current
		end
	end
	sum = sum + tonumber(high .. low)

	-- Part two
	local index_arr = {}
	for i = #line - 11, #line do
		table.insert(index_arr, i)
	end

	for i, index in ipairs(index_arr) do
		local actual_index = index
		local limit = index_arr[i - 1] and (index_arr[i - 1] + 1) or 1
		for j = index - 1, limit, -1 do
			if get_num(line, j) >= get_num(line, actual_index) then
				index_arr[i] = j
				actual_index = j
			end
		end
	end

	sum2 = sum2 + tonumber(concat_values(line, index_arr))
end

print("Part one: " .. sum)
print(("Part two: %.0f"):format(sum2))

input:close()