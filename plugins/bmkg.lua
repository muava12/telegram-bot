
-- xml parser lib from: https://github.com/Cluain/Lua-Simple-XML-Parser
local xml = require("./libs/xmlSimple").newParser()
local file = ''
local getXml = ''
local prov = ''
local message = ''
local cuaca = ''
local tableProvince = {
  'aceh','sumut','sumbar','jambi','bengkulu','riau',
  'kepri','sumsel','bangka','lampung','banten','jakarta',
  'jabar','jateng','yogyakarta','jatim','bali','ntb',
  'ntt','kalbar','kalteng','kalsel','kaltim','gorontalo',
  'sulut','sulteng','sultenggara','sulsel','sulbar','maluku',
  'malukuutara','papuabarat','papua',
}

function read_xml_file(xUrl)
  file = download_to_file(xUrl)
  local cb_extra = {file_path=file}
  print('~Downloaded: '..file)

  -- from: http://www.codedisqus.com/CxVqqkqjeW/how-to-load-text-file-into-sort-of-tablelike-variable-in-lua.html
  local f = io.open(file)
  local x = ""
  while 1 do
    local l = f:read()
    if not l then break end
    x = x..l
  end

  return x
end

function parseJabodetabek(i)
  local parsedXml = xml:ParseXmlText(getXml)
  local result = '.:'..parsedXml.Cuaca.Isi.Row[i].Daerah:value()..':.'
  result = result..'\n-----------------------'
  result = result..'\n🌅Pagi: '..parsedXml.Cuaca.Isi.Row[i].Pagi:value()
  result = result..'\n🗻Siang: '..parsedXml.Cuaca.Isi.Row[i].Siang:value()
  result = result..'\n🌠Malam: '..parsedXml.Cuaca.Isi.Row[i].Malam:value()
  return result
end

-- from: http://stackoverflow.com/questions/1426954/split-string-in-lua
function splitText(inputstr, sep)
  if sep == nil then
          sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          t[i] = str
          i = i + 1
  end
  return t
end

function parseOtherCity(i)
  local parsedXml = xml:ParseXmlText(getXml)
  local result = '.:'..parsedXml.Cuaca.Isi.Row[i].Kota:value()..' ('..parsedXml.Cuaca.Isi.Row[i].Propinsi:value()..'):.'
  result = result..'\n-----------------------'
  result = result..'\nCuaca     : '..parsedXml.Cuaca.Isi.Row[i].Cuaca:value()
  result = result..'\nSuhu Min  : '..parsedXml.Cuaca.Isi.Row[i].SuhuMin:value()..' °C'
  result = result..'\nSuhu Max  : '..parsedXml.Cuaca.Isi.Row[i].SuhuMax:value()..' °C'
  result = result..'\nKec Angin : '..parsedXml.Cuaca.Isi.Row[i].KecepatanAngin:value()..' Knots'
  result = result..'\nArah Angin: '..parsedXml.Cuaca.Isi.Row[i].ArahAngin:value()
  return result
end

function parseGetCityCode(c)
  local parsedXml = xml:ParseXmlText(getXml)
  local result0 = ''
  local i = 1
  print(parsedXml.Cuaca.Isi.Row[i])
  while parsedXml.Cuaca.Isi.Row[i] ~= nil and result0 ~= c do
    result0 = string.lower(parsedXml.Cuaca.Isi.Row[i].Kota:value())
    result0 = result0:gsub("%s+", "") --  remove spaces

    i = i + 1
    print('*')
  end
  i = i - 1  -- TODO: perlu ada perbaikan disini supaya gak pake di kurang lagi
  if result0 == c then
    return i
  else
    return nil
  end
end

