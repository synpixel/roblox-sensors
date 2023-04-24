local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sensors = require(ReplicatedStorage.Sensors)

local TestSensor = Sensors.createSensor({
	name = "TestSensor",
	usePlayers = true,
	message = "Hello, world!",
})

function TestSensor:onStart()
	TestSensor:onFire(function()
		print("Bye, world!")
	end)

	TestSensor.runtime:loop(function()
		TestSensor.runtime:forPlayer(function(player: Player)
			TestSensor:fire(player)
		end)
	end)
end

function TestSensor:registerState(player: Player, state: { test: string }?)
	return {
		test = player.Name,
	}
end

return TestSensor
