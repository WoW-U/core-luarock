---@class PrinterDbg
local PrinterDbg = {
    ---@type Printer
    printer = nil,
    ---@type number
    debugLevel = 0,
}

---@param printer Printer
---@param debugLevel number|nil
---@overload fun(self:PrinterDbg, printer:Printer):PrinterDbg
---@return PrinterDbg
function PrinterDbg:new(printer, debugLevel)
    debugLevel = debugLevel or 0
    ---@type PrinterDbg
    ---@diagnostic disable-next-line: missing-fields
    local o = {
        printer = printer,
        debugLevel = debugLevel,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param msg string
---@param level number
---@param open boolean
---@overload fun(self:PrinterDbg, msg:string)
---@overload fun(self:PrinterDbg, msg:string,level:number)
function PrinterDbg:dbg(msg, level, open)
    if not level then
        level = 1
    end
    if type(level) ~= "number" then
        error("level should be number")
    end

    if level > self.debugLevel then
        return
    end

    return self.printer:dbg(msg, open)
end

---@param level number
---@param msg string
---@param ... string|number
function PrinterDbg:dbg2(level, msg, ...)
    assert(type(level) == "number", "level should be number")

    if level > self.debugLevel then
        return
    end

    local ok, output = pcall(string.format, msg, ...)
    if not ok then
        error(string.format("PrinterDbg:dbg2: wrong arguments for string.format: %s", output), 2)
    end
    local res = output

    return self.printer:dbg(res)
end

---@param debugLevel number
---@return PrinterDbg
function PrinterDbg:increaseDebugLevel(debugLevel)
    debugLevel = debugLevel or 0
    if debugLevel <= self.debugLevel then
        return self
    end

    return PrinterDbg:new(self.printer, debugLevel)
end

return PrinterDbg
