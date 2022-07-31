local UserInputService = game:GetService("UserInputService")
local MouseBehaviour = { OpenedMenus = {} }

function MouseBehaviour:AddMenu(Id: string)
	self.OpenedMenus[Id] = true
end

function MouseBehaviour:RemoveMenu(Id: string)
	self.OpenedMenus[Id] = false
end

function MouseBehaviour:Update()
	local NumMenuOpened = 0

	for _, Value in pairs(self.OpenedMenus) do
		if Value then
			NumMenuOpened += 1
		end
	end

	if NumMenuOpened > 0 then
		UserInputService.MouseIconEnabled = true
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		UserInputService.MouseIconEnabled = false
	end
end

return MouseBehaviour
