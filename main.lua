local gc = require "game_controller"
local num_devices = gc.getDeviceCount()
local ffi = require( "ffi" )

function lovr.load()
	print( "Number of devices: " .. num_devices )
	for i = 1, num_devices do
		local name = "-N/A-"
		if gc.isDeviceGamepad( i ) then
			name = gc.getGamepadName( i )
		end
		print( "Index: " .. i .. ", GUID: " .. gc.getDeviceGUID( i ) .. ", Name: " .. gc.getDeviceName( i ) .. ", Gamepad name: " .. name )
	end
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
