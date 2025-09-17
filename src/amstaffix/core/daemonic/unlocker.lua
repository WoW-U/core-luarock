local AbstractUnlocker = require("amstaffix.core.abstract_unlocker")

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
    return self.dmc.GetDistance3D(objectRef1 --[[@as Daemonic.ObjectReference]], objectRef2 --[[@as Daemonic.ObjectReference]]), nil
end