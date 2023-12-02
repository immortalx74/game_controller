# game_controller
 
### Game controller library for [LÖVR](https://lovr.org/) 

### API
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