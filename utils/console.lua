-- Hopefully an API to
-- make logging to the monitor easier
-- c = console.Console.create(peripheral.wrap("right"))
 
Console = {}
Console.__index = Console
 
function Console:size(size)
  if self.term.setTextScale then
    self.term.setTextScale(size)
  end
end
 
function Console:clear()
  self.term.clear()
end
 
function Console.create(thing)
  local cons = {}
  setmetatable(cons, Console)
  cons.term = thing
  cons.term.clear()
  cons.term.setCursorPos(1,1)
  cons:size(1)
  return cons
end
 
 
 
function Console:prln(str)
  local x, y = self.term.getCursorPos()
  local lx, ly = self.term.getSize()
  self.term.write(str)
  if y == ly then
    self.term.scroll(1)
        self.term.setCursorPos(1, y)
  else
        self.term.setCursorPos(1, y+1)
  end
end