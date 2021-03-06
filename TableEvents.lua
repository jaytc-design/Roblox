-- ScriptType: ModuleScript --

local TableEvents = {}
	function TableEvents.new(usedTable)
		local realTable = {}
		local Can = true
		local binds = {
			Added = Instance.new("BindableEvent"),
			Changed = Instance.new("BindableEvent"),
			Removed = Instance.new("BindableEvent"),
			Retrieved = Instance.new("BindableEvent")
		}
		if usedTable ~= nil and type(usedTable) == "table" then
			for i,v in pairs(usedTable) do
				realTable[i] = v
			end
		end
		local metaTable = {
		__index = function(t,i)
			binds.Retrieved:Fire(i,realTable[i])
			return realTable[i]
		end,
		__newindex = function(t,i,v)
			if Can then
			if t~= nil and i ~= nil then
				if realTable[i] ~= nil then
					if v == nil then
						local oldVal = realTable[i]
						realTable[i] = nil
						binds.Removed:Fire(i,oldVal)
					else
						local oldVal = realTable[i]
						realTable[i] = v
						binds.Changed:Fire(i,oldVal,v)
					end
				else
					realTable[i] = v
					binds.Added:Fire(i,v)
				end
			end
			end
		end
		}
		local fakeTable = {}
		function fakeTable:GetEvents()
			local newEvents = {}
			for i,v in pairs(binds) do
				newEvents[i] = v.Event
			end
			return newEvents
		end
		function fakeTable:GetRawTable()
			return realTable
		end
		function fakeTable:Rawset(i,v)
			realTable[i] = v
		end
		function fakeTable:Rawget(i)
			return realTable[i]
		end
		function fakeTable:SetReadOnly(v)
			if v~= nil and type(v) == 'boolean' then
				Can = not v
			end
		end
		function fakeTable:GetReadOnly()
			return Can
		end
		return setmetatable(fakeTable,metaTable)
	end
return TableEvents