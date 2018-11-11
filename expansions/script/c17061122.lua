--
local m=17061122
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.ffilter,cm.ffilter1,false,true)
end
function cm.ffilter(c)
	return c:IsType(TYPE_TUNER)
end
function cm.ffilter1(c)
	return not c:IsType(TYPE_TUNER)
end