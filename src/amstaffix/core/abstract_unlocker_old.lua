---@class AbstractUnlockerAdapterOld
local AbstractUnlockerAdapterOld = {
}

---@return AbstractUnlockerAdapterOld
function AbstractUnlockerAdapterOld:new()
    ---@type AbstractUnlockerAdapterOld
    ---@diagnostic disable-next-line: missing-fields
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

---@param method string
---@param url string
---@param headers table
---@param body string|nil
---@param callback fun(self:AbstractUnlockerAdapterOld, status:number,content:string)
function AbstractUnlockerAdapterOld:sendHttpRequest(method, url, headers, body, callback)
    if not method then
        error("method can not be empty")
    end
    if not url then
        error("url can not be empty")
    end

    if string.lower(method) == "get" then
        body = nil
    end

    self:doSendHttpRequest(method, url, headers, body, callback)
end

---@protected
---@param method string
---@param url string
---@param headers table
---@param body string|nil
---@param callback fun(self:AbstractUnlockerAdapterOld, status:number, content:string)
function AbstractUnlockerAdapterOld:doSendHttpRequest(method, url, headers, body, callback)
    error("doSendHttpRequest is not implemented")
end

---@param method string
---@param url string
---@param headers table
---@param body string|nil
---@overload fun(self:AbstractUnlockerAdapterOld, method:string, url:string, headers:table):Promise
---@return Promise
function AbstractUnlockerAdapterOld:sendHttpRequestDeferred(method, url, headers, body)
    if not method then
        error("method can not be empty")
    end
    if not url then
        error("url can not be empty")
    end

    if string.lower(method) == "get" then
        body = nil
    end

    local promise = deferred.new()
    self:sendHttpRequest(method, url, headers, body, function(status, content)
        local ok, err = pcall(function()
            local value = {content, status}
            if status >= 200 and status < 300 then
                promise:resolve(value)
            else
                promise:reject(value)
            end
        end)

        if not ok then
            print(err)
        end
    end)

    return promise
end

---@param x number
---@param y number
---@param z number
function AbstractUnlockerAdapterOld:clickPosition(x, y, z)
    error("not implemented")
end

---@param funcName string
---@vararg any
---@return any
function AbstractUnlockerAdapterOld:secureFuncCall(funcName, ...)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return string
function AbstractUnlockerAdapterOld:getObjectGUID(unit)
    error("not implemented")
end

---@param x number
---@param y number
---@param z number
---@return number x, number y, boolean isOnScreen
function AbstractUnlockerAdapterOld:worldToScreen(x, y, z)
    error("not implemented")
end

---@return number
function AbstractUnlockerAdapterOld:getObjectCount()
    error("not implemented")
end

---@param index number
---@return UniversalUnitPointer unit
function AbstractUnlockerAdapterOld:getRawObjectWithIndex(index)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return string
function AbstractUnlockerAdapterOld:getObjectName(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return ObjectID
function AbstractUnlockerAdapterOld:getObjectID(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getObjectType(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getUnitCreatureTypeId(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return boolean
function AbstractUnlockerAdapterOld:getObjectIsQuestObjective(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return boolean
function AbstractUnlockerAdapterOld:getUnitIsLootable(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return boolean
function AbstractUnlockerAdapterOld:getUnitIsSubmerged(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getUnitNpcFlags(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getUnitFlags(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return UniversalUnitPointer|nil
function AbstractUnlockerAdapterOld:getUnitTarget(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
function AbstractUnlockerAdapterOld:setTarget(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@param otherUnit UniversalUnitPointer
---@return number facing, number pitch
function AbstractUnlockerAdapterOld:getAnglesBetweenUnits(unit, otherUnit)
    error("not implemented")
end

---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@return number facing, number pitch
function AbstractUnlockerAdapterOld:getAnglesBetweenPositions(x1, y1, z1, x2, y2, z2)
    error("not implemented")
end

---@param radians number
---@param update boolean
function AbstractUnlockerAdapterOld:faceDirection(radians, update)
    error("not implemented")
end

---@param radians number
function AbstractUnlockerAdapterOld:setPitch(radians)
    error("not implemented")
end

---@param unit UniversalUnitPointer
function AbstractUnlockerAdapterOld:interact(unit)
    error("not implemented")
end

---@param x number
---@param y number
---@param z number
function AbstractUnlockerAdapterOld:clickToMove(x, y, z)
    error("not implemented")
end

---@return number x, number y, number z
function AbstractUnlockerAdapterOld:getCorpsePosition()
    error("not implemented")
end

---@param mapID number
---@param x1 number
---@param y1 number
---@param z1 number
---@param x2 number
---@param y2 number
---@param z2 number
---@param swim boolean
---@return number >0 have some points to navigate, 0 - player is near the point, -1 - invalid map data, -2 out of memory, -3 map caching
function AbstractUnlockerAdapterOld:findPath(mapID, x1, y1, z1, x2, y2, z2, swim)
    error("not implemented")
end

--- index 1 is always current player if player is not at close proximity to destination
---@param index number
---@return number x, number y, number z
function AbstractUnlockerAdapterOld:getPathNode(index)
    error("not implemented")
end

---@return number x, number y, number z
function AbstractUnlockerAdapterOld:getCameraPosition()
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number type
function AbstractUnlockerAdapterOld:getGameObjectType(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return boolean exists
function AbstractUnlockerAdapterOld:isObjectExists(unit)
    error("not implemented")
end

---@param text string
function AbstractUnlockerAdapterOld:setClipboardText(text)
    error("not implemented")
end

---@return string
function AbstractUnlockerAdapterOld:getClipboardText()
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getUnitFlags2(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getUnitFlags3(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return boolean
function AbstractUnlockerAdapterOld:getUnitIsOutdoors(unit)
    error("not implemented")
end

---@param unit UniversalUnitPointer
---@return number
function AbstractUnlockerAdapterOld:getUnitStandStateType(unit)
    error("not implemented")
end









return AbstractUnlockerAdapterOld
