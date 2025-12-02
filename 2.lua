local is_palindrom = function(id)
    if #id % 2 ~= 0 then return false end
    return id:sub(1, #id / 2) == id:sub(#id / 2 + 1)
end

local is_repeating = function(id)
    for rep_len = math.floor(#id / 2), 1, -1 do
        local num_reps = #id / rep_len
        local rep
        for i = 0, num_reps - 1 do
            local current = id:sub(i * rep_len + 1, i * rep_len + rep_len)
            if not rep then
                rep = current
            elseif current ~= rep then
                break
            elseif i == num_reps - 1 then
                return true
            end
        end
    end

    return false
end

local input = assert(io.open("input.txt", "r"))
local content = input:read("*a")
input:close()
local sum = 0
local sum2 = 0

for r1, r2 in content:gmatch("(%d+)-(%d+)") do
    for id = r1, r2 do
        if is_palindrom(tostring(id)) then
            sum = sum + id
        end
        if is_repeating(tostring(id)) then
            sum2 = sum2 + id
        end
    end
end

print("Part one: " .. sum)
print("Part two: " .. sum2)