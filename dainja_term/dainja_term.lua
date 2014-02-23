-- Listen from a modem, re-pipe messages to terminals
 
os.loadAPI("console")
os.loadAPI("glass")
 
local sides = {"front", "back", "left", "right", "top", "bottom"}
local vstring = "monitor"
local mstring = "modem"
local gstring = "openperipheral_glassesbridge"
local bport = 1337
 
local modem = nil
local glasses = nil
 
local termWrapper = {}
termWrapper.MSGS_out = function(ignore, msg) print(msg) end
local outs = {termWrapper}
local renders = {}
 
for k,side in pairs(sides) do
  local type = peripheral.getType(side)
  if type == mstring then
    modem = peripheral.wrap(side)
  elseif type == gstring then
    print("Found glasses on "..side)
    local g = glass.Glass.create(peripheral.wrap(side))
        g.MSGS_out = g.prln
    table.insert(outs, g)
        table.insert(renders, g)
  elseif type == vstring then
    print("Found monitor on "..side)
    local c = console.Console.create(peripheral.wrap(side))
        c:size(0.5)
        c.MSGS_out = c.prln
    table.insert(outs, c)
  end
end
 
if not modem then
  print("No modem")
  return
end
 
if not modem.isOpen(bport) then
  print("Listening on 1337")
  modem.open(bport)
end
 
local renderGlasses = function()
  while true do
    local empty = true
    for ignore, g in pairs(renders) do
      if not g:empty() then
            empty = false
                g:render()
          end
    end
        os.sleep(0.2)
        if empty then
           os.sleep(99999)
    end
  end
end
 
local msg = nil
 
local recMsg = function()
  local event, modemSide, senderChannel,
    replyChannel, message, senderDistance = os.pullEvent("modem_message")
  msg = message
end
 
while true do
  parallel.waitForAny(recMsg, renderGlasses)
  for ignore, out in pairs(outs) do
    out.MSGS_out(out, msg) -- LOLOLOL
  end
end
