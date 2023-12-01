local ffi = require "ffi"
local glfw = ffi.os == 'Windows' and ffi.load( 'glfw3' ) or ffi.C

ffi.cdef( [[
typedef struct GLFWgamepadstate {
    unsigned char buttons[15];
    float axes[6];
} GLFWgamepadstate;

int glfwJoystickPresent(int jid);
const char* glfwGetJoystickName(int jid);
const float* glfwGetJoystickAxes(int jid, int* count);
const unsigned char* glfwGetJoystickButtons(int jid, int* count);
const unsigned char* glfwGetJoystickHats(int jid, int* count);
]] )

local m = {}

-- Internals
local function getDeviceAxes( jid )
	local count = ffi.new( "int[1]" )
	local axes = ffi.new( "int[6]" )
	axes = glfw.glfwGetJoystickAxes( jid - 1, count )
	return count[ 0 ], axes
end

local function getDeviceButtons( jid )
	local count = ffi.new( "int[1]" )
	local buttons = ffi.new( "char[32]" )

	buttons = glfw.glfwGetJoystickButtons( jid - 1, count )

	return count[ 0 ], buttons
end

local function getDeviceHats( jid )
	local count = ffi.new( "int[1]" )
	local hats = ffi.new( "char[32]" )
	hats = glfw.glfwGetJoystickHats( jid, count )

	return count[ 0 ], hats
end

-- API
function m.isDevicePresent( jid )
	if glfw.glfwJoystickPresent( jid - 1 ) == 1 then
		return true
	end
	return false
end

function m.getDeviceCount()
	local count = 0
	for i = 0, 15 do
		if glfw.glfwJoystickPresent( i ) == 1 then
			count = count + 1
		end
	end

	return count
end

function m.getDeviceName( jid )
	return ffi.string( glfw.glfwGetJoystickName( jid - 1 ) )
end

function m.getButtonCount( jid )
	local count, btn = getDeviceButtons( jid )
	return count
end

function m.getButtonState( jid, bid )
	local count, btn = getDeviceButtons( jid )
	return btn[ bid - 1 ]
end

function m.getAxesCount( jid )
	local count, axes = getDeviceAxes( jid )
	return count
end

function m.getAxisValue( jid, aid )
	local count, axes = getDeviceAxes( jid )
	return axes[ aid - 1 ]
end

function m.getHatCount( jid )
	local count, hats = getDeviceHats( jid )
	return count
end

function m.getHatState( jid, hid )
	local count, hats = getDeviceHats( jid )
	return hats[ hid - 1 ]
end

return m
