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

--
-- Abstract methods, that should be implemented
--

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

---Flags:
---```lua
---M2Collision = 0x1
---M2Render = 0x2
---WMOCollision = 0x10
---WMORender = 0x20
---Terrain = 0x100
---WaterWalkableLiquid = 0x10000
---Liquid = 0x20000
---EntityCollision = 0x100000
---```
---@param x number
---@param y number
---@param flags number
---@nodiscard
---@return number x, number y, number z
function AbstractUnlocker:convertScreenToWorld(x, y, flags)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject
function AbstractUnlocker:getObjectCreatedBy(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getObjectHeight(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function AbstractUnlocker:getObjectAnimationFlags(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function AbstractUnlocker:getObjectDynamicFlags(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function AbstractUnlocker:getObjectMovementFlags(objectRef)
    error("not implemented")
end

---@param x number
---@param y number
---@param z number
---@nodiscard
---@return number x, number y, boolean? isOnScreen
function AbstractUnlocker:convertWorldToScreen(x, y, z)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getObjectID(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getObjectCreatureTypeId(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getObjectType(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean
function AbstractUnlocker:isObjectLootable(objectRef)
    error("not implemented")
end

---@param x number
---@param y number
---@param z number
function AbstractUnlocker:clickXYZ(x, y, z)
    error("not implemented")
end

---@param func function|string
---@param ... any
function AbstractUnlocker:callSecurely(func, ...)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return string, Error? err
function AbstractUnlocker:getObjectName(objectRef)
    error("not implemented")
end

---@nodiscard
---@return number x, number y, number z
function AbstractUnlocker:getCorpsePosition()
    error("not implemented")
end

---@nodiscard
---@param objectRef UnlockerObjectReference
---@return number type, Error? err
function AbstractUnlocker:getGameObjectType(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean exists
function AbstractUnlocker:isObjectExists(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getUnitFlags(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getUnitFlags2(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getUnitNpcFlags(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject?
function AbstractUnlocker:getUnitTarget(objectRef)
    error("not implemented")
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return number facing
function AbstractUnlocker:getAnglesObjects(objectRef1, objectRef2)
    local x1, y1, z1 = self:getObjectPosition(objectRef1)
    local x2, y2, z2 = self:getObjectPosition(objectRef2)

    return self:getAnglesXYZ(x1, y1, z1, x2, y2, z2)
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number facing
function AbstractUnlocker:getAnglesXYZ(x1, y1, z1, x2, y2, z2)
    error("not implemented")
end

---@param radians number
function AbstractUnlocker:setPitch(radians)
    error("not implemented")
end

---@param x number
---@param y number
---@param z number
function AbstractUnlocker:clickToMove(x, y, z)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function AbstractUnlocker:getUnitFlags3(objectRef)
    error("not implemented")
end

---@param radians number
---@param update boolean
function AbstractUnlocker:getFaceDirection(radians, update)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean, Error? err
function AbstractUnlocker:isObjectSkinnable(objectRef)
    error("not implemented")
end

---@param objectRef UnlockerObjectReference
function AbstractUnlocker:setMouseoverObject(objectRef)
    error("not implemented")
end

-- 
-- methods, which build upon basic unlocker methods 
--

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return boolean, Error?
function AbstractUnlocker:isUnitFacing(objectRef1, objectRef2)
    local ax, ay, az = self:getObjectPosition(objectRef1)
    local bx, by, bz = self:getObjectPosition(objectRef2)
    if not bx then
        return false, nil
    end
    local dx, dy, dz = ax - bx, ay - by, az - bz
    local rotation, err = self:getObjectFacing(objectRef1);
    if err ~= nil then
        return false, err
    end

    local value = (dy * math.sin(-rotation) - dx * math.cos(-rotation)) /
        math.sqrt(dx * dx + dy * dy)
    local isFacing = value > 0.25

    return isFacing
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return boolean
function AbstractUnlocker:isObjectInLineOfSight(objectRef1, objectRef2)
    if not UnitExists(objectRef1 --[[@as string]]) or not UnitExists(objectRef2 --[[@as string]]) then
        return false
    end

    local ax, ay, az = self:getObjectPosition(objectRef1)
    local bx, by, bz = self:getObjectPosition(objectRef2)
    local flags = bit.bor(0x10, 0x100, 0x1)
    local hit = self:traceLine(ax, ay, az + 2.25, bx, by, bz + 2.25, flags);

    return hit == false
end

return AbstractUnlocker
