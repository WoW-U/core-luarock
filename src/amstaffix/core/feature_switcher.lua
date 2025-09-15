---@class FeatureSwitcher
local FeatureSwitcher = {
    newMovement = false,
    latencyOptimization = false,
    latencyOptimizationSec = 0.27,
}

---@return FeatureSwitcher
function FeatureSwitcher:new()
    ---@type FeatureSwitcher
    local o = {
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function FeatureSwitcher:setLatencyOptimization(value)
    if value then
        self.latencyOptimization = true
    else
        self.latencyOptimization = false
    end
end

return FeatureSwitcher
