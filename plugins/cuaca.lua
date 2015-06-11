do

local BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

local function get_weather(location)
  print("Finding weather in ", location)
  local url = BASE_URL
  url = url..'?q='..location
  url = url..'&units=metric'

  local b, c, h = http.request(url)
  if c ~= 200 then return nil end

  local weather = json:decode(b)
  local city = weather.name
  local country = weather.sys.country
  local temp = 'Suhu di '..city
    ..' (' ..country..')'
    ..' adalah '..weather.main.temp..'°C'
  local KataAwal = 'Kondisi saat ini: '
  local conditions = weather.weather[1].description
  
  if weather.weather[1].main == 'Clear' then
    conditions = KataAwal .. 'Cerah' .. ' ☀'
  elseif weather.weather[1].main == 'Clouds' then
    conditions = KataAwal .. 'Berawan' .. ' ☁☁'
  elseif weather.weather[1].main == 'Rain' then
    conditions = KataAwal .. conditions .. ' ☔'
  elseif weather.weather[1].main == 'Thunderstorm' then
    conditions = KataAwal .. conditions .. ' ☔☔☔☔'
  end

  return temp .. '\n' .. conditions
end

local function run(msg, matches)
  local city = 'Tangerang,ID'

  if matches[1] ~= CMD..'cuaca' then  -- !cuaca
    city = matches[1]
  end
  local text = get_weather(city)
  if not text then
    -- text = 'Can\'t get weather from that city.'
    text = 'Tidak dapat menemukan data cuaca di KOTA tersebut.'
  end
  return text
end

return {
  description = "Cuaca di kota tersebut (Default-nya adalah Jakarta)", 
  usage = CMD.."cuaca (city)",
  patterns = {
    "^"..CMD.."cuaca$",
    "^"..CMD.."cuaca (.*)$"
  }, 
  run = run 
}

end
