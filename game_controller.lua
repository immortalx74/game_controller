local ffi = require "ffi"
local glfw = ffi.os == 'Windows' and ffi.load( 'glfw3' ) or ffi.C

ffi.cdef( [[
typedef struct GLFWgamepadstate {
    unsigned char buttons[15];
    float axes[6];
} GLFWgamepadstate;

int glfwInit(void);
int glfwJoystickPresent(int jid);
const char* glfwGetJoystickName(int jid);
const float* glfwGetJoystickAxes(int jid, int* count);
const unsigned char* glfwGetJoystickButtons(int jid, int* count);
const unsigned char* glfwGetJoystickHats(int jid, int* count);
typedef void (*GLFWjoystickfun)(int jid, int event);
GLFWjoystickfun glfwSetJoystickCallback(GLFWjoystickfun callback);
const char* glfwGetJoystickGUID(int jid);
int glfwUpdateGamepadMappings(const char *string);
int glfwJoystickIsGamepad(int jid);
const char* glfwGetGamepadName(int jid);
int glfwGetGamepadState(int jid, GLFWgamepadstate* state);
]] )

GAMEPAD_BUTTON_A                       = 0
GAMEPAD_BUTTON_B                       = 1
GAMEPAD_BUTTON_X                       = 2
GAMEPAD_BUTTON_Y                       = 3
GAMEPAD_BUTTON_LEFT_BUMPER             = 4
GAMEPAD_BUTTON_RIGHT_BUMPER            = 5
GAMEPAD_BUTTON_BACK                    = 6
GAMEPAD_BUTTON_START                   = 7
GAMEPAD_BUTTON_GUIDE                   = 8
GAMEPAD_BUTTON_LEFT_THUMB              = 9
GAMEPAD_BUTTON_RIGHT_THUMB             = 10
GAMEPAD_BUTTON_DPAD_UP                 = 11
GAMEPAD_BUTTON_DPAD_RIGHT              = 12
GAMEPAD_BUTTON_DPAD_DOWN               = 13
GAMEPAD_BUTTON_DPAD_LEFT               = 14
GAMEPAD_BUTTON_LAST                    = GAMEPAD_BUTTON_DPAD_LEFT
GAMEPAD_BUTTON_CROSS                   = GAMEPAD_BUTTON_A
GAMEPAD_BUTTON_CIRCLE                  = GAMEPAD_BUTTON_B
GAMEPAD_BUTTON_SQUARE                  = GAMEPAD_BUTTON_X
GAMEPAD_BUTTON_TRIANGLE                = GAMEPAD_BUTTON_Y

GAMEPAD_AXIS_LEFT_X                    = 0
GAMEPAD_AXIS_LEFT_Y                    = 1
GAMEPAD_AXIS_RIGHT_X                   = 2
GAMEPAD_AXIS_RIGHT_Y                   = 3
GAMEPAD_AXIS_LEFT_TRIGGER              = 4
GAMEPAD_AXIS_RIGHT_TRIGGER             = 5

local m                                = {}

local device_connected_or_disconnected = { id = 0, ev = 0, changed = false }
local f                                = io.open( "gamecontrollerdb.txt", "r" )
local str                              = f:read( "*all" )

glfw.glfwInit()
glfw.glfwUpdateGamepadMappings( str )

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

function m.getGamepadName( jid )
	return ffi.string( glfw.glfwGetGamepadName( jid - 1 ) )
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

function m.isDeviceGamepad( jid )
	if glfw.glfwJoystickIsGamepad( jid - 1 ) == 1 then
		return true
	end

	return false
end

function m.getGamepadState( jid )
	local state = ffi.new( "GLFWgamepadstate" )
	glfw.glfwGetGamepadState( jid - 1, state )
	return state
end

return m
