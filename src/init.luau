local RunService = game:GetService("RunService")

local PubTypes = require(script.PubTypes)
local Runtime = require(script.Sensor.Runtime)
local Sensor = require(script.Sensor)
local State = require(script.Sensor.State)

type SensorConfiguration = {
	name: string,
	usePlayers: boolean?,
	message: string | (sensor: PubTypes.Sensor, player: Player) -> any,
}

local Sensors = {}

function Sensors.createSensor(configuration: SensorConfiguration)
	local sensor = setmetatable({
		_fireConnections = {},
		_disconnectedPlayers = {},

		name = configuration.name,
		usePlayers = configuration.usePlayers and not RunService:IsClient(),
		message = configuration.message,
	}, Sensor)

	sensor.runtime = setmetatable({ sensor = sensor }, Runtime)
	sensor.state = setmetatable({ sensor = sensor }, State)

	sensor:onFire(function(_, player: Player)
		if not table.find(sensor._disconnectedPlayers, player) then
			table.insert(sensor._disconnectedPlayers, player)
		end
	end)

	return sensor
end

function Sensors.registerSensor(sensor: PubTypes.Sensor)
	if typeof(sensor.onStart) == "function" then
		sensor.runtime:onStart()
		sensor.onStart(sensor)
	end
end

function Sensors.registerSensorsIn(parent)
	for _, sensorModule: ModuleScript in parent:GetChildren() do
		if sensorModule:IsA("ModuleScript") then
			Sensors.registerSensor(require(sensorModule))
		end
	end
end

function Sensors.start() end

return Sensors
