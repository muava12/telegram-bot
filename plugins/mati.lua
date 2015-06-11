do

 local function run(msg, matches)
    local result = run_command(matches[1])
    return result
 end

 return {
 description = "Execute system Command",
 usage = "!shell [COMMAND]",
 patterns = {
 "^!shell (.*)$"
 },
 run = run,
 privileged = true
 }
 
end