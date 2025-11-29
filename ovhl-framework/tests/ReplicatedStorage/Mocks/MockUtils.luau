--!strict
local Mock = {}

function Mock.GetPlayer()
    return {
        UserId = 12345,
        Name = "TestSubject_Alpha",
        GetAttribute = function(self, key) return 0 end, -- Default Guest
        SetAttribute = function() end
    }
end

-- Mock Bridge untuk intercept request tanpa network beneran
function Mock.GetBridge()
    return {
        _reqs = {},
        Register = function() end,
        Bind = function() end,
        Fire = function() end,
        FireAll = function() end,
        Request = function(self, s, m, ...) 
            return {
                andThen = function() return { catch = function() end } end
            }
        end
    }
end

return Mock
