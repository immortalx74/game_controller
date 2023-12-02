# game_controller
 
### Game controller library for [LÖVR](https://lovr.org/) 

### General use notes:
First require the library: `local gc = require "game_controller"`

On `lovr.load` call `getDeviceCount` to get the number of connected devices at the time the application starts.

Ideally, you should also store each device's unique identifier at this point, by calling `getDeviceGUID`. This will be useful later because the index (jid) passed into various functions of the lib isn't guaranteed to be the same between different runs of your app, or if a device was connected/disconnected.

The idea is that you can check against your stored GUIDs to correctly identify a specific device.

Another option is to call `getDeviceName` but this also isn't guaranteed to be unique. There are cases where some generic gamepads are simply just called "USB Device".

You can check if a device was connected/disconnected at runtime by querying `configurationChanged`.

The rest are mostly polling functions which are self explanatory.

### API:
---
`isDevicePresent( jid )`

#### Checks if the device with the specified index is connected
#### Returns `boolean`, true if connected
---
`getDeviceCount()`

#### Get the number of connected devices
#### Returns `number`
---
`getDeviceName( jid )`

#### Get the name of the device with the specified index
#### Returns `string`
---
`getButtonCount( jid )`

#### Get the button count of the device with the specified index
#### Returns `number`
---
`getButtonState( jid, bid )`

#### Get the button state of the device with the specified index
#### returns `number`, 0 (not down) or 1 (down)
---
`getAxesCount( jid )`

#### Get the axes count of the device with the specified index
#### Returns `number`
---
`getAxisValue( jid, aid )`

#### Get the axis value of the device with the specified index
#### Returns `number`, a float with (-1, 1) range
---
`getHatCount( jid )`

#### Get the hat count of the device with the specified index
#### Returns `number`
---
`getHatState( jid, hid )`

#### Get the hat state of the device with the specified index
#### Returns `number`, values are as follows:
- Centered = 0
- Up = 1
- Right = 2
- Down = 4
- Left = 8

#### The other combinations can be retrieved by ORing 2 values. e.g. for Right+Up: `bit.bor( 2, 1 )`
---
`configurationChanged()`

#### Detects if a device was connected/disconnected
#### Returns `boolean`, `string`, `number`,
[1] true if a device was connected/disconnected

[2] string describing the event ("connected" or "disconnected")

[3] index of the device

NOTE: This should normally be called every frame and it will return true only for the particular frame where a change was detected.

---
`getDeviceGUID( jid )`

#### Gets the global unique identifier of a device
#### Returns `string`
---