local RunService = game:GetService("RunService")

local Runtime = {}
Runtime.__index = Runtime

function Runtime:loop(callback: () -> ())
	table.insert(self._loops, callback)
end

function Runtime:forPlayer(callback: (player: Player) -> ())
	for _, player: Player in self.sensor:_getPlayers() do
		task.spawn(callback, player)
	end
end

function Runtime:onStart()
	self._loops = {}
	self._event = self.sensor.event or RunService.Heartbeat

	if typeof(self.sensor.registerState) == "function" then
		self:loop(function()
			if self.sensor.usePlayers then
				self:forPlayer(function(player: Player)
					self.sensor.state:_setState(
						player,
						self.sensor:registerState(player, self.sensor.state:getState(player))
					)
				end)
			else
				self.sensor.state:_setState(nil, self.sensor:registerState(self.sensor.state:getState()))
			end
		end)
	end

	self._event:Connect(function()
		for _, callback: () -> () in self._loops do
			task.spawn(callback)
		end
	end)
end

return Runtime
