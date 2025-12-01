local input = assert(io.open("input.txt", "r"))
local current = 50
local zero_count = 0
local zero_count2 = 0

for line in input:lines() do
    local rotation, amount = line:match("([LR])(%d+)")

    if rotation == "L" then
        for _ = 1, amount do
            current = current - 1
            if current < 0 then current = 99 end
            if current == 0 then zero_count2 = zero_count2 + 1 end
        end
    else
        for _ = 1, amount do
            current = current + 1
            if current > 99 then current = 0 end
            if current == 0 then zero_count2 = zero_count2 + 1 end
        end
    end

    if current == 0 then 
        zero_count = zero_count + 1
    end
end

print("Part one: " .. zero_count)
print("Part two: " .. zero_count2)

input:close()