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
typedef void (*GLFWjoystickfun)(int jid, int event);
GLFWjoystickfun glfwSetJoystickCallback(GLFWjoystickfun callback);
const char* glfwGetJoystickGUID(int jid);
]] )

local m = {}

local device_connected_or_disconnected = { id = 0, ev = 0, changed = false }

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

local function joystickCallback( jid, ev )
	device_connected_or_disconnected.id = jid
	device_connected_or_disconnected.ev = ev
	device_connected_or_disconnected.changed = true
end

glfw.glfwSetJoystickCallback( joystickCallback );

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

function m.configurationChanged()
	local result = false
	local type = "idle"

	if device_connected_or_disconnected.changed then
		result = true

		if device_connected_or_disconnected.ev == 0x00040001 then
			type = "connected"
		elseif device_connected_or_disconnected.ev == 0x00040002 then
			type = "disconnected"
		end
	end

	device_connected_or_disconnected.changed = false

	return result, type, device_connected_or_disconnected.id + 1
end

function m.getDeviceGUID( jid )
	return ffi.string( glfw.glfwGetJoystickGUID( jid - 1 ) )
end

return m
