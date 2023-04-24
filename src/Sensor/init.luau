local Players = game:GetService("Players")
local PubTypes = require(script.Parent.PubTypes)

local Sensor = {}
Sensor.__index = Sensor

function Sensor:_getMessage(player: Player)
	if typeof(self.message) == "function" then
		return self:message(player)
	else
		return self.message
	end
end

function Sensor:_getPlayers()
	local players = {}

	for _, player in Players:GetPlayers() do
		if not table.find(self._disconnectedPlayers, player) then
			table.insert(players, player)
		end
	end

	return players
end

function Sensor:onFire(callback: (sensor: PubTypes.Sensor, player: Player?) -> ())
	table.insert(self._fireConnections, callback)
end

function Sensor:fire(player: Player?)
	for _, fireConnection: (sensor: PubTypes.Sensor, player: Player?) -> () in self._fireConnections do
		task.spawn(fireConnection, self, player)
	end

	if player and self.usePlayers then
		player:Kick(self:_getMessage(player))
	end
end

return Sensor
