local Error = require("amstaffix.core.error")

---@class WoWAPI
local WoWAPI = {
    ---@type AbstractUnlocker
    unlocker = nil,
}

---@param unlocker AbstractUnlocker
---@return WoWAPI
function WoWAPI:new(unlocker)
    ---@type WoWAPI
    local o = {
        unlocker = unlocker,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param objectRef1 UnlockerObjectReference
---@param objectRef2 UnlockerObjectReference
---@return boolean, Error?
function WoWAPI:isUnitFacing(objectRef1, objectRef2)
    local ax, ay, az = self.unlocker:getObjectPosition(objectRef1)
    local bx, by, bz = self.unlocker:getObjectPosition(objectRef2)
    if not bx then
        return false, nil
    end
    local dx, dy, dz = ax - bx, ay - by, az - bz
    local rotation, err = self.unlocker:getObjectFacing(objectRef1);
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
---@return boolean
function WoWAPI:isObjectInLineOfSight(objectRef1, objectRef2)
    if not UnitExists(objectRef1 --[[@as string]]) or not UnitExists(objectRef2 --[[@as string]]) then
        return false
    end

    local ax, ay, az = self.unlocker:getObjectPosition(objectRef1)
    local bx, by, bz = self.unlocker:getObjectPosition(objectRef2)
    local flags = bit.bor(0x10, 0x100, 0x1)
    local hit = self.unlocker:traceLine(ax, ay, az + 2.25, bx, by, bz + 2.25, flags);

    return hit == false
end

return WoWAPI
