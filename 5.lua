local input = assert(io.open("input.txt", "r"))

local ranges = {}

for line in input:lines() do
	local low, high = line:match("(%d+)-(%d+)")
	if low and high then
		table.insert(ranges, {tonumber(low), tonumber(high)})
	else 
		break
	end
end

local fresh = 0
for line in input:lines() do
	local nr = tonumber(line)
	for _, range in ipairs(ranges) do
		if range[1] <= nr and nr <= range[2] then
			fresh = fresh + 1
			break
		end
	end
end

print("Part one: " .. fresh)

table.sort(ranges, function(r1, r2)
	if r1[1] == r2[1] then return r1[2] < r2[2] end
	return r1[1] < r2[1]
end)

local merged_ranges = {}

local maybe_set_merged_range_end = function(current, h1, h2, i)
	if h1 < h2 then
		current[2] = h2
	end
	while merged_ranges[i + 1] and merged_ranges[i + 1][1] <= h2 do
		current[2] = merged_ranges[i + 1][2]
		table.remove(merged_ranges, i + 1)
	end
end

local it = 1
for i, range in ipairs(ranges) do
	if i == 1 then
		table.insert(merged_ranges, range)
	else
		local low, high = range[1], range[2]
		while merged_ranges[it] do
			local current = merged_ranges[it]
			local clow, chigh = current[1], current[2]
			if low < clow then
				current[1] = low
				maybe_set_merged_range_end(current, chigh, high, it)
				break
			elseif (clow <= low) and (low <= chigh) then
				maybe_set_merged_range_end(current, chigh, high, it)
				break
			elseif it == #merged_ranges then
				table.insert(merged_ranges, range)
				break
			else
				it = it + 1
			end
		end
	end
end

local fresh2 = 0
for _, range in ipairs(merged_ranges) do
	fresh2 = fresh2 + range[2] - range[1] + 1
end

print(("Part two: %.0f"):format(fresh2))

input:close()