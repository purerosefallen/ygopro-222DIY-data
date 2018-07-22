--Windbot-朱露咲浅羽
local m=57330015
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c57300000") end,function() require("script/c57300000") end)
cm.named_with_windbot=true
function cm.initial_effect(c)
	miyuki.WindbotTwinsCommonEffect(c,1)
end
