---@class AbstractUnlocker
local AbstractUnlocker = {
}

---@alias UnlockerObject userdata|string|number
---@alias UnlockerObjectReference UnitToken|UnlockerObject

---@return AbstractUnlocker
function AbstractUnlocker:new()
    ---@type AbstractUnlocker
    ---@diagnostic disable-next-line: missing-fields
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number x, number y, number z
function AbstractUnlocker:getObjectPosition(objectRef)
    error("not implemented")
end

---Hit Flags:<br>
--- - `M2Collision = 0x1`<br>
--- - `M2Render = 0x2`<br>
--- - `WMOCollision = 0x10`<br>
--- - `WMORender = 0x20`<br>
--- - `Terrain = 0x100`<br>
--- - `WaterWalkableLiquid = 0x10000`<br>
--- - `Liquid = 0x20000`<br>
--- - `EntityCollision = 0x100000`<br>
--- - `Unknown = 0x200000`<br>
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param hitFlags number
---@nodiscard
---@return boolean isHit, number x, number y, number z
function AbstractUnlocker:traceLine(x1, y1, z1, x2, y2, z2, hitFlags)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number radians, Error? err
function AbstractUnlocker:getObjectFacing(objectRef)
    error("not implemented")
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number distance
function AbstractUnlocker:getDistance3DXYZ(x1, y1, z1, x2, y2, z2)
    error("not implemented")
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return number distance, Error? err
function AbstractUnlocker:getDistance3DObject(objectRef1, objectRef2)
    error("not implemented")
end

return AbstractUnlocker
