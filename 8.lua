-- Helpers
local remove_unmutable = function(array, index)
    local new_arr = {}
    for i = 1, #array do
        if i ~= index then
            table.insert(new_arr, array[i])
        end
    end

    return new_arr
end

local function combinations(array, k)
    if k == 0 then
        return {{}}
    end

    if #array < k then
        return {}
    end

    local result = {}

    local first = array[1]
    local remaining = remove_unmutable(array, 1)
    local with_first = combinations(remaining, k - 1)

    for _, subset in ipairs(with_first) do
        table.insert(subset, 1, first)
        table.insert(result, subset)
    end

    local without_first = combinations(remaining, k)

    for _, subset in ipairs(without_first) do
        table.insert(result, subset)
    end

    return result
end

local distance = function(c1, c2)
	local x = c2.x - c1.x
	local y = c2.y - c1.y
	local z = c2.z - c1.z
	return math.sqrt(
		(x * x) +
		(y * y) +
		(z * z)
	)
end

local find_circuit = function (index, circuits)
	for i, circuit in ipairs(circuits) do
		if circuit[index] then
			return i
		end
	end
end

local connect = function(circuits, points)
    local it = find_circuit(points[1], circuits)
	local it2 = find_circuit(points[2], circuits)

	if it and (not it2) then
		circuits[it][points[2]] = true
	end
	if (not it) and it2 then
		circuits[it2][points[1]] = true
	end
	if (not it) and (not it2) then
		table.insert(circuits, { [points[1]] = true, [points[2]] = true })
	end
    if it and it2 and it ~= it2 then
        local min = math.min(it, it2)
        local max = math.max(it, it2)
        for k in pairs(circuits[max]) do
            circuits[min][k] = true
        end
        table.remove(circuits, max)
    end
end

local count = function(c)
	local total = 0
	for _ in pairs(c) do
		total = total + 1
	end
	return total
end

-- Start

local input = assert(io.open("input.txt", "r"))
local boxes = {}
local indices = {}
for line in input:lines() do
	local x, y, z = line:match("(%d+),(%d+),(%d+)")
	table.insert(boxes, { x = tonumber(x), y = tonumber(y), z = tonumber(z) })
	table.insert(indices, #boxes)
end
input:close()

local index_pairs = combinations(indices, 2)

table.sort(index_pairs, function(a, b)
	local p11 = boxes[a[1]]
	local p12 = boxes[a[2]]
	local p21 = boxes[b[1]]
	local p22 = boxes[b[2]]
	return distance(p11, p12) < distance(p21, p22)
end)

local circuits = {}
local limit = 1000

for i, points in ipairs(index_pairs) do
    if i >= (limit + 1) then break end
    connect(circuits, points)
end

table.sort(circuits, function(a, b)
	return count(a) > count(b)
end)

local prod = 1
for i = 1, 3 do
    prod = prod * count(circuits[i])
end

print("Part one: " .. prod)

circuits = {}
for _, points in ipairs(index_pairs) do
	connect(circuits, points)

    if #circuits == 1 and count(circuits[1]) == #boxes then
        print("Part two: " .. (boxes[points[1]].x * boxes[points[2]].x))
        break
    end
end
