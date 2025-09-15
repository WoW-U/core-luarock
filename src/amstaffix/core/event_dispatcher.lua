---@class EventDispatcher
local EventDispatcher = {
    ---@type table<string, {callbackFn: fun(ctx:Context, eventName:string, payload:any), opts: {priority: number}, owner: any}[]>
    registry = {},
}

---@return EventDispatcher
function EventDispatcher:new()
    ---@type EventDispatcher
    local o = {
        registry = {},
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

---@param ctx Context
---@param eventNames string|string[]
---@deprecated Use EventDispatcher:subscribe instead
---@param callbackFn fun(ctx:Context, name:string, payload:any)
---@param opts? {priority:number}
function EventDispatcher:register(ctx, eventNames, callbackFn, opts)
    return self:subscribe(ctx, self, eventNames, callbackFn, opts)
end

---@param ctx Context
---@param owner any
---@param eventNames string|string[]
---@param callbackFn fun(ctx:Context, name:string, payload:any)
---@param opts? {priority:number}
function EventDispatcher:subscribe(ctx, owner, eventNames, callbackFn, opts)
    if not eventNames then
        return
    end
    if type(eventNames) == "string" then
        eventNames = {eventNames}
    end

    opts = opts or {}
    if opts.priority == nil then
        opts.priority = 0
    end

    for _, eventName in ipairs(eventNames) do
        if not self.registry[eventName] then
            self.registry[eventName] = {}
        end

        self.registry[eventName][#self.registry[eventName] + 1] = {callbackFn = callbackFn, opts = opts, owner = owner}

        for i = #self.registry[eventName], 2, -1 do
            if self.registry[eventName][i].opts.priority <= self.registry[eventName][i - 1].opts.priority then
                break
            end
            self.registry[eventName][i], self.registry[eventName][i - 1] = self.registry[eventName][i - 1],
                self.registry[eventName][i]
        end
    end
end

---@param ctx Context
---@param owner any
---@param eventNames string|string[]
function EventDispatcher:unsubscribe(ctx, owner, eventNames)
    if not eventNames then
        return
    end
    if type(eventNames) == "string" then
        eventNames = {eventNames}
    end

    local indexesToRemove = {}
    for _, eventName in ipairs(eventNames) do
        if self.registry[eventName] and #self.registry[eventName] > 0 then
            indexesToRemove = {}
            for i = 1, #self.registry[eventName] do
                if self.registry[eventName][i].owner == owner then
                    indexesToRemove[#indexesToRemove+1] = i
                end
            end

            for i = 1, #indexesToRemove do
                table.remove(self.registry[eventName], indexesToRemove[i])
            end
        end
    end
end

---@param ctx Context
---@param eventName string
---@param payload? any
function EventDispatcher:dispatch(ctx, eventName, payload)
    ctx.printerDbg:dbg2(2, "'%s' event has been dispatched", eventName)
    if not self.registry[eventName] then
        return
    end

    for i = 1, #self.registry[eventName], 1 do
        self.registry[eventName][i].callbackFn(ctx, eventName, payload)
    end
end

return EventDispatcher
