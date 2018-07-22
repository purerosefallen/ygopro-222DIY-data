--Windbot-朱露咲澪
local m=57330014
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
cm.named_with_windbot=true
function cm.initial_effect(c)
	miyuki.WindbotTwinsCommonEffect(c,0)
end
