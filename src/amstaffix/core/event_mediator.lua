---@alias EventMediatorCallback fun(ctx:Context, eventName:string, sourceObj:any, payload:any)
---@class EventMediatorSubscriber
local EventMediatorSubscriber = {
    ---@type any
    owner = nil,
    ---@type EventMediatorCallback
    callbackFn = nil,
    ---@type string
    eventName = nil,
}

---@class EventMediator
local EventMediator = {
    ---@type any
    obj = nil,
    ---@type EventMediatorSubscriber[]
    subscribers = nil,
    ---@type number
    subscribersLen = 0,
}

---@param obj any
---@return EventMediator
function EventMediator:new(obj)
    ---@type EventMediator
    ---@diagnostic disable-next-line: missing-fields
    local o = {
        obj = obj,
        subscribers = {},
        subscribersLen = 0,
    }
    setmetatable(o, self)
    self.__index = self

    return o
end

---@param ctx Context
---@param eventName string
---@param obj any
---@param payload any?
function EventMediator:dispatch(ctx, eventName, obj, payload)
    for i = 1, self.subscribersLen do
        local sub = self.subscribers[i]
        if sub.eventName == eventName then
            sub.callbackFn(ctx, eventName, obj, payload)
        end
    end
end

---@param ctx Context
---@param owner any
---@param eventName? string
function EventMediator:unsubscribe(ctx, owner, eventName)
    local i = 1
    while i <= self.subscribersLen do
        local sub = self.subscribers[i]
        if sub.owner == owner and (not eventName or sub.eventName == eventName) then
            self.subscribers[i], self.subscribers[#self.subscribers] = self.subscribers[#self.subscribers],
                self.subscribers[i]
            self.subscribersLen = self.subscribersLen - 1
        end
        i = i + 1
    end
end

---@param ctx Context
---@param owner any
---@param eventName string
---@param callbackFn EventMediatorCallback
function EventMediator:subscribe(ctx, owner, eventName, callbackFn)
    self.subscribersLen = self.subscribersLen + 1
    self.subscribers[self.subscribersLen] = {
        owner = owner,
        callbackFn = callbackFn,
        eventName = eventName,
    }
end

return EventMediator