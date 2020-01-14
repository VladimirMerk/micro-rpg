Gui = {}
Gui.__index = Gui

function Gui.create()
   local gui = {}
   setmetatable(gui,Gui)
   gui.screens = {}
   return gui
end

function Gui.createScreen(name)
	--table.insert(self.screens, name)
end

function Gui.getScreen(name)

end
