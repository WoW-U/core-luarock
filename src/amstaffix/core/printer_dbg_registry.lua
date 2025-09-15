local PrinterDbg = require("amstaffix.core.printer_dbg")

---@class PrinterDbgRegistry
local PrinterDbgRegistry = {
    ---@type Printer
    printer = nil,
    ---@type table<number, PrinterDbg>
    debugLevelToPrinter = nil,
}

---@param printer Printer
---@return PrinterDbgRegistry
function PrinterDbgRegistry:new(printer)
    ---@type PrinterDbgRegistry
    ---@diagnostic disable-next-line: missing-fields
    local o = {
        printer = printer,
        debugLevelToPrinter = {},
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param debugLevel number
---@return PrinterDbg
function PrinterDbgRegistry:get(debugLevel)
    if not self.debugLevelToPrinter[debugLevel] then
        self.debugLevelToPrinter[debugLevel] = PrinterDbg:new(self.printer, debugLevel)
    end

    return self.debugLevelToPrinter[debugLevel]
end

return PrinterDbgRegistry
