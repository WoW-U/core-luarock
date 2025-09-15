---@class Printer
local Printer = {
    color = "ffcc33ff",
    prefix = "",
    currentSymbol = "░",
    ---@type boolean|nil
    isOpen = false,
}

---@param prefix string
---@param isOpen boolean|nil
---@overload fun(self:Printer, prefix:string):Printer
---@return Printer
function Printer:new(prefix, isOpen)
    assert(type(prefix) == "string", "prefix should be string")
    local currentSymbol = "░"
    if isOpen then
        currentSymbol = "║"
    end
    ---@type Printer
    local o = {
        isOpen = isOpen,
        prefix = prefix,
        currentSymbol = currentSymbol,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param msg string
---@param open boolean|nil
---@overload fun(self:Printer, msg:string)
---@private
function Printer:print(msg, open)
    assert(type(msg) == "string", "msg should be string")
    if open == true and not self.isOpen then
        self.currentSymbol = "╔"
    elseif open == false and self.isOpen then
        self.currentSymbol = "╚"
    end
    print(string.format("|c%s%s%s|r [%.2f] %s", self.color, self.currentSymbol, self.prefix, GetTime(), msg))
    if open == true and not self.isOpen then
        self.isOpen = true
        self.currentSymbol = "║"
    elseif open == false and self.isOpen then
        self.isOpen = false
        self.currentSymbol = "░"
    end
end

---@param msg string
---@param open boolean
---@overload fun(self:Printer, msg:string)
function Printer:info(msg, open)
    assert(type(msg) == "string", "msg should be string")
    return self:print(msg, open)
end

---@param msg string
---@param open boolean
---@overload fun(msg:string)
function Printer:warn(msg, open)
    assert(type(msg) == "string", "msg should be string")
    self:print(string.format("|cffff9966WARN: %s|r", msg), open)
end

---@param msg string
---@param open boolean|nil
---@overload fun(msg:string)
function Printer:err(msg, open)
    assert(type(msg) == "string", "msg should be string")
    self:print(string.format("|cffff3300ERR: %s|r", msg), open)
end

---@param msg string
---@param open boolean|nil
---@overload fun(msg:string)
function Printer:dbg(msg, open)
    assert(type(msg) == "string", "msg should be string")
    self:print(string.format("|cff00ccffDBG: %s|r", msg), open)
end

return Printer