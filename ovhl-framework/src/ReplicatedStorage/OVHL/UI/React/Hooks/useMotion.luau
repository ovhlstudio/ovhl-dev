--!strict
-- @Hook: useMotion v1.1 (Entrance Animation Support)
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local Loader = require(RS.OVHL.Core.Loader)

local React = Loader.Get("React")
local MotionUtil = Loader.Get("MotionUtil")
local Telemetry = Loader.Get("Telemetry")

local function mapUDim2(u, cb)
    return UDim2.new(cb(u.X.Scale, 1), cb(u.X.Offset, 2), cb(u.Y.Scale, 3), cb(u.Y.Offset, 4))
end

local function packUDim2(vals)
    return UDim2.new(vals[1], vals[2], vals[3], vals[4])
end

local function unpackUDim2(u)
    return {u.X.Scale, u.X.Offset, u.Y.Scale, u.Y.Offset}
end

-- @Param goal: Target Value
-- @Param configName: Preset name
-- @Param initialValue: (Optional) Starting value to force animation from A -> B on mount
return function(goal: UDim2, configName: string?, initialValue: UDim2?)
    local startVal = initialValue or goal
    
    local binding, setBinding = React.useBinding(startVal)
    
    local stateRef = React.useRef({
        Pos = unpackUDim2(startVal),
        Vel = {0, 0, 0, 0},
        Target = unpackUDim2(goal),
        Sleeping = false -- Force awake on first render to check if Start != Target
    })
    
    local logger = React.useMemo(function() return Telemetry.New("ANIM") end, {})
    local conf = React.useMemo(function() return MotionUtil.Get(configName) end, {configName})

    React.useEffect(function()
        local s = stateRef.current
        local newTarget = unpackUDim2(goal)
        local changed = false
        for i=1,4 do if s.Target[i] ~= newTarget[i] then changed = true break end end
        
        if changed then
            s.Target = newTarget
            s.Sleeping = false
        end
    end, {goal, configName})

    React.useEffect(function()
        local conn = RunService.Heartbeat:Connect(function(dt)
            local s = stateRef.current
            if s.Sleeping then return end
            
            local safeDt = math.min(dt, 0.1)
            local isResting = true
            
            for i = 1, 4 do
                local p, v = MotionUtil.SolveSpring(s.Pos[i], s.Target[i], s.Vel[i], conf, safeDt)
                s.Pos[i] = p
                s.Vel[i] = v
                
                -- Check resting (threshold 0.1 pixel/scale unit for smoother stop)
                if math.abs(v) > 0.1 or math.abs(p - s.Target[i]) > 0.1 then
                    isResting = false
                else
                    s.Pos[i] = s.Target[i]
                    s.Vel[i] = 0
                end
            end
            
            setBinding(packUDim2(s.Pos))
            
            if isResting then
                s.Sleeping = true
            end
        end)
        return function() conn:Disconnect() end
    end, {conf})

    return binding
end
