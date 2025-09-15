local EventMediator = require("amstaffix.core.event_mediator")

---@class ContextPerfUnit
local ContextPerfUnit = {
    ---@type string
    name = "",
    ---@type ContextPerfUnit[]
    children = {},
    ---@type number
    time = 0,
    ---@type ContextPerfUnit|nil
    parent = nil,
}

---@param name string
---@param parent? ContextPerfUnit
---@return ContextPerfUnit
function ContextPerfUnit:new(name, parent)
    ---@type ContextPerfUnit
    ---@diagnostic disable-next-line: missing-fields
    local o = {
        name = name,
        children = {},
        parent = parent,
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

---@param val number
function ContextPerfUnit:setTime(val)
    self.time = val
end

---@param name string
function ContextPerfUnit:setName(name)
    self.name = name
end

---@param node ContextPerfUnit
function ContextPerfUnit:addChild(node)
    self.children[#self.children + 1] = node
end

---@return ContextPerfUnit|nil
function ContextPerfUnit:getParent()
    return self.parent
end

---@class PerfStartMarker
---@field start number
---@field name string

local emptyPerfStartMarker = {start = 0, name = ""}

---@class Context
local Context = {
    ---@type FeatureSwitcher
    featureSwitcher = nil,
    ---@type table<string, any>
    cache = {},
    ---@type Printer
    printer = nil,
    ---@type PrinterDbg
    printerDbg = nil,
    ---@type Context
    parentCtx = nil,
    ---@type string
    reason = nil,
    ---@type boolean
    perf = false,
    ---@type ContextPerfUnit
    perfRootNode = nil,
    ---@type ContextPerfUnit
    curPerfNode = nil,
    ---@type EventMediator
    eventMediator = nil,
    ---@type PrinterDbgRegistry
    printerDbgRegistry = nil,
    ---@type number
    instanceDebugLevel = 0,
    ---@type number
    aggregatedDebugLevel = 0,
}

---@param printer Printer
---@param featureSwitcher FeatureSwitcher
---@param printerDbgRegistry PrinterDbgRegistry
---@return Context
function Context:new(printer, featureSwitcher, printerDbgRegistry)
    if not printer then error("printer is required", 2) end
    if not featureSwitcher then error("featureSwitcher is required", 2) end
    local rootNode = ContextPerfUnit:new("root")
    ---@type Context
    ---@diagnostic disable-next-line: missing-fields
    local obj = {
        cache = {},
        printer = printer,
        printerDbg = printerDbgRegistry:get(0),
        featureSwitcher = featureSwitcher,
        perfRootNode = rootNode,
        curPerfNode = rootNode,
        printerDbgRegistry = printerDbgRegistry,
    }
    obj.eventMediator = EventMediator:new(obj)

    setmetatable(obj, self)
    self.__index = self
    return obj
end

---@param debugLevel number
---@return Context
function Context:withDebugLevel(debugLevel)
    if debugLevel == nil then
        return self
    end
    if self.instanceDebugLevel >= debugLevel then
        return self
    end

    local newCtx = Context:newFromCtx(self)
    newCtx.instanceDebugLevel = debugLevel
    newCtx.aggregatedDebugLevel = self.aggregatedDebugLevel
    if newCtx.instanceDebugLevel > newCtx.aggregatedDebugLevel then
        newCtx.aggregatedDebugLevel = newCtx.instanceDebugLevel
    end
    newCtx.printerDbg = self.printerDbgRegistry:get(newCtx.aggregatedDebugLevel)

    return newCtx
end

---Change debug level of that context. Do not use it directly, use withDebugLevel instead.
---@param debugLevel number
function Context:setDebugLevel(debugLevel)
    if debugLevel == self.instanceDebugLevel then
        return
    end

    self.instanceDebugLevel = debugLevel
    local prevAggregatedDebugLevel = self.aggregatedDebugLevel
    self.aggregatedDebugLevel = debugLevel
    local parent = self.parentCtx
    while parent ~= nil do
        if parent.instanceDebugLevel > self.aggregatedDebugLevel then
            self.aggregatedDebugLevel = parent.instanceDebugLevel
        end
        parent = parent.parentCtx
    end

    if prevAggregatedDebugLevel ~= self.aggregatedDebugLevel then
        self.printerDbg = self.printerDbgRegistry:get(self.aggregatedDebugLevel)
        self.eventMediator:dispatch(self, "debug_level_changed", self, self.aggregatedDebugLevel)
    end
end

---@param parentCtx Context
---@return Context
function Context:newFromCtx(parentCtx)
    ---@type Context
    ---@diagnostic disable-next-line: missing-fields
    local newCtx = {
        cache = {},
        printer = parentCtx.printer,
        printerDbg = parentCtx.printerDbg,
        featureSwitcher = parentCtx.featureSwitcher,
        parentCtx = parentCtx,
        perf = parentCtx.perf,
        perfRootNode = parentCtx.perfRootNode,
        curPerfNode = parentCtx.curPerfNode,
        printerDbgRegistry = parentCtx.printerDbgRegistry,
        instanceDebugLevel = parentCtx.instanceDebugLevel,
        aggregatedDebugLevel = parentCtx.aggregatedDebugLevel,
    }

    newCtx.eventMediator = EventMediator:new(newCtx)

    setmetatable(newCtx, self)
    self.__index = self

    parentCtx.eventMediator:subscribe(newCtx, newCtx, "debug_level_changed", function(_, _, _, debugLevel)
        local resultDebugLevel = newCtx.instanceDebugLevel
        if resultDebugLevel < debugLevel then
            resultDebugLevel = debugLevel
        end

        if newCtx.aggregatedDebugLevel ~= resultDebugLevel then
            newCtx.aggregatedDebugLevel = resultDebugLevel
            newCtx.printerDbg = newCtx.printerDbgRegistry:get(newCtx.aggregatedDebugLevel)
            newCtx.eventMediator:dispatch(newCtx, "debug_level_changed", newCtx, newCtx.aggregatedDebugLevel)
        end
    end)

    return newCtx
end

function Context:getReason()
    if self.reason ~= nil then
        return self.reason
    end

    if self.parentCtx ~= nil then
        return self.parentCtx:getReason()
    end

    return nil
end

---@return ContextPerfUnit
function Context:getPerfRoot()
    return self.perfRootNode
end

function Context:isDone()
    return self.reason ~= nil
end

---@param reason string
function Context:done(reason)
    self.reason = reason
end

---@return boolean
function Context:isPerf()
    return self.perf
end

---@param val boolean
function Context:setPerf(val)
    self.perf = val
end

---@param name string
---@return PerfStartMarker
function Context:startPerf(name)
    if not self:isPerf() then
        return emptyPerfStartMarker
    end

    local node = ContextPerfUnit:new(name, self.curPerfNode)
    self.curPerfNode:addChild(node)
    self.curPerfNode = node

    return {start = debugprofilestop(), name = name}
end

---@param marker PerfStartMarker
function Context:collectPerf(marker)
    if not self:isPerf() then
        return
    end

    self.curPerfNode:setTime(debugprofilestop() - marker.start)
    local parentNode = self.curPerfNode:getParent()
    if parentNode ~= nil then
        self.curPerfNode = parentNode
    end
end

return Context
