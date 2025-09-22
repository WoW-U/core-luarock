local AbstractUnlocker = require("amstaffix.core.abstract_unlocker")
local Error = require("amstaffix.core.error")

---@class DaemonicUnlocker : AbstractUnlocker
local DaemonicUnlocker = {
    ---@type Daemonic
    dmc = nil,
}

---@param dmc Daemonic
---@nodiscard
---@return DaemonicUnlocker
function DaemonicUnlocker:new(dmc)
    self.__index = self
    setmetatable(self, { __index = AbstractUnlocker })

    local obj = AbstractUnlocker:new()

    setmetatable(obj, self)
    ---@cast obj DaemonicUnlocker

    obj.dmc = dmc

    return obj
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number x, number y, number z
function DaemonicUnlocker:getObjectPosition(objectRef)
    return self.dmc.GetUnitPosition(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param hitFlags number
---@nodiscard
---@return boolean isHit, number x, number y, number z
function DaemonicUnlocker:traceLine(x1, y1, z1, x2, y2, z2, hitFlags)
    local hit, x, y, z = self.dmc.TraceLine(x1, y1, z1, x2, y2, z2, hitFlags);
    if hit == 0 then
        return false, 0, 0, 0
    end

    return true, x, y, z
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number radians, Error? err
function DaemonicUnlocker:getObjectFacing(objectRef)
    return self.dmc.UnitFacing(objectRef --[[@as Daemonic.ObjectReference]]), nil
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number distance
function DaemonicUnlocker:getDistance3DXYZ(x1, y1, z1, x2, y2, z2)
    return self.dmc.GetDistance3D(x1, y1, z1, x2, y2, z2)
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return number distance, Error? err
function DaemonicUnlocker:getDistance3DObject(objectRef1, objectRef2)
    return
        self.dmc.GetDistance3D(objectRef1 --[[@as Daemonic.ObjectReference]],
            objectRef2 --[[@as Daemonic.ObjectReference]]),
        nil
end

---@param x number
---@param y number
---@param flags number
---@return number x, number y, number z
function DaemonicUnlocker:convertScreenToWorld(x, y, flags)
    return self.dmc.ScreenToWorld(x, y, flags)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject
function DaemonicUnlocker:getObjectCreatedBy(objectRef)
    return self.dmc.UnitCreatedBy(objectRef --[[@as Daemonic.ObjectReference]]) --[[@as UnlockerObject]]
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getObjectHeight(objectRef)
    return self.dmc.UnitHeight(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function DaemonicUnlocker:getObjectAnimationFlags(objectRef)
    return self.dmc.UnitAnimationFlags(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function DaemonicUnlocker:getObjectDynamicFlags(objectRef)
    return self.dmc.UnitDynamicFlags(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function DaemonicUnlocker:getObjectMovementFlags(objectRef)
    return self.dmc.GetUnitMovementFlags(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param x number
---@param y number
---@param z number
---@nodiscard
---@return number x, number y, boolean? isOnScreen
function DaemonicUnlocker:convertWorldToScreen(x, y, z)
    return self.dmc.WorldToScreen(x, y, z)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getObjectID(objectRef)
    local res = self.dmc.ObjectID(objectRef --[[@as Daemonic.ObjectReference]])
    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getObjectCreatureTypeId(objectRef)
    local res = self.dmc.UnitCreatureTypeId(objectRef --[[@as Daemonic.ObjectReference]])

    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getObjectType(objectRef)
    local res = self.dmc.ObjectType(objectRef --[[@as Daemonic.ObjectReference]])

    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean
function DaemonicUnlocker:isObjectLootable(objectRef)
    return self.dmc.UnitIsLootable(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param x number
---@param y number
---@param z number
function DaemonicUnlocker:clickXYZ(x, y, z)
    self.dmc.ClickPosition(x, y, z)
end

---@param func function|string
---@param ... any
function DaemonicUnlocker:callSecurely(func, ...)
    return self.dmc.SecureCode(func, ...)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return string, Error? err
function DaemonicUnlocker:getObjectName(objectRef)
    local res = self.dmc.ObjectName(objectRef --[[@as Daemonic.ObjectReference]])
    if not res then
        return "", Error:notFound()
    end

    return res, nil
end

---@nodiscard
---@return number x, number y, number z
function DaemonicUnlocker:getCorpsePosition()
    return self.dmc.GetCorpsePosition()
end

---@nodiscard
---@param objectRef UnlockerObjectReference
---@return number type, Error? err
function DaemonicUnlocker:getGameObjectType(objectRef)
    return self.dmc.GameObjectType(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean exists
function DaemonicUnlocker:isObjectExists(objectRef)
    return self.dmc.ObjectExists(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getUnitFlags(objectRef)
    return self.dmc.UnitFlags(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getUnitFlags2(objectRef)
    return self.dmc.UnitFlags2(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getUnitNpcFlags(objectRef)
    return self.dmc.UnitNpcFlags(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject?
function DaemonicUnlocker:getUnitTarget(objectRef)
    return self.dmc.UnitTarget(objectRef --[[@as Daemonic.ObjectReference]]) --[[@as UnlockerObject]]
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return number facing
function DaemonicUnlocker:getAnglesObjects(objectRef1, objectRef2)
    local facing, pitch = self.dmc.GetAngles(objectRef1 --[[@as Daemonic.ObjectReference]],
        objectRef2 --[[@as Daemonic.ObjectReference]])

    return facing
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number facing
function DaemonicUnlocker:getAnglesXYZ(x1, y1, z1, x2, y2, z2)
    local facing, pitch = self.dmc.GetAngles(x1, y1, z1, x2, y2, z2)

    return facing
end

---@param radians number
function DaemonicUnlocker:setPitch(radians)
    return self.dmc.SetPitch(radians)
end

---@param x number
---@param y number
---@param z number
function DaemonicUnlocker:clickToMove(x, y, z)
    self.dmc.MoveTo(x, y, z)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function DaemonicUnlocker:getUnitFlags3(objectRef)
    return self.dmc.UnitFlags3(objectRef --[[@as Daemonic.ObjectReference]])
end

---@param radians number
---@param update boolean
function DaemonicUnlocker:getFaceDirection(radians, update)
    self.dmc.FaceDirection(radians, update)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean, Error? err
function DaemonicUnlocker:isObjectSkinnable(objectRef)
    return self.dmc.UnitIsSkinnable(objectRef --[[@as Daemonic.ObjectReference]])
end
