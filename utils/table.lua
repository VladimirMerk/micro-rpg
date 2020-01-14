
function table.count(t)
  local nvalues = 0
  for k,v in pairs(t) do nvalues = nvalues + 1 end
  return nvalues
end

function table.invert(t)
   local s={}
   for k,v in pairs(t) do
     s[v]=k
   end
   return s
end

function table.invert2(t)
  local reversedTable = {}
  local itemCount = #t
  for k, v in ipairs(t) do
    reversedTable[itemCount + 1 - k] = v
  end
  return reversedTable
end

function table.get_key( t, value )
  for k,v in pairs(t) do
    if v==value then return k end
  end
  return nil
end
