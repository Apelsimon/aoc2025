local input = assert(io.open("input.txt", "r"))
local manifold = {}
local beams = {}
local start

for line in input:lines() do
	local s = line:find("S")
	if s then 
		beams[s] = true
		start = s
	end

	local row = {}
	for c in line:gmatch(".") do
		table.insert(row, c)
	end
	table.insert(manifold, row)
end

input:close()

local count = 0
for _, row in ipairs(manifold) do
	for pos, square in ipairs(row) do
		if beams[pos] and square == "^" then
			count = count + 1
			beams[pos - 1] = true
			beams[pos + 1] = true
			beams[pos] = nil
		end
	end
end

print("Part one: " .. count)

beams = {}
beams[start] = 1
for _, row in ipairs(manifold) do
	for pos, square in ipairs(row) do
		local acc = beams[pos]
		if acc and square == "^" then
			beams[pos - 1] = beams[pos - 1] and (beams[pos - 1] + acc) or acc
			beams[pos + 1] = beams[pos + 1] and (beams[pos + 1] + acc) or acc
			beams[pos] = nil
		end
	end
end

local count2 = 0
for _, acc in pairs(beams) do
	count2 = count2 + acc
end

print("Part two: " .. count2)