function parseOtherCityLOOP()
  local result = ''
  local parsedXml = xml:ParseXmlText(getXml)
  local i = 1
  while parsedXml.Cuaca.Isi.Row[i] ~= nil do
    result = result..'.: '..parsedXml.Cuaca.Isi.Row[i].Kota:value()..' ('..parsedXml.Cuaca.Isi.Row[i].Propinsi:value()..') :.'
    result = result..'\nCuaca: '..parsedXml.Cuaca.Isi.Row[i].Cuaca:value()
    result = result..'\nSuhu Min: '..parsedXml.Cuaca.Isi.Row[i].SuhuMin:value()..' °C'
    result = result..'\nSuhu Max: '..parsedXml.Cuaca.Isi.Row[i].SuhuMax:value()..' °C'
    result = result..'\n=========================\n'
    i = i + 1
  end
  return result
end

function urlProv(prov)
  url_prov = 'http://data.bmkg.go.id/propinsi_'
  url_prov = url_prov..prov
  url_prov = url_prov..'_2.xml'
  return url_prov
end

local function run(msg, matches)
  local receiver = get_receiver(msg)
  local url = 'http://data.bmkg.go.id/cuaca_jabodetabek_2.xml'
  print(matches[1])
  -- local ext = matches[2]

  if matches[1] == CMD..'bmkg' then
    url = urlProv('06') -- kode provinsi (riau = 06) lihat di: http://bmkg.go.id/BMKG_Pusat/Informasi_Cuaca/Prakiraan_Cuaca/Prakiraan_Cuaca_Indonesia.bmkg
    getXml = read_xml_file(url)
    cuaca = parseOtherCity(11)  -- 11 = Dumai
  elseif matches[1] == 'Tangerang' or matches[1] == 'tangerang' then
    getXml = read_xml_file(url)
    cuaca = parseJabodetabek(8)
  else  
    print("OK_1 ") -- debug
    message = splitText(matches[1]) 
    print('~message = '..table.concat(message,"", 2))   --  from: http://lua.gts-stolberg.de/en/table.php
    print('~message[1] = '..message[1]) -- debug
    if message[2] ~= nil then print('~message[2] = '..message[2]) end
    local i = 1
    while message[1] ~= tableProvince[i] and i <= 33 do
      print(tableProvince[i])
      i = i + 1
    end
    if  message[1] == tableProvince[i] then
      local kodeProv = ''
      if i < 10 then
        kodeProv = tostring(i)
        kodeProv = '0'..kodeProv
      else
        kodeProv = tostring(i)
      end
      url = urlProv(kodeProv) 
      getXml = read_xml_file(url)
      if message[2] ~= nil then
        local messageCity = table.concat(message,"", 2)
        if parseGetCityCode(messageCity) ~= nil then
          local nomor = parseGetCityCode(messageCity)
          print(nomor) -- debug
          cuaca = parseOtherCity(nomor)
        else
          cuaca = "Nama KOTA tidak terdaftar, mungkin salah ejaan atau salah ketik. Silahkan coba lagi."
        end
      else
        cuaca = parseOtherCityLOOP()
      end
    else
      cuaca = 'Nama PROVINSI tidak terdaftar, mungkin salah ejaan atau salah ketik. Silahkan coba lagi.'
    end
  end

  --print('send_file\n'..file)
  --send_file(receiver, file, rmtmp_cb, cb_extra)

  if file ~= nil then
      os.remove(file)
      print("~Removed: " .. file)
  end

  return cuaca
end

return {
  description = "Info cuaca untuk kota-kota di Indonesia dari BMKG", 
  usage = CMD.."bmkg : menampilkan cuaca kota Dumai\n"..
          CMD.."bmkg nama_provinsi : menampilkan cuaca provinsi\n"..
          CMD.."bmkg nama_provinsi nama_kota : menampilkan cuaca provinsi dan kota\n",
  patterns = {
    -- "(https?://[%w-_%.%?%.:/%+=&]+%.(xml))$"
    "^"..CMD.."bmkg$",
    --"^"..CMD.."bmkg (prov) (.*)$",
    "^"..CMD.."bmkg (.*)$"
  }, 
  run = run,
  previleged = true
}