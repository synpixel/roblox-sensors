local Runtime = require(script.Parent.Sensor.Runtime)
local State = require(script.Parent.Sensor.State)

export type Sensor = {
	name: string,
	usePlayers: boolean?,
	message: string | (sensor: Sensor, player: Player) -> any,
	onFire: ((sensor: Sensor, player: Player?) -> ()) -> (),
	onStart: (any) -> ()?,
	state: typeof(State),
	runtime: typeof(Runtime),
}

return nil
