local problems = {}
local problems2 = {}
local lines = {}
local op_indices = {}
local op_table = {
	["+"] = function(a, b) return a + b end,
	["*"] = function(a, b) return a * b end,
}

local input = assert(io.open("input.txt", "r"))

for line in input:lines() do
	local row = {}
	for token in line:gmatch("%S+") do
		table.insert(row, token)
	end
	table.insert(problems, row)

	if op_table[line:sub(1, 1)] then
		for i = 1, #line do
			if op_table[line:sub(i, i)] then
				table.insert(op_indices, i)
			end
		end
	else
		table.insert(lines, line)
	end
end

for _, line in ipairs(lines) do
	local row = {}
	for i = 2, #op_indices + 1 do
		if i <= #op_indices then
			table.insert(row, line:sub(op_indices[i - 1], op_indices[i] - 2))
		else
			table.insert(row, line:sub(op_indices[i - 1]))
		end
	end
	table.insert(problems2, row)
end

input:close()

local operators = table.remove(problems)

local sum = 0
for x = 1, #problems[1] do
	local acc
	for y = 1, #problems do
		acc = acc and op_table[operators[x]](acc, problems[y][x]) or problems[y][x]
	end
	sum = sum + acc
end

print("Part one: " .. sum)

local sum2 = 0

for x = 1, #problems2[1] do
	local acc
	for x2 = 1, #problems2[1][x] do
		local acc2 = ""
		for y = 1, #problems2 do
			local current = problems2[y][x]:sub(x2, x2)
			if current ~= " " then
				acc2 = acc2 .. current
			end
		end
		acc = acc and op_table[operators[x]](acc, tonumber(acc2)) or tonumber(acc2)
	end
	sum2 = sum2 + acc
end

print("Part two: " .. sum2)