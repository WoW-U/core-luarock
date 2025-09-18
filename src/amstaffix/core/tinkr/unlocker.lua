local AbstractUnlocker = require("amstaffix.core.abstract_unlocker")
local Error = require("amstaffix.core.error")

---@class TinkrUnlocker : AbstractUnlocker
local TinkrUnlocker = {
    ---@type Tinkr
    tinkr = nil,
}

---@param tinkr Tinkr
---@return TinkrUnlocker
function TinkrUnlocker:new(tinkr)
    self.__index = self
    setmetatable(self, { __index = AbstractUnlocker })

    local obj = AbstractUnlocker:new()

    setmetatable(obj, self)
    ---@cast obj TinkrUnlocker

    obj.tinkr = tinkr

    return obj
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number x, number y, number z
function TinkrUnlocker:getObjectPosition(objectRef)
    return self.tinkr.ObjectPosition(objectRef --[[@as Tinkr.ObjectReference]])
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
function TinkrUnlocker:traceLine(x1, y1, z1, x2, y2, z2, hitFlags)
    local x, y, z = self.tinkr.TraceLine(x1, y1, z1, x2, y2, z2, hitFlags);
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
function TinkrUnlocker:getObjectFacing(objectRef)
    local res = self.tinkr.ObjectRotation(objectRef --[[@as Tinkr.ObjectReference]])
    if type(res) == "boolean" then
        return 0, Error:notFound()
    end

    return res, nil
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@nodiscard
---@return number distance
function TinkrUnlocker:getDistance3DXYZ(x1, y1, z1, x2, y2, z2)
    return self.tinkr.FastDistance(x1, y1, z1, x2, y2, z2)
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@nodiscard
---@return number distance, Error? err
function TinkrUnlocker:getDistance3DObject(objectRef1, objectRef2)
    local res = self.tinkr.ObjectDistance(objectRef1 --[[@as Tinkr.ObjectReference]],
        objectRef2 --[[@as Tinkr.ObjectReference]])
    if type(res) == "boolean" then
        return 0, Error:new("invalid objectRef")
    end

    return res, nil
end

---@param x number
---@param y number
---@param flags number
---@nodiscard
---@return number x, number y, number z
function TinkrUnlocker:convertScreenToWorld(x, y, flags)
    return self.tinkr.ScreenToWorld(x, y, flags)
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return UnlockerObject
function TinkrUnlocker:getObjectCreatedBy(objectRef)
    return self.tinkr.ObjectCreator(objectRef --[[@as Tinkr.ObjectReference]]) --[[@as UnlockerObject]]
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number, Error? err
function TinkrUnlocker:getObjectHeight(objectRef)
    local res = self.tinkr.ObjectHeight(objectRef --[[@as Tinkr.ObjectReference]])
    if type(res) == "boolean" then
        return 0, Error:new("invalid objectRef")
    end

    return res, nil
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function TinkrUnlocker:getObjectAnimationFlags(objectRef)
    -- todo: should recheck
    local _, animationFlags = self.tinkr.ObjectFlags(objectRef --[[@as Tinkr.ObjectReference]])
    return animationFlags
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function TinkrUnlocker:getObjectDynamicFlags(objectRef)
    local _, _, _, _, _, _, dynamicFlags = self.tinkr.ObjectFlags(objectRef --[[@as Tinkr.ObjectReference]])

    return dynamicFlags
end

---@param objectRef UnlockerObjectReference
---@nodiscard
---@return number
function TinkrUnlocker:getObjectMovementFlags(objectRef)
    return self.tinkr.ObjectMovementFlag(objectRef --[[@as Tinkr.ObjectReference]])
end

---@param x number
---@param y number
---@param z number
---@nodiscard
---@return number x, number y, boolean? isOnScreen
function TinkrUnlocker:convertWorldToScreen(x, y, z)
    local sx, sy = self.tinkr.WorldToScreen(x, y, z)

    return sx, sy, nil
end
