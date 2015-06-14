do

 local function run(msg, matches)
    run_command("scrot 'scrsht.png' -q '10' -e 'convert $f -resize 900 $f && mv $f /tmp/' -z")
    local receiver = get_receiver(msg)
    local file = '/tmp/scrsht.png'
    local cb_extra = {file_path=file}
    print('send_photo')
    send_photo(receiver, file, rmtmp_cb, cb_extra)
 end

 return {
 description = "Take a screenshot and then send it to me",
 usage = "!shot",
 patterns = {
 "^!shot$"
 },
 run = run,
 privileged = true
 }
 
end