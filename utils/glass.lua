-- Simple program for adding messages to glasses
-- g = glass.Glass.create(peripheral.wrap("top"))
 
local yd = 12
local aniLen = 3
 
Glass = {}
Glass.__index = Glass
 
function Glass:empty()
  return self.msgs.next == nil
end
 
function Glass:getLast()
  local last = self.msgs
  local next = last.next
  while next ~= nil do
    last = next
        next = last.next
  end
  return last
end
 
function Glass:prln(msg, duration)
  duration = duration or 10
  local y = 1
  local newEle = {st=os.clock(), duration=duration}
  local last = self:getLast()
  if last.txt ~= nil then
    y = last.txt.getY() + yd
  end
  newEle.txt = self.bridge.addText(1, y, msg, 0xffffff)
  last.next = newEle
end
 
function Glass:render()
  local last = self.msgs
  local curr = last.next
  local now = os.clock()
  local y = 1
  while curr ~= nil do
    local diff = now - curr.st
        if diff >= curr.duration then
          last.next = curr.next
        else
          curr.txt.setY(y)
          y = y + yd
          curr.txt.setAlpha(math.min(aniLen, curr.duration - diff)/aniLen)
          last = curr
        end
        curr = curr.next
  end
  if self:empty() then
    self.bridge.clear()
  end
end
 
function Glass.create(thing)
  local g = {}
  setmetatable(g, Glass)
  g.msgs = {next=nil}
  g.bridge = thing
  g.bridge.clear()
  return g
end