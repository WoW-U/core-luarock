---@class Error
local Error = {
    msg = "",
}

---@param msg string
---@return Error
function Error:new(msg)
    ---@type Error
    local o = {
        msg = msg,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

local notFoundError = Error:new("not found")
function Error:notFound()
    return notFoundError
end

return Error
