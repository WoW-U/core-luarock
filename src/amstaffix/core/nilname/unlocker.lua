local AbstractUnlocker = require("amstaffix.core.abstract_unlocker")
local Error = require("amstaffix.core.error")

---@class NilNameUnlocker : AbstractUnlocker
local NilNameUnlocker = {
    ---@type NilName
    nn = nil,
}

---@param nn NilName
---@return NilNameUnlocker
function NilNameUnlocker:new(nn)
    self.__index = self
    setmetatable(self, { __index = AbstractUnlocker })

    local obj = AbstractUnlocker:new()

    setmetatable(obj, self)
    ---@cast obj NilNameUnlocker

    obj.nn = nn

    return obj
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number x, number y, number z
function NilNameUnlocker:getObjectPosition(objectRef)
    ---@cast objectRef NilName.ObjectReference
    return self.nn.ObjectPosition(objectRef --[[@as NilName.ObjectReference]])
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
function NilNameUnlocker:traceLine(x1, y1, z1, x2, y2, z2, hitFlags)
    local x, y, z = self.nn.TraceLine(x1, y1, z1, x2, y2, z2, hitFlags);
    if type(x) == "boolean" then
        return false, 0, 0, 0
    end
    ---@cast x number
    ---@cast y number
    ---@cast z number

    return true, x, y, z
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number radians, Error? err
function NilNameUnlocker:getObjectFacing(objectRef)
    return self.nn.ObjectFacing(objectRef --[[@as NilName.ObjectReference]]), nil
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number distance
function NilNameUnlocker:getDistance3DXYZ(x1, y1, z1, x2, y2, z2)
    return self.nn.Distance(x1, y1, z1, x2, y2, z2)
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return number distance, Error? err
function NilNameUnlocker:getDistance3DObject(objectRef1, objectRef2)
    return self.nn.Distance(objectRef1 --[[@as NilName.ObjectReference]], objectRef2 --[[@as NilName.ObjectReference]]),
        nil
end

---@param x number
---@param y number
---@param flags number
---@nodiscard
---@return number x, number y, number z
function NilNameUnlocker:convertScreenToWorld(x, y, flags)
    return self.nn.ScreenToWorld(x, y, flags)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject
function NilNameUnlocker:getObjectCreatedBy(objectRef)
    return self.nn.ObjectCreator(objectRef --[[@as NilName.ObjectReference]]) --[[@as UnlockerObject]]
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getObjectHeight(objectRef)
    return self.nn.ObjectHeight(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function NilNameUnlocker:getObjectAnimationFlags(objectRef)
    return self.nn.ObjectAnimationFlags(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function NilNameUnlocker:getObjectDynamicFlags(objectRef)
    return self.nn.DynamicFlags(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function NilNameUnlocker:getObjectMovementFlags(objectRef)
    return self.nn.UnitMovementFlag(objectRef --[[@as NilName.ObjectReference]])
end

---@param x number
---@param y number
---@param z number
---@nodiscard
---@return number x, number y, boolean? isOnScreen
function NilNameUnlocker:convertWorldToScreen(x, y, z)
    return self.nn.WorldToScreen(x, y, z)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getObjectID(objectRef)
    local res = self.nn.ObjectID(objectRef --[[@as NilName.ObjectReference]])
    if type(res) == "boolean" or type(res) == "nil" then
        return 0, Error:notFound()
    end

    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getObjectCreatureTypeId(objectRef)
    return self.nn.UnitCreatureTypeId(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getObjectType(objectRef)
    local res = self.nn.ObjectType(objectRef --[[@as NilName.ObjectReference]])
    if type(res) == "boolean" or type(res) == "nil" then
        return 0, Error:notFound()
    end

    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean
function NilNameUnlocker:isObjectLootable(objectRef)
    return self.nn.ObjectLootable(objectRef --[[@as NilName.ObjectReference]])
end

---@param x number
---@param y number
---@param z number
function NilNameUnlocker:clickXYZ(x, y, z)
    self.nn.ClickPosition(x, y, z)
end

---@param func function|string
---@param ... any
function NilNameUnlocker:callSecurely(func, ...)
    return self.nn.Unlock(func, ...)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return string, Error? err
function NilNameUnlocker:getObjectName(objectRef)
    local res = self.nn.ObjectName(objectRef --[[@as NilName.ObjectReference]])
    if not res then
        return "", Error:notFound()
    end

    return res, nil
end

---@nodiscard
---@return number x, number y, number z
function NilNameUnlocker:getCorpsePosition()
    return self.nn.GetCorpsePosition()
end

---@nodiscard
---@param objectRef UnlockerObjectReference
---@return number type, Error? err
function NilNameUnlocker:getGameObjectType(objectRef)
    local res = self.nn.GameObjectType(objectRef --[[@as NilName.ObjectReference]])
    if res == nil then
        return 0, Error:notFound()
    end

    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean exists
function NilNameUnlocker:isObjectExists(objectRef)
    return self.nn.ObjectExists(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getUnitFlags(objectRef)
    return self.nn.UnitFlags1(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getUnitFlags2(objectRef)
    return self.nn.UnitFlags2(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getUnitNpcFlags(objectRef)
    return self.nn.NPCFlags(objectRef --[[@as NilName.ObjectReference]])
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject?
function NilNameUnlocker:getUnitTarget(objectRef)
    return self.nn.UnitTarget(objectRef --[[@as NilName.ObjectReference]]) --[[@as UnlockerObject]]
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number facing
function NilNameUnlocker:getAnglesXYZ(x1, y1, z1, x2, y2, z2)
    return self.nn.GetAnglesBetweenPositions(x1, y1, z1, x2, y2, z2)
end

---@param radians number
function NilNameUnlocker:setPitch(radians)
    return self.nn.SetPitch("player", radians)
end

---@param x number
---@param y number
---@param z number
function NilNameUnlocker:clickToMove(x, y, z)
    self.nn.ClickToMove(x, y, z)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function NilNameUnlocker:getUnitFlags3(objectRef)
    return self.nn.UnitFlags3(objectRef --[[@as NilName.ObjectReference]])
end

---@param radians number
---@param update boolean
function NilNameUnlocker:getFaceDirection(radians, update)
    self.nn.SetPlayerFacing(radians, update)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return boolean, Error? err
function NilNameUnlocker:isObjectSkinnable(objectRef)
    local res = self.nn.ObjectSkinnable(objectRef --[[@as NilName.ObjectReference]])
    if res == nil then
        return false, Error:new("wrong objectRef")
    end

    return res
end

---@param objectRef UnlockerObjectReference
function NilNameUnlocker:setMouseoverObject(objectRef)
    return self.nn.SetMouseover(objectRef --[[@as NilName.ObjectReference]])
end