local gc = require "game_controller"
local num_devices = gc.getDeviceCount()

function lovr.load()
	print( "Number of devices: " .. num_devices )
end

function lovr.update( dt )
	local result, type, device = gc.configurationChanged()
	if result then
		print( "Device: " .. device .. " was " .. type )
	end

	if gc.isDevicePresent( 1 ) then
		local btn_count = gc.getButtonCount( 1 )
		for i = 1, btn_count do
			if gc.getButtonState( 1, i ) == 1 then
				print( "Button " .. i .. " is down" )
			end
		end
	end
end
