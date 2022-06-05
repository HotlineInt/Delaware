local Stack = { Items = {}, Size = 0 }
Stack.__index = Stack

function Stack.new()
	return setmetatable({}, Stack)
end

function Stack:Contains(Target: any)
	for _, Item in pairs(self.Items) do
		if Item == Target then
			return true
		end
	end

	return false
end

function Stack:Push(Item: any)
	self.Size += 1
	return table.insert(self.Items, Item)
end

function Stack:Pop()
	self.Size -= 1
	table.remove(self.Items, 1)
end

function Stack:Peek()
	return self.Items[1] or warn("Peek unavailable\n", debug.traceback())
end

function Stack:IsEmpty()
	return #self.Items >= 1
end

return Stack
