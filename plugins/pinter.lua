do

function run(msg, matches)

  if matches[1] == "Sayang" then
    return "Manggil aku ya? :P"
  elseif matches[1] == "sayang" then
    return "apaa? 😘"
  elseif matches[1] == "pintar" then
    return "Iya dooong :P"
  elseif matches[1] == ("Mickey" or "mickey") then
    myTable = { "Apaa...'", "Haiii!", "Apa manggil-manggil?", "😘", "Yup..", "Daleemm"}
    text = myTable[ math.random( #myTable ) ]
    return text  
  elseif matches[1] == "pintar banget" then
    return "Makasih :)"
  elseif matches[1] == "[Hitung(.*)] (or [Berapa(.*)])" then
    return "Lagi ngitung ya :) -- 1"
  elseif matches[1] == "Hitung" then
    
  else
    
  end
end

local function preproc(msg)
   msg.text = "sebelum proses"
   return msg
end

return {
  description = "Jawab-jawab otomatis", 
  usage = "ucapkan apa saja",
  patterns = {
    "^[M|m]ickey$",
    "^[M|m]ickey (.*)",
    "^[M|m]iki$",
    "[M|m]iki (.*)",
    "[M|m]uafut (.*)",
    "^[S|s]ayang$", 
    "^[S|s]ay$",
    "^Berapa$"
  }, 
  run = run,
  privileged = true,
  --pre_process = preproc
}

end
