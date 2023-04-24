local State = {}
State.__index = State

function State:_createPlayerState(player: Player)
	if not self._playerStates then
		self._playerStates = {}
	end
	if not self._playerStates[player] then
		self._playerStates[player] = {}
	end
end

function State:_setState(player: Player?, state: { [any]: any })
	if self.sensor.usePlayers then
		self:_createPlayerState(player)
		self._playerStates[player]._last = self._playerStates[player]._current
		self._playerStates[player]._current = state
	else
		self._last = self._current
		self._current = state
	end
end

function State:getState(player: Player?)
	if self.sensor.usePlayers then
		self:_createPlayerState(player)
		return self._playerStates[player]._current
	else
		return self._current
	end
end

function State:getLastState(player: Player?)
	if self.sensor.usePlayers then
		self:_createPlayerState(player)
		return self._playerStates[player]._last
	else
		return self._last
	end
end

return State
