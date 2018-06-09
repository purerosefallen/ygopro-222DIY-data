--生命量产
local m=80000054
local cm=_G["c"..m]
cm.is_named_with_yvwan=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    
end
