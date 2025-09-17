local AbstractUnlocker = require("amstaffix.core.abstract_unlocker")

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
    return self.nn.Distance(objectRef1 --[[@as NilName.ObjectReference]], objectRef2 --[[@as NilName.ObjectReference]]), nil
end
