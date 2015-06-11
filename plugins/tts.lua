-- first get from @tatons in telegram group
do

local function run(msg, matches)
local receiver = get_receiver(msg)
local text = matches[1]
local b = 1

while b ~= 0 do
   text,b = text:gsub('^+','+')
   text = text:trim()
  end
   text= string.gsub(text, "%s+", "+")
   url = "http://translate.google.com/translate_tts?tl=id&q=" .. text
   local file = download_to_file(url)
   local cb_extra = {file_path=file}
   send_audio(receiver, file, rmtmp_cb, cb_extra)
   -- return url
end

return {
 description = "Text to speech!",
 usage = "!tts [text]: echoes the msg",
 patterns = {
 "^!tts (.+)$"
 }, 
 run = run 
}

end
