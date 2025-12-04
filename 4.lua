local input = assert(io.open("input.txt", "r"))

local grid = {}

for line in input:lines() do
	local row = {}
	for c in line:gmatch(".") do
		table.insert(row, c)
	end
	table.insert(grid, row)
end

input:close()

local get_square = function(x, y)
	return grid[y] and grid[y][x]
end

local w, h = #grid[1], #grid
local deltas = {
	{ -1, 0 },
	{ -1, 1 },
	{ -1, -1 },
	{ 1, 0 },
	{ 1, 1 },
	{ 1, -1 },
	{ 0, 1 },
	{ 0, -1 },
}

local work_loop = function(cb)
	for x = 1, w do
		for y = 1, h do
			if get_square(x, y) == "@" then
				local count = 0
				for _, delta in ipairs(deltas) do
					local dx, dy = x + delta[1], y + delta[2]
					count = count + ((get_square(dx, dy) == "@") and 1 or 0)
				end
				cb(x, y, count)
			end
		end
	end
end

local total = 0

work_loop(function(x, y, count)
	total = total + ((count < 4) and 1 or 0)
end)

print("Part one: " .. total)

local total2 = 0
local prev_total

while total2 ~= prev_total do
	prev_total = total2

	work_loop(function(x, y, count)
		if count < 4 then
			total2 = total2 + 1
			grid[y][x] = "."
		end
	end)
end


print("Part two: " .. total2)