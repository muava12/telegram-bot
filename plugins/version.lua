do

function run(msg, matches)
  return 'JarvisBot '.. JarvisVersion ..[[ 
  Based on Telegram Bot ]].. VERSION ..[[ 
  maintened by @muafa]]
end

return {
  description = "Shows bot version", 
  usage = "!version: Shows bot version",
  patterns = {
    "^.version$",
    "^!version$"
  }, 
  run = run 
}

end
