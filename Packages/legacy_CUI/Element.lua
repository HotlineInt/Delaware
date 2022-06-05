local Spring = require(script.Parent.Spring)
local TweenService = game:GetService("TweenService")

local Element = { Type = "Unknown", Properties = {}, Connections = {}, Tweens = {}, Children = {}, Is_Element = true }
Element.__index = Element

local BadProperties = require(script.Parent.BadProperties)
local Keys = require(script.Parent.Keys)

function Element.new(Type: string, Properties: table)
	local self = setmetatable({ Type = Type, Properties = Properties }, Element)
	self.Instance = Instance.new(Type)

	if self.Properties then
		self:_applyproperties(self, self.Properties)
	end

	return self
end

function Element:IsA(ClassName: string)
	return self.Instance.ClassName == ClassName
end

function Element:CallRobloxInternal(Method: string, ...)
	return self.Instance[Method](...)
end

function Element:SetProperty(Name: string, Value: any)
	self.Instance[Name] = Value
end

function Element:GetProperty(Name: string, Value: any)
	return self.Instance[Name]
end

function Element:_applyproperties(Element, Properties)
	local self = Element
	local OnEventSub = 7
	local OnChangeSub = 8

	for i, v in pairs(Properties) do
		if i == Keys.Children then -- fusion/roact like children structure
			-- add every component here
			for Type, Component in pairs(v) do
				if Component["Is_Element"] then
					self:Add(Component)
				elseif not Component["ClassName"] then
					self:Add(Type, Component)
					-- this lets us properly handle pre-made components in children table
				else
					self:Add(Component["ClassName"], Component)
				end
			end
			-- Event
		elseif type(i) == "string" and i:sub(1, OnEventSub) == "OnEvent" then
			local EventName = string.gsub(i, "OnEvent", "")
			self:On(EventName, v)
			-- Cryptic spaghetti
		elseif type(i) == "string" and i:sub(1, OnChangeSub) == "OnChange" then
			local Property = string.gsub(i, "OnChange", "")
			self.Instance:GetPropertyChangedSignal(Property):Connect(function()
				v(Element)
			end)
		else -- normal properties
			-- We don't want to assign bad properties and clutter up the output:
			if table.find(BadProperties, i) then
				continue
			end
			local Success, Fail = pcall(function()
				self.Instance[i] = v
			end)

			if not Success then
				--warn("[CUI] Applying property to", self, "failed:", Fail, "This is not fatal.")
			end
		end
	end
end

function Element:Add(Type, Properties: table, RobloxNative: table)
	local new_element

	-- Sometimes we're all lazy, right?
	if not Properties then
		Properties = {}
	end

	-- more and more edge cases... my head is getting dizzy..
	if type(Type) == "function" then
		new_element = Type(Properties)

		-- fallback
		if RobloxNative == nil then
			RobloxNative = Properties
		end

		-- RobloxNative is used to set Roblox-Native properties rather than pass thru Props to components.
		-- ! This used to crash the entirety of CUI by passing thru new_element.Instance instead of just the table.
		-- ! end me.
		self:_applyproperties(new_element, RobloxNative)
	elseif type(Type) == "string" then
		new_element = Element.new(Type, Properties)
	elseif type(Type) == "table" then
		-- Certain edge-case where we want to add a already created component.
		if Type["Render"] then
			new_element = Type:Render()
		else
			new_element = Type
		end
		self:_applyproperties(new_element, Properties)
	end

	if new_element == nil then
		error("CUI has experienced an internal exception: Given element has failed to create.")
	end

	table.insert(self.Children, new_element)
	new_element:Mount(self.Instance)

	return new_element
end

function Element:AddElement(...)
	return self:Add(...)
end

function Element:Get(Name: string | Instance)
	for _, Child in pairs(self.Children) do
		if Child.Instance.Name == Name or Child.Instance == Name then
			return Child
		end
	end

	-- ! This error is useless. Would probably re-add later. I dont know. - Shiroko
	--error("Unknown Child: " .. Name .. "\n" .. debug.traceback())
end

function Element:GetDescendants()
	local Descendants = {}

	local function GetChildren(Child)
		table.insert(Descendants, Child)
		if Child.Children == {} then
			return
		end
		for _, Child in pairs(Child.Children) do
			table.insert(Descendants, Child)
			GetChildren(Child)
		end
	end

	for _, Child in pairs(self.Children) do
		GetChildren(Child)
	end

	return Descendants
end

function Element:On(EventName, Callback)
	local Event = self.Instance[EventName]
	local us = self
	print(EventName, Event)

	if typeof(Event) == "RBXScriptSignal" then
		local connection = Event:Connect(function(...)
			Callback(us, ...)
		end)
		table.insert(self.Connections, {
			connection = connection,
			name = EventName,
			callback = Callback,
		})

		return connection
	end
end

function Element:Clone()
	local new_element = table.copy(self)
	new_element.Instance = new_element.Instance:Clone()
	return new_element
end

function Element:FireEvent(Name, ...)
	for _, Connection in pairs(self.Connections) do
		if Connection.name == Name and Connection.connection.Connected then
			Connection.callback(...)
		end
	end
end

function Element:Mount(Parent: Instance)
	if type(Parent) == "table" and Parent["Instance"] then
		self.Instance.Parent = Parent.Instance
	else -- instance
		self.Instance.Parent = Parent
	end
end

-- Cleansup and locks the element to prevent errors.
function Element:Destroy()
	for _, connection in pairs(self.Connections) do
		connection.connection:Disconnect()
	end

	for _, Tween in pairs(self.Tweens) do
		Tween:Destroy()
	end

	self.Properties = nil
	self.Type = nil
	for i, Children in pairs(self.Children) do
		Children:Destroy()
		self.Children[i] = nil
	end

	self.Instance:Destroy()
	self.Instance = nil
	self.Children = nil
	self = nil
end

function Element:AnimateTween(Info: Tween, Properties: table)
	local Tween = TweenService:Create(self.Instance, Info, Properties)
	Tween:Play()
	table.insert(self.Tweens, Tween)

	return Tween
end

function Element:AnimateSpring(DRatio, Frequency, Properties)
	-- animate with spring.target
	if not Properties then
		Properties = {}
	end
	Spring.target(self.Instance, DRatio, Frequency, Properties)
end

function Element:CancelSpring()
	Spring.stop(self.Instance)
end

return Element